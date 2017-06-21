//
//  NumberUtility.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/19.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberUtility : NSObject

/**
 *  @author zhyilong, 16-04-19 14:04:25
 *
 *  校验字符串是否是正浮点数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsPlusFloat:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:25
 *
 *  校验字符串是否是负浮点数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsMinusFloat:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:58
 *
 *  校验字符串是否正整数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsPlusInt:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:58
 *
 *  校验字符串是否负整数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsMinusInt:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:05
 *
 *  校验字符串是否是正数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsPlusNumber:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:05
 *
 *  校验字符串是否是负数
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsMinusNumber:(NSString*)numstr;

/**
 *  @author zhyilong, 16-04-19 14:04:52
 *
 *  校验字符串是否数字
 *
 *  @param numstr 待校验字符串
 *
 *  @return YES - 是，NO - 不是
 */
+ (BOOL)verifyStringIsNumber:(NSString*)numstr;

@end
