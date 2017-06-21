//
//  DateUtility.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSString*)timestampToDateString:(UInt64)timestamp FormatString:(NSString *)formatstring TimeZone:(NSTimeZone*)timezone
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatstring];
    if (timezone) [dateFormatter setTimeZone:timezone];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)dateToDateString:(NSDate*)date FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatstring];
    
    if (timezone) [dateFormatter setTimeZone:timezone];
    
    NSString* str = [dateFormatter stringFromDate:date];
    
    return str;
}

+ (NSDate*)dateStringToDate:(NSString*)datestring FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatstring];
    if (timezone) [dateFormatter setTimeZone:timezone];
    
    NSDate* date = [dateFormatter dateFromString:datestring];
    
    if (!timezone)
    {
        NSInteger sec = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
        date = [date dateByAddingTimeInterval:sec];
    }
    
    return date;
}

+ (UInt64)dateStringToTimestamp:(NSString*)datestring FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone
{
    NSDate* date = [DateUtility dateStringToDate:datestring FormatString:formatstring TimeZone:timezone];
    
    return [date timeIntervalSince1970];
}

+ (NSString*)distanceTodayTimeString:(UInt64)timestamp
{
    NSString* str = nil;
    UInt64 seconds = [NSDate date].timeIntervalSince1970;
    
    //分钟
    seconds /= 60;
    if (seconds <= 1) str = @"刚刚";
    else if (seconds < 60) str = [NSString stringWithFormat:@"%llu分钟前", seconds];
    else ;
    
    //小时
    seconds /= 60;
    if (seconds < 24) str = [NSString stringWithFormat:@"%llu小时前", seconds];
    
    //天
    seconds /= 24;
    if (seconds <= 7) str = [NSString stringWithFormat:@"%llu天前", seconds];
    else str = [DateUtility timestampToDateString:timestamp FormatString:@"yyyy年MM月dd日 HH小时mm分钟" TimeZone:nil];
    
    return str;
}

+ (NSDate*)dateTimestampToDate:(UInt64)timestamp FormatString:(NSString*)formatstring TimeZone:(NSTimeZone*)timezone
{
    NSString* datestr = [DateUtility timestampToDateString:timestamp FormatString:formatstring TimeZone:timezone];
    
    return [DateUtility dateStringToDate:datestr FormatString:formatstring TimeZone:timezone];
}

+ (NSTimeZone*)dateChinaTimeZone
{
    return [NSTimeZone timeZoneForSecondsFromGMT:8];
}

+ (NSTimeZone*)dateUTCTimeZone
{
    return [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
}

@end
