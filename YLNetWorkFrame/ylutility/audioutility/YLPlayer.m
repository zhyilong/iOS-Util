//
//  YLPlayer.m
//  QQCar
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLPlayer.h"

@implementation YLPlayer
{
    AVAudioPlayer*      player;
}

static YLPlayer* _instance = nil;

@synthesize callback;

+ (YLPlayer*)currentPlayer
{
    return _instance;
}

- (void)dealloc
{
    self.callback = nil;
}

- (instancetype)initWithFile:(NSString*)file
{
    self = [super init];
    
    if (self)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        NSError* error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:file] error:&error];
        player.delegate = self;
        
        _instance = self;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    
    if (self)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        NSError* error = nil;
        player = [[AVAudioPlayer alloc] initWithData:data error:&error];
        
        _instance = self;
    }
    
    return self;
}

- (BOOL)play
{
    return [player play];
}

- (void)pause
{
    [player pause];
}

- (void)stop
{
    [player stop];
}

- (BOOL)isPlaying
{
    return [player isPlaying];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (callback) callback(self, 0);
}

@end
