//
//  YLNetWorkManager.m
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLNetWorkManager.h"
#import <sys/sysctl.h>
#import "NSURLSession+YLNetWorkFrame.h"

@implementation YLNetWorkManager
{
    NSOperationQueue*                                 _operationQuene;
    NSMutableDictionary<NSString*, YLUrlSession*>*    _sessions;
}

static YLNetWorkManager*   _instance = nil;

- (void)dealloc
{
    [_operationQuene cancelAllOperations];
    _operationQuene = nil;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (!_instance)
        {
            _instance = [super allocWithZone:zone];
        }
    }
    
    return _instance;
}

+ (YLNetWorkManager*)Default
{
    if (!_instance)
    {
        _instance = [[YLNetWorkManager alloc] init];
    }
    
    return _instance;
}

+ (NSString*)GBKUrlToUTF8Url:(NSString *)gbkurl
{
    CFStringRef sUrl = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)gbkurl, nil, nil, kCFStringEncodingUTF8);
    NSString* ret = [NSString stringWithString:(__bridge NSString*)sUrl];
    
    CFRelease(sUrl);
    
    return ret;
}

+ (void)setBinaryData:(NSMutableData*)data Name:(NSString*)name Value:(NSData*)value
{
    // 参数分割
    [data appendData:[@"--mj\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 参数描述
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 参数值
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:value];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

//filename - xxx.png; type - image/png
+ (void)setBinaryFileData:(NSMutableData*)data Name:(NSString*)name Value:(NSData*)value FileName:(NSString*)filename Type:(NSString*)type
{
    NSString* str = nil;
    
    // 文件参数-file
    // 文件参数开始的一个标记
    [data appendData:[@"--mj\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 文件参数描述
    str = [NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 文件的MINETYPE
    str = [NSString stringWithFormat:@"Content-Type:%@\r\n", type];
    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 文件内容
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:value];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //获得cup的核心数量
        NSInteger corenum = 0;
        size_t len =  sizeof(corenum);
        sysctlbyname("hw.ncpu", &corenum, &len, NULL, 0);
        
        _operationQuene = [[NSOperationQueue alloc] init];
        //同时执行的线程数量为cpu的核心数量
        _operationQuene.maxConcurrentOperationCount = corenum;
        
        //存放网络请求
        _sessions = [NSMutableDictionary dictionary];
        
        return self;
    }
    
    return nil;
}

//private method
- (void)insertSession:(YLUrlSession*)session Key:(NSString*)key
{
    if (session && key) [_sessions setObject:session forKey:key];
}

- (void)removeSessionForKey:(NSString*)key
{
    if (key)
    {
        YLUrlSession* session = [_sessions objectForKey:key];
        if (session)
        {
            [session cancel];
            [_sessions removeObjectForKey:key];
        }
    }
}

- (NSError*)resetSysError:(NSError*)error
{
    if (error)
    {
        NSString* description = nil;
        
        switch (error.code)
        {
            case NSURLErrorCannotFindHost:
                description = @"无法找到主机";
                break;
            case NSURLErrorCannotConnectToHost:
                description = @"不能连接到服务器";
                break;
            case NSURLErrorNotConnectedToInternet:
                description = @"不能访问互联网";
                break;
            case NSURLErrorTimedOut:
                description = @"网络请求超时";
                break;
            default:
                description = @"未知错误";
                break;
        }
        
        NSError* uerror = [NSError errorWithDomain:description code:error.code userInfo:nil];
        
        return uerror;
    }
    
    return nil;
}

//V1.1
- (YLUrlSession*)createUrlSession:(NSMutableURLRequest*)request Owner:(NSObject*)owner UserData:(id)userdata CallBack:(YLNetCallBack)callback
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.timeoutIntervalForRequest = request.timeoutInterval;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:_operationQuene];
    
    NSInteger adr = (NSInteger)session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    YLUrlSession* unsession = [[YLUrlSession alloc] init];
    unsession.session = session;
    unsession.userData = userdata;
    [unsession setOwner:owner];
    [self insertSession:unsession Key:key];
    
    //设置定时器
    if (request.timeoutInterval > 0)
    {
        unsession.timer = [self createGCDTimer:request.timeoutInterval CallBack:callback Session:unsession];
    }
    
    return unsession;
}

//V1.1
- (dispatch_source_t)createGCDTimer:(NSInteger)time CallBack:(YLNetCallBack)callback Session:(YLUrlSession*)session
{
    __weak typeof(YLUrlSession) *blocksession = session;
    __weak typeof(self) center = self;
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(time * NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        
        //取消请求
        [blocksession cancel];
        //取消定时器
        [blocksession cancelTimer];
        //从owner中删除
        [[blocksession.owner getNetObject] removeUrlSession:blocksession];
        
        //回调
        NSInteger adr = (NSInteger)blocksession.session;
        NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
        dispatch_async(dispatch_get_main_queue(), ^{

            NSError* uerror = [NSError errorWithDomain:@"网络请求超时" code:NSURLErrorTimedOut userInfo:nil];
            if (callback) callback(blocksession, nil, blocksession.userData, uerror);
            
            //删除session
            [center removeSessionForKey:key];
            
        });
        
    });
    
    return timer;
}

