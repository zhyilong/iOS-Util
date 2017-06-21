//
//  NumberUtility.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/19.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "NumberUtility.h"

@implementation NumberUtility

///private
+ (BOOL)verifyStringIsZeroFloat:(NSString*)numstr
{
    NSString* regex = @"^0.0$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numstr];
}

+ (BOOL)verifyStringIsZeroInt:(NSString*)numstr
{
    NSString* regex = @"^0$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numstr];
}

///public
+ (BOOL)verifyStringIsPlusFloat:(NSString*)numstr
{
    BOOL bret = NO;
    
    NSString* regex = @"^[1-9]\\d*\\.\\d{1,}|0\\.\\d*[1-9]\\d*$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    bret = [pred evaluateWithObject:numstr];
    
    if (!bret) bret = [NumberUtility verifyStringIsZeroFloat:numstr];
    
    return bret;
}

+ (BOOL)verifyStringIsMinusFloat:(NSString*)numstr
{
    NSString* regex = @"^-[1-9]\\d*\\.\\d{1,}|-0\\.\\d*[1-9]\\d*$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numstr];
}

+ (BOOL)verifyStringIsPlusInt:(NSString*)numstr
{
    BOOL bret = NO;
    
    NSString* regex = @"^[1-9]\\d*$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    bret = [pred evaluateWithObject:numstr];
    
    if (!bret) bret = [NumberUtility verifyStringIsZeroInt:numstr];
    
    return bret;
}

+ (BOOL)verifyStringIsMinusInt:(NSString*)numstr
{
    NSString* regex = @"^-[1-9]\\d*$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numstr];
}

+ (BOOL)verifyStringIsPlusNumber:(NSString*)numstr
{
    BOOL bret = [NumberUtility verifyStringIsPlusInt:numstr];
    
    if (!bret) bret = [NumberUtility verifyStringIsPlusFloat:numstr];
    
    return bret;
}

+ (BOOL)verifyStringIsMinusNumber:(NSString*)numstr
{
    BOOL bret = [NumberUtility verifyStringIsMinusFloat:numstr];
    
    if (!bret) bret = [NumberUtility verifyStringIsMinusInt:numstr];
    
    return bret;
}

+ (BOOL)verifyStringIsNumber:(NSString*)numstr
{
    BOOL bret = [NumberUtility verifyStringIsPlusNumber:numstr];
    
    if (!bret) bret = [NumberUtility verifyStringIsMinusNumber:numstr];
    
    return bret;
}
@end
