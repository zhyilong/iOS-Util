//
//  YLRecorder.m
//  QQCar
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLRecorder.h"

#define BufferCount     10
#define BufferSize      20480

@implementation YLRecorder
{
    AVAudioRecorder*                recorder;
    
    AudioQueueRef                   audioQuene;
    AudioStreamBasicDescription     streamDes;
    SInt64                          recordPacket;
    AudioFileID                     outFile;
    AudioQueueBufferRef             buffers[BufferCount];
    BOOL                            isRecording;
    NSTimer*                        maxTimer;
    
    FILE*                           tagFile;
    int                             MP3_SIZE;
    unsigned char*                  pmp3_buffer;
    lame_t                          lame;
}

static YLRecorder* _instance = nil;

@synthesize callback;
@synthesize filePath;
@synthesize isClear;
@synthesize mp3FilePath;
@synthesize isAudioQuene;
@synthesize maxSeconds;

+ (YLRecorder*)currentYLRecorder
{
    return _instance;
}

- (void)dealloc
{
    self.callback = nil;
    
    [maxTimer invalidate];
    maxTimer = nil;
    
    if (isAudioQuene)
    {
        if (isRecording)
        {
            if (audioQuene) AudioQueueStop(audioQuene, true);
        }
        
        if (audioQuene) AudioQueueDispose(audioQuene, true);
        if (outFile) AudioFileClose(outFile);
        if (tagFile) fclose(tagFile);
        if (pmp3_buffer) free(pmp3_buffer);
        if (lame) lame_close(lame);
    }
    else
    {
        if (recorder.isRecording)
        {
            [recorder stop];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        callback = nil;
        isClear = YES;
        isRecording = NO;
        isAudioQuene = YES;
        maxSeconds = 0;
        maxTimer = nil;
        
        outFile = NULL;
        tagFile = NULL;
        audioQuene = NULL;
        pmp3_buffer = NULL;
        lame = NULL;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        filePath = [NSString stringWithFormat:@"%@/Documents/record.caf", NSHomeDirectory()];
        mp3FilePath = [NSString stringWithFormat:@"%@/Documents/record.mp3", NSHomeDirectory()];
        
        if (!isAudioQuene)
        {
            NSError* error = nil;
            recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:filePath] settings:[self getAudioSetting] error:&error];
        }
        else
        {
            [self initAudioQuene];
        }
        
        _instance = self;
    }
    
    return self;
}

-(NSDictionary *)getAudioSetting
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    
    return dicM;
}

- (void)setAudioDelegate:(id<AVAudioRecorderDelegate>)delegate
{
    recorder.delegate = delegate;
}

- (void)initAudioQuene
{
    recordPacket = 0;
    memset(&streamDes, 0, sizeof(streamDes));
    
    // 采样率 (立体声 = 8000)
    streamDes.mSampleRate = 11025.0;
    // PCM 格式
    streamDes.mFormatID = kAudioFormatLinearPCM;
    streamDes.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    // 1:单声道；2:立体声
    streamDes.mChannelsPerFrame = 1;
    // 语音每采样点占用位数
    streamDes.mBitsPerChannel = 16;
    //每桢的bytes数
    streamDes.mBytesPerFrame = (streamDes.mBitsPerChannel / 8)  * streamDes.mChannelsPerFrame;
    //每个数据包下的桢数，即每个数据包里面有多少桢
    streamDes.mFramesPerPacket = 1;
    //每个数据包的bytes总数，每桢的bytes数*每个数据包的桢数
    streamDes.mBytesPerPacket = streamDes.mBytesPerFrame * streamDes.mFramesPerPacket;
    
    //创建队列
    AudioQueueNewInput(&streamDes, handleBufferFull, (__bridge void * _Nullable)(self), NULL, NULL, 0, &audioQuene);
    
    //创建缓冲
    for (int i=0; i<BufferCount; i++)
    {
        AudioQueueAllocateBuffer(audioQuene, BufferSize, &buffers[i]);
        AudioQueueEnqueueBuffer(audioQuene, buffers[i], 0, nil);
    }
}

- (void)initLame
{
    MP3_SIZE = BufferSize;
    pmp3_buffer = (unsigned char*)malloc(MP3_SIZE * sizeof(short));
    
    lame = lame_init();
    lame_set_in_samplerate(lame, 11025.0);//22050
    lame_set_out_samplerate(lame, 11025.0);
    lame_set_VBR(lame, vbr_default);
    lame_set_num_channels(lame, 1); //双声道，这个OK
    lame_set_brate(lame, 16);       //16kBps
    lame_set_quality(lame, 5);      //中等的
    lame_init_params(lame);
}

