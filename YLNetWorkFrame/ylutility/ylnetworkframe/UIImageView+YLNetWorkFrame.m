//
//  UIImageView+YLNetWorkFrame.m
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "UIImageView+YLNetWorkFrame.h"
#import "YLNetWorkManager.h"

@implementation UIImageView (YLNetWorkFrame)

static NSString*    _cachePath = nil;

- (void)dealloc
{
    [self cancelDownload];
    
    NSLog(@"zhyilong - UIImageView dealloc");
}

+ (NSString*)getHomeDirectory
{
    return NSHomeDirectory();
}

+ (BOOL)setCachePath:(NSString *)cachepath
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    
    if (![filemanager fileExistsAtPath:cachepath isDirectory:&isDirectory])
    {
        NSError* error = nil;
        if (![filemanager createDirectoryAtPath:cachepath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"zhyilong - create imageview.chache failed!");
            
            return NO;
        }
    }
    
    _cachePath = cachepath;
    
    return YES;
}

+ (NSString*)clearCache
{
    if (_cachePath)
    {
        NSFileManager* filemanager = [NSFileManager defaultManager];
        
        NSError* error = nil;
        if (![filemanager removeItemAtPath:_cachePath error:&error])
        {
            NSLog(@"zhyilong - clear imageview.cache failed!");
        }
    }
    else
    {
        NSLog(@"zhyilong - clear imageview.cache filed so path is null!");
    }
    
    return _cachePath;
}

+ (BOOL)clearCacheWithPath:(NSString*)path
{
    //清楚原先的路径
    if ([_cachePath length] > 0) [self clearCache];
    
    if ([path length] > 0) _cachePath = path;
    
    [self clearCache];
    
    return YES;
}

+ (BOOL)saveDataToCache:(NSData*)data Name:(NSString*)name
{
    if (_cachePath && data && name)
    {
        NSString* path = [NSString stringWithFormat:@"%@/%@", _cachePath, name];
        if ([data writeToFile:path atomically:YES])
        {
            return YES;
        }
        else
        {
            NSLog(@"zhyilong - save data to cache failed!");
        }
    }
    
    return NO;
}

+ (BOOL)removeDataFromCache:(NSString*)name
{
    if (_cachePath && name)
    {
        NSFileManager* filemanager = [NSFileManager defaultManager];
        NSString* path = [NSString stringWithFormat:@"%@/%@", _cachePath, name];
        NSError* error = nil;
        
        return [filemanager removeItemAtPath:path error:&error];
    }
    
    return NO;
}

+ (NSData*)getDataFromCache:(NSString*)name
{
    NSData* data = nil;
    
    if (_cachePath && name)
    {
        NSString* path = [NSString stringWithFormat:@"%@/%@", _cachePath, name];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    return data;
}

- (void)cancelDownload
{
    //V1.0
    //[self clearYLNetWork];
    
    //V1.1
    [[self getNetObject] clearNetSession];
}

- (void)setDataWithUrl:(NSString*)url IsLoadCache:(BOOL)isloadcache CacheName:(NSString*)cachename CallBack:(UIImageViewCallback)callback
{
    [self cancelDownload];
    
    //从缓存中加载
    if (isloadcache && [cachename length] > 0)
    {
        NSData* data = [UIImageView getDataFromCache:cachename];
        if (data)
        {
            if ([data bytes] > 0)
            {
                //从缓存中获得成功返回
                UIImage* image = [UIImage imageWithData:data];
                if (image)
                {
                    self.image = image;
                    if (callback) callback(self, nil);
                    return;
                }
            }
            else
            {
                NSError* error = [NSError errorWithDomain:@"缓存数据错误" code:1001 userInfo:nil];
                [self helperNetResponse:nil Error:error CallBack:callback CacheName:cachename];
                return;
            }
        }
    }
    
    //缓存中不存在或者从网络下载
    if (url)
    {
        __weak typeof(self) imagev = self;
        [[YLNetWorkManager Default] downLoad:url TimeOut:0 CallBack:^(YLUrlSession *session, NSData *data, id userdata, NSError *error) {
            [imagev helperNetResponse:data Error:error CallBack:callback CacheName:cachename];
        } Owner:self UserData:nil];
    }
    else
    {
        NSError* error = [NSError errorWithDomain:@"url为空" code:1001 userInfo:nil];
        [self helperNetResponse:nil Error:error CallBack:callback CacheName:cachename];
    }
}

- (void)helperNetResponse:(NSData*)data Error:(NSError*)error CallBack:(UIImageViewCallback)callback CacheName:(NSString*)cachename
{
    NSError* eor = error;
    
    if (!error && data)
    {
        UIImage* image = [[UIImage alloc] initWithData:data];
        if (image)
        {
            if (cachename) [UIImageView saveDataToCache:data Name:cachename];
            
            self.image = image;
        }
        else
        {
            eor = [NSError errorWithDomain:@"图片字节数为零" code:1002 userInfo:nil];
        }
    }
    
    if (callback) callback(self, eor);
}

@end
