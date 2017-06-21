//
//  YLNetWorkManager.h
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+YLNetWorkFrame.h"

@class YLUrlSession;

#define HEADER          @"\r\n-----------------------------0x0x0x0x0x0x0x0x\r\n"
#define IMAGE_CONTNET   @"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n"
//“userfile”是服务上的文件域，类似上传后的保存路径可以这样理解；”image.jpg“是自定义的不是上传目标的名称。
#define CONTENTTYPE     @"Content-Type: application/octet-stream\r\n\r\n"
//上传类型，是必要的
#define MULTIPART       @"multipart/form-data; boundary=---------------------------0x0x0x0x0x0x0x0x"
//报头
#define END             @"\r\n-----------------------------0x0x0x0x0x0x0x0x--\r\n"

@interface YLNetWorkManager : NSObject <NSURLSessionDelegate>

+ (YLNetWorkManager*)Default;

//utility
+ (NSString*)GBKUrlToUTF8Url:(NSString*)gbkurl;
+ (void)setBinaryData:(NSMutableData*)data Name:(NSString*)name Value:(NSData*)value;
+ (void)setBinaryFileData:(NSMutableData*)data Name:(NSString*)name Value:(NSData*)value FileName:(NSString*)filename Type:(NSString*)type;

- (void)removeSession:(YLUrlSession*)session;
- (YLUrlSession*)get:(NSString*)url TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata;
- (YLUrlSession*)post:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata;
- (YLUrlSession*)postJson:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata;
- (YLUrlSession*)downLoad:(NSString*)url TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata;
- (YLUrlSession*)uploadBinary:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata;

@end
