//
//  DateUtility.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

//year - yyyy, month - MM, day - dd, hour - HH, minute - mm, second - ss, millisecond - SSS

@interface DateUtility : NSObject

/**
 *  @author zhangyilong, 16-04-07 15:04:11
 *
 *  将时间戳按照时间格式和时区转换成时间字符串
 *
 *  @param timestamp    时间戳
 *  @param formatstring 需要转换的时间格式
 *  @param timezone     时区
 *
 *  @return 转换后的时间字符串
 */
+ (NSString*)timestampToDateString:(UInt64)timestamp FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone;

/**
 *  @author zhangyilong, 16-04-07 15:04:38
 *
 *  将时间按照指定的格式和时区转成时间字符串
 *
 *  @param date         时期
 *  @param formatstring 需要转成的时间格式
 *  @param timezone     时区
 *
 *  @return 转换后的时间字符串
 */
+ (NSString*)dateToDateString:(NSDate*)date FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone;

/**
 *  @author zhangyilong, 16-04-07 15:04:43
 *
 *  将时间字符换按照格式和时区转换成时期
 *
 *  @param datestring   时间字符串
 *  @param formatstring 时间格式
 *  @param timezone     时区
 *
 *  @return 转换后的日期
 */
+ (NSDate*)dateStringToDate:(NSString*)datestring FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone;

/**
 *  @author zhangyilong, 16-04-07 15:04:58
 *
 *  将时间字符串转换成时间戳
 *
 *  @param datestring   时间字符串
 *  @param formatstring 时间格式
 *  @param timezone     时区
 *
 *  @return 时间戳
 */
+ (UInt64)dateStringToTimestamp:(NSString*)datestring FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone;

/**
 *  @author zhangyilong, 16-04-07 15:04:14
 *
 *  获得时间戳距离系统当前时间的长度（时，天）
 *
 *  @param timestamp 时间戳
 *
 *  @return 距离长度
 */
+ (NSString*)distanceTodayTimeString:(UInt64)timestamp;

/**
 *  @author zhyilong, 16-04-22 13:04:27
 *
 *  将时间戳按照指定格式到日期
 *
 *  @param timestamp    时间戳
 *  @param formatstring 格式
 *  @param timezone     时区
 *
 *  @return 格式后的日期
 */
+ (NSDate*)dateTimestampToDate:(UInt64)timestamp FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone;

/**
 *  @author zhyilong, 16-04-22 14:04:52
 *
 *  格林尼治时间到中国东8区
 *
 *  @return 中国时区
 */
+ (NSTimeZone*)dateChinaTimeZone;

/**
 *  @author zhyilong, 16-04-25 09:04:33
 *
 *  返回utc市区
 *
 *  @return utc时区
 */
+ (NSTimeZone*)dateUTCTimeZone;

@end
