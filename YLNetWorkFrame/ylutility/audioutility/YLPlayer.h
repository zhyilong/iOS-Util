//
//  YLPlayer.h
//  QQCar
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class YLPlayer;

typedef void(^YLPlayerCallback)(YLPlayer* player, NSInteger state);

@interface YLPlayer : NSObject <AVAudioPlayerDelegate>

@property(nonatomic, copy) YLPlayerCallback     callback;

+ (YLPlayer*)currentPlayer;

- (instancetype)initWithFile:(NSString*)file;
- (instancetype)initWithData:(NSData*)data;
- (BOOL)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;

@end