- (YLUrlSession*)setDataTaskWithRequest:(NSMutableURLRequest*)request CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    YLUrlSession* unsession = [self createUrlSession:request Owner:owner UserData:userdata CallBack:callback];
    NSInteger adr = (NSInteger)unsession.session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    
    __weak typeof(YLUrlSession) *blocksession = unsession;
    __weak typeof(self) center = self;
    NSURLSessionDataTask* task = [unsession.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //V1.1
        //取消定时器
        [blocksession cancelTimer];
        //从owner中删除
        [[blocksession.owner getNetObject] removeUrlSession:blocksession];
        
        //请求完成将消息投递到住队列里，更新ui等
        dispatch_async(dispatch_get_main_queue(), ^{NSLog(@"%@", blocksession);
            if (callback) callback(blocksession, data, blocksession.userData, [center resetSysError:error]);
        });
        
        //V1.0
        //[blocksession.owner removeUrlSession:blocksession];
        
        //删除session
        [center removeSessionForKey:key];
        
    }];
    
    [unsession setTask:task];
    
    [unsession resume];
    
    return unsession;
}

- (YLUrlSession*)setDownloadTaskWithReuest:(NSMutableURLRequest*)request CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    YLUrlSession* unsession = [self createUrlSession:request Owner:owner UserData:userdata CallBack:callback];
    NSInteger adr = (NSInteger)unsession.session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    
    __weak typeof(YLUrlSession) *blocksession = unsession;
    __weak typeof(self) center = self;
    NSURLSessionDownloadTask* task = [unsession.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //V1.1
        //取消定时器
        [blocksession cancelTimer];
        //从owner中删除
        [[blocksession.owner getNetObject] removeUrlSession:blocksession];
        
        NSData* data = nil;
        if (location) data = [NSData dataWithContentsOfURL:location];
        
        __weak typeof(NSData) *img = data;
        
        //请求完成将消息投递到住队列里，更新ui等
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) callback(blocksession, img, blocksession.userData, [center resetSysError:error]);
        });
        
        //V1.0
        //[blocksession.owner removeUrlSession:blocksession];
        
        [center removeSessionForKey:key];
        
    }];
    
    [unsession setSessionTask:task];
    
    [unsession resume];
    
    return unsession;
}

- (YLUrlSession*)setUploadBinaryTaskWithRequest:(NSMutableURLRequest*)request Data:(NSData*)data CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    YLUrlSession* unsession = [self createUrlSession:request Owner:owner UserData:userdata CallBack:callback];
    NSInteger adr = (NSInteger)unsession.session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    
    __weak typeof(YLUrlSession) *blocksession = unsession;
    __weak typeof(self) center = self;
    NSURLSessionUploadTask* task = [unsession.session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //V1.1
        //取消定时器
        [blocksession cancelTimer];
        //从owner中删除
        [[blocksession.owner getNetObject] removeUrlSession:blocksession];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) callback(blocksession, data, blocksession.userData, [center resetSysError:error]);
        });
        
        //V1.0
        //[blocksession.owner removeUrlSession:blocksession];
        
        [center removeSessionForKey:key];
        
    }];
    
    [unsession setSessionTask:task];
    
    [unsession resume];
    
    return unsession;
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    NSInteger adr = (NSInteger)session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    [self removeSessionForKey:key];
}


//public method
- (void)removeSession:(YLUrlSession*)session
{
    NSInteger adr = (NSInteger)session;
    NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
    [self removeSessionForKey:key];
}

- (YLUrlSession*)get:(NSString*)url TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:timeout];

    return [self setDataTaskWithRequest:request CallBack:callback Owner:owner UserData:userdata];
}

- (YLUrlSession*)post:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:timeout];
    [request setHTTPBody:data];
    
    return [self setDataTaskWithRequest:request CallBack:callback Owner:owner UserData:userdata];
}

- (YLUrlSession*)postJson:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:timeout];
    [request setHTTPBody:data];
    
    return [self setDataTaskWithRequest:request CallBack:callback Owner:owner UserData:userdata];
}

- (YLUrlSession*)downLoad:(NSString*)url TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:timeout];
    
    return [self setDownloadTaskWithReuest:request CallBack:callback Owner:owner UserData:userdata];
}

- (YLUrlSession*)uploadBinary:(NSString*)url Data:(NSData*)data TimeOut:(NSInteger)timeout CallBack:(YLNetCallBack)callback Owner:(NSObject*)owner UserData:(id)userdata
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"multipart/form-data; boundary=mj" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:timeout];
    
    NSMutableData *postdata = [NSMutableData data];
    [postdata appendData:data];
    [postdata appendData:[@"--mj--" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [self setUploadBinaryTaskWithRequest:request Data:postdata CallBack:callback Owner:owner UserData:userdata];
}

@end
