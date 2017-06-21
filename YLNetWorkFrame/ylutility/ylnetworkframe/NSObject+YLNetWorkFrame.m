//
//  NSObject+YLNetWorkFrame.m
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "NSObject+YLNetWorkFrame.h"
#import <objc/runtime.h>

@implementation YLNetObject
{
    NSMutableDictionary<NSString*, YLUrlSession*>*        urlSessions;
}

- (void)dealloc
{
    [self clearNetSession];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        urlSessions = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addUrlSession:(YLUrlSession*)urlsession
{
    if (urlsession)
    {
        NSInteger adr = (NSInteger)urlsession;
        NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
        [urlSessions setObject:urlsession forKey:key];
    }
}

- (void)removeUrlSession:(YLUrlSession*)urlsession
{
    if (urlsession)
    {
        NSInteger adr = (NSInteger)urlsession;
        NSString* key = [NSString stringWithFormat:@"%ld", (long)adr];
        [urlSessions removeObjectForKey:key];
    }
}

- (void)clearNetSession
{
    NSArray* sessions = [urlSessions allValues];
    for (YLUrlSession* session in sessions)
    {
        [session cancel];
    }
    
    [urlSessions removeAllObjects];
}

@end



@implementation NSObject (YLNetWorkFrame)

/*V1.1
- (void)setUrlSessions
{
    NSMutableDictionary* dic = objc_getAssociatedObject(self, @"ylnetworksession");
    if (!dic)
    {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @"ylnetworksession", dic, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)insertUrlSession:(id)session Key:(NSString*)key
{
    NSMutableDictionary* dic = objc_getAssociatedObject(self, @"ylnetworksession");
    if (dic && session && key)
    {
        [dic setObject:session forKey:key];
    }
    else
    {
        NSLog(@"YLNetWorkFrame: insert serssion failed for dic is null");
    }
}

- (void)removeUrlSession:(id)session
{
    NSMutableDictionary* dic = objc_getAssociatedObject(self, @"ylnetworksession");
    if (dic && session)
    {
        [dic removeObjectForKey:[NSString stringWithFormat:@"%0x", session]];
    }
}

- (void)clearYLNetWork
{
    NSMutableDictionary* dic = objc_getAssociatedObject(self, @"ylnetworksession");
    if (dic)
    {
        for (YLUrlSession* session in [dic allValues])
        {
            [session cancel];
        }
        
        objc_setAssociatedObject(self, @"ylnetworksession", nil, OBJC_ASSOCIATION_RETAIN);
    }
}
*/

/*V1.1*/
- (YLNetObject*)getNetObject
{
    YLNetObject* obj = objc_getAssociatedObject(self, "netobj");
    if (!obj)
    {
        obj = [[YLNetObject alloc] init];
        objc_setAssociatedObject(self, "netobj", obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return obj;
}

@end
