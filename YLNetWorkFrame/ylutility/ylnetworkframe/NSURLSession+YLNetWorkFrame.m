//
//  NSURLSession+YLNetWorkFrame.m
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "NSURLSession+YLNetWorkFrame.h"

@implementation YLUrlSession

@synthesize session;
@synthesize task;
@synthesize owner;
@synthesize userData;
@synthesize timer;

- (void)dealloc
{
    [self cancel];
    NSLog(@"zhyilong - YLUrlSession dealloc");
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        session = nil;
        owner = nil;
        task = nil;
        userData = nil;
        timer = 0;
        
        return self;
    }
    
    return nil;
}

- (void)setOwner:(NSObject*)Owner
{
    if (Owner)
    {
        owner = Owner;
        /*V1.0
        [owner setUrlSessions];
        [owner insertUrlSession:self Key:[NSString stringWithFormat:@"%0x", self]];
        */
        
        /*V1.1*/
        [[owner getNetObject] addUrlSession:self];
    }
}

- (NSObject*)getOwner
{
    return self.owner;
}

- (void)setSessionTask:(NSURLSessionTask*)Task
{
    task = Task;
}

- (NSURLSessionTask*)getSessionTask
{
    return task;
}

- (void)resume
{
    if (task) [task resume];
    
    [self startTimer];
}

- (void)suspend
{
    if (task) [task suspend];
}

- (void)cancel
{
    //V1.1
    //取消定时器
   [self cancelTimer];
    
    [session invalidateAndCancel];
    
    /*V1.1*/
    [[owner getNetObject] removeUrlSession:self];
}

- (void)startTimer
{
    if (timer > 0)
    {
        dispatch_resume(timer);
    }
}

- (void)cancelTimer
{
    if (timer > 0)
    {
        dispatch_cancel(timer);
        timer = 0;
    }
}

//private

@end
