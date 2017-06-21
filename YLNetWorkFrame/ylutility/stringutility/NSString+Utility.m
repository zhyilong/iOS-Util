//
//  NSString+Utility.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utility)

- (CGSize)showSizeInFixedHeight:(CGFloat)fixedheight Font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, fixedheight)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    
    retSize.width += 1;
    
    return retSize;
}

- (CGSize)showSizeInFixedHeightInView:(CGFloat)fixedheight View:(UIView*)inview
{
    CGSize retSize = [inview sizeThatFits:CGSizeMake(CGFLOAT_MAX, fixedheight)];
    
    return retSize;
}

- (CGSize)showSizeInFixedWidth:(CGFloat)fixedwidth Font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [self boundingRectWithSize:CGSizeMake(fixedwidth, MAXFLOAT)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    retSize.height += 1;
    
    return retSize;
}

- (CGSize)showSizeInFixedWidthInView:(CGFloat)fixedwidth View:(UIView*)inview
{
    CGSize retSize = [inview sizeThatFits:CGSizeMake(fixedwidth, CGFLOAT_MAX)];
    
    return retSize;
}

- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)[hash appendFormat:@"%02X", result[i]];
    
    return [hash uppercaseString];
}

- (BOOL)isChinese
{
    BOOL bret = NO;
    
    NSString* match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    bret = [predicate evaluateWithObject:self];
    
    return bret;
}

- (NSString*)GBKToUTF8
{
    CFStringRef sUrl = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, nil, nil, kCFStringEncodingUTF8);
    NSString* ret = [NSString stringWithString:(__bridge NSString*)sUrl];
    
    CFRelease(sUrl);
    
    return ret;
}

- (BOOL)isMobileNumber
{
    NSString* mobileNum = self;
    
    if (mobileNum.length != 11)
    {
        return NO;
    }
    
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum]
         || [regextestcm evaluateWithObject:mobileNum]
         || [regextestct evaluateWithObject:mobileNum]
         || [regextestcu evaluateWithObject:mobileNum]))
    {
        return YES;
    }
    
    return NO;
}

- (NSString*)HanCharacter2Pinyin:(BOOL)lowercase
{
    NSMutableString *ms = [[NSMutableString alloc]initWithString:self];
    NSString* result = nil;
    
    //带声仄 //不能注释掉
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)){}
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
    {
        if (lowercase) result = [ms lowercaseString];
        else result = [ms uppercaseString]; // bigStr 是转换成功后的拼音
    }
    
    return result;
}

- (NSString*)encodeToPercentEscapeString
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

- (BOOL)isFloatNumber:(NSString*)plusminus DecimalCount:(NSInteger)decimalcount
{
    NSString* regex = nil;
    NSString* mes = nil;
    NSPredicate* predicate = nil;
    BOOL bret = NO;
    
    if ([self length] > 0)
    {
        if ([plusminus isEqualToString:@"+"])
        {
            regex = @"^(([1-9]+[0-9]*|[0]?)[.]{1}[0-9]*)$";
        }
        else if ([plusminus isEqualToString:@"-"])
        {
            regex = @"^-{1}(([1-9]+[0-9]*|[0]?)[.]{1}[0-9]*)$";
        }
        else
        {
            regex = @"^-?(([1-9]+[0-9]*|[0]?)[.]{1}[0-9]*)$";
        }
        
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        bret = [predicate evaluateWithObject:self];
        
        //验证小数位
        if (bret && decimalcount > 0)
        {
            NSArray* sub = [self componentsSeparatedByString:@"."];
            NSString* last = [sub lastObject];
            if ([last length] > decimalcount)
            {
                mes = [NSString stringWithFormat:@"小数点后只能有%ld位", decimalcount];
                bret = NO;
            }
        }
        else if (!bret)
        {
            mes = @"格式错误";
        }
    }
    else
    {
        bret = YES;
    }
    
    return bret;
}

- (BOOL)isIntegerNumber:(NSString*)plusminus
{
    NSString* regex = nil;
    NSString* mes = nil;
    NSPredicate* predicate = nil;
    BOOL bret = NO;
    
    if ([self length] > 0)
    {
        if ([plusminus isEqualToString:@"+"])
        {
            regex = @"^([1-9]+[0-9]*|[0]?)$";
        }
        else if ([plusminus isEqualToString:@"-"])
        {
            regex = @"^-{1}([1-9]+[0-9]*|[0]?)$";
        }
        else
        {
            regex = @"^-?([1-9]+[0-9]*|[0]?)$";
        }
        
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        bret = [predicate evaluateWithObject:self];
        
        if (bret) mes = @"格式错误";
    }
    else
    {
        bret = YES;
    }
    
    return bret;
}

@end