- (void)startRecord
{
    if (isAudioQuene)
    {
        //create the audio file
        CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)filePath, NULL);
        AudioFileCreateWithURL(url, kAudioFileCAFType, &streamDes, kAudioFileFlags_EraseFile, &outFile);
        CFRelease(url);
        
        //output 输出生成的Mp3文件位置
        tagFile = fopen([mp3FilePath cStringUsingEncoding:1], "wb");

        [self initLame];

        AudioQueueStart(audioQuene, nil);
        
        //录音时长
        if (maxSeconds > 0) maxTimer = [NSTimer scheduledTimerWithTimeInterval:maxSeconds target:self selector:@selector(maxTimeFire) userInfo:nil repeats:NO];
    }
    else
    {
        [recorder record];
    }
    
    isRecording = YES;
}

- (void)stopRecord
{
    [maxTimer invalidate];
    maxTimer = nil;
    
    BOOL b = isRecording;
    isRecording = NO;
    
    if (isAudioQuene)
    {
        AudioQueueStop(audioQuene, true);
        AudioFileClose(outFile);
        fclose(tagFile);
        lame_close(lame);
        
        outFile = NULL;
        tagFile = NULL;
        lame = NULL;
        
        recordPacket = 0;
        AudioQueueReset(audioQuene);
        
        for (int i=0; i<BufferCount; i++)
        {
            AudioQueueEnqueueBuffer(audioQuene, buffers[i], 0, nil);
        }
    }
    else
    {
        [recorder stop];
        
        [self convertToMP3];
    }
    
    if (callback && b) callback(self, 0);
}

- (BOOL)isRecording
{
    return isRecording;
}

- (void)maxTimeFire
{
    maxTimer = nil;
    [self stopRecord];
}

static void handleBufferFull(void * __nullable               inUserData,
                             AudioQueueRef                   inAQ,
                             AudioQueueBufferRef             inBuffer,
                             const AudioTimeStamp *          inStartTime,
                             UInt32                          inNumberPacketDescriptions,
                             const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    YLRecorder* recorder = (__bridge YLRecorder*)inUserData;
    
    if (recorder.isRecording)
    {
        [recorder saveBufferToFile:inBuffer PacketDes:inPacketDescs IONumPackets:inNumberPacketDescriptions];
        
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
        
        NSLog(@"^_^ >>>>>> handleBufferFull");
    }
}

- (void)saveBufferToFile:(AudioQueueBufferRef)buffer PacketDes:(const AudioStreamPacketDescription *)packetdes IONumPackets:(UInt32)ionumpackets
{
    if (ionumpackets > 0)
    {
        AudioFileWritePackets(outFile, FALSE, buffer->mAudioDataByteSize, packetdes, recordPacket, &ionumpackets, buffer->mAudioData);
        recordPacket += ionumpackets;
        
        [self PCMtoMP3:buffer IONumPackets:ionumpackets];
    }
}

- (void)PCMtoMP3:(AudioQueueBufferRef)buffer IONumPackets:(UInt32)ionumpackets
{
    int encodedBytes = 0;
    
    //int MP3_SIZE = buffer->mAudioDataByteSize * 4;
    //unsigned char mp3_buffer[MP3_SIZE];

    if (0 == ionumpackets)
    {
        encodedBytes = lame_encode_flush(lame, pmp3_buffer, MP3_SIZE);
    }
    else
    {
        encodedBytes = lame_encode_buffer(lame, (short int*)buffer->mAudioData,  (short int*)buffer->mAudioData, ionumpackets, pmp3_buffer, MP3_SIZE);
    }
    
    fwrite(pmp3_buffer, encodedBytes, 1, tagFile);
}

- (void)convertToMP3
{
    @try
    {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");    //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);                                //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCMSIZE = BufferSize;
        const int MP3SIZE = BufferSize;
        short int pcm_buffer[PCMSIZE * 2];
        unsigned char mp3_buffer[MP3SIZE];
        
        lame_t lamet = lame_init();
        lame_set_in_samplerate(lamet, 11025.0);
        lame_set_VBR(lamet, vbr_default);
        lame_init_params(lamet);
        
        do
        {
            read = fread(pcm_buffer, 2*sizeof(short int), PCMSIZE, pcm);
            if (read == 0)
            {
                write = lame_encode_flush(lamet, mp3_buffer, MP3SIZE);
            }
            else
            {
                write = lame_encode_buffer_interleaved(lamet, pcm_buffer, read, mp3_buffer, MP3SIZE);
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lamet);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [exception description]);
    }
    @finally
    {
        NSLog(@"MP3生成成功: %@", mp3FilePath);
    }
}

@end
