//
//  UIImageView+YLNetWorkFrame.h
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImageViewCallback)(UIImageView* view, NSError* error);

@interface UIImageView (YLNetWorkFrame)

+ (NSString*)getHomeDirectory;
+ (BOOL)setCachePath:(NSString*)cachepath;
+ (NSString*)clearCache;
+ (BOOL)clearCacheWithPath:(NSString*)path;
+ (BOOL)saveDataToCache:(NSData*)data Name:(NSString*)name;
+ (BOOL)removeDataFromCache:(NSString*)name;
+ (NSData*)getDataFromCache:(NSString*)name;

- (void)cancelDownload;
- (void)setDataWithUrl:(NSString*)url IsLoadCache:(BOOL)isloadcache CacheName:(NSString*)cachename CallBack:(UIImageViewCallback)callback;

@end
