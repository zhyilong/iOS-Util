//
//  NSURLSession+YLNetWorkFrame.h
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YLNetWorkFrame.h"

@class YLUrlSession;

typedef void(^YLNetCallBack)(YLUrlSession* session, NSData* data, id userdata, NSError* error);

@interface YLUrlSession : NSObject

///private
@property(nonatomic, strong)   NSURLSession*          session;
@property(nonatomic, strong)   NSURLSessionTask*  task;
@property(nonatomic, weak)    NSObject*                   owner;
@property(nonatomic, strong)  id                                 userData;
//V1.1
@property(nonatomic, strong) dispatch_source_t       timer;

- (void)setOwner:(NSObject*)owner;
- (void)setSessionTask:(NSURLSessionTask*)task;
- (NSURLSessionTask*)getSessionTask;

- (void)resume;
- (void)suspend;
//V1.1
- (void)cancelTimer;

///public
- (void)cancel;

@end
