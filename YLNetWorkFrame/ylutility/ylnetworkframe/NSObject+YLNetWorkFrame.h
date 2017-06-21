//
//  NSObject+YLNetWorkFrame.h
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+YLNetWorkFrame.h"

@class YLUrlSession;

//V1.1
@interface YLNetObject : NSObject

- (void)addUrlSession:(YLUrlSession*)urlsession;
- (void)removeUrlSession:(YLUrlSession*)urlsession;
- (void)clearNetSession;

@end




@interface NSObject (YLNetWorkFrame)

/*V1.O
- (void)setUrlSessions;
- (void)insertUrlSession:(id)session Key:(NSString*)key;
- (void)removeUrlSession:(id)session;
- (void)clearYLNetWork;
*/

/*V1.1*/
- (YLNetObject*)getNetObject;

@end
