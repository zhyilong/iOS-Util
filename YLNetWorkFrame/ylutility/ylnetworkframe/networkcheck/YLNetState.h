//
//  UNNetState.h
//  UNCheckNetState
//
//  Created by zhangyilong on 15/10/20.
//  Copyright © 2015年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

/**
 *  @author zhangyilong, 16-04-07 15:04:51
 *
 *  检测网络状态
 */
@interface YLNetState : NSObject

- (instancetype)initWithHostName:(NSString*)url;

@end
