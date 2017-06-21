//
//  YLRecorder.h
//  QQCar
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "lame.h"

@class YLRecorder;

typedef void(^YLRecorderCallback)(YLRecorder* recorder, NSInteger state);

@interface YLRecorder : NSObject

@property(nonatomic, copy) YLRecorderCallback       callback;
@property(nonatomic, strong, readonly) NSString*    filePath;
@property(nonatomic, assign) BOOL                   isClear;
@property(nonatomic, strong, readonly) NSString*    mp3FilePath;
@property(nonatomic, assign) BOOL                   isAudioQuene;
@property(nonatomic, assign) NSInteger              maxSeconds;

+ (YLRecorder*)currentYLRecorder;

- (void)setAudioDelegate:(id<AVAudioRecorderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (BOOL)isRecording;
- (void)convertToMP3;

@end
