//
//  NSString+Utility.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utility)

/**
 *  @author zhangyilong, 16-04-07 15:04:34
 *
 *  计算字符串在指定的高度和字体显示所需要的宽度
 *
 *  @param fixedheight 指定高度
 *  @param font        指点字体
 *
 *  @return 返回显示大小
 */
- (CGSize)showSizeInFixedHeight:(CGFloat)fixedheight Font:(UIFont*)font;

/**
 *  @author zhyilong, 16-08-15 10:08:31
 *
 *  计算UITextView在指定宽度下的高度
 *
 *  @param textview
 *
 *  @return
 */
- (CGSize)showSizeInFixedHeightInView:(CGFloat)fixedheight View:(UIView*)inview;

/**
 *  @author zhangyilong, 16-04-07 15:04:53
 *
 *  计算字符串在指定的宽度和字体下显示所需要的高度
 *
 *  @param fixedwidth 指定宽度
 *  @param font       指定字体
 *
 *  @return 返回显示大小
 */
- (CGSize)showSizeInFixedWidth:(CGFloat)fixedwidth Font:(UIFont*)font;

/**
 *  @author zhyilong, 16-08-15 10:08:54
 *
 *  计算UITextView在指定高度下的宽度
 *
 *  @param textview
 *
 *  @return 
 */
- (CGSize)showSizeInFixedWidthInView:(CGFloat)fixedwidth View:(UIView*)inview;

/**
 *  @author zhyilong, 16-04-21 15:04:46
 *
 *  MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)md5;

/**
 *  @author zhyilong, 16-06-06 08:06:44
 *
 *  是否中文
 *
 *  @return YES - 是
 */
- (BOOL)isChinese;

/**
 *  @author zhyilong, 16-06-14 10:06:55
 *
 *  将gbk中文转码到utf8
 *
 *  @return 转码后的新字符串
 */
- (NSString*)GBKToUTF8;

/**
 *  @author zhyilong, 16-06-29 09:06:26
 *
 *  判断手机号码正确性
 *
 *  @param mobileNum 输入手机号
 *
 *  @return YES - 正确
 */
- (BOOL)isMobileNumber;

/**
 *  @author zhyilong, 16-07-28 09:07:13
 *
 *  汉字转拼音
 *
 *  @param lowercase 是否小写字母得到结果，默认大写
 *
 *  @return 结果
 */
- (NSString*)HanCharacter2Pinyin:(BOOL)lowercase;

- (NSString*)encodeToPercentEscapeString;

/**
 *  @author zhyilong, 16-08-18 10:08:04
 *
 *  判读浮点数
 *
 *  @param plusminus 符号 + - 正数，- - 负数，nil - 忽略符号
 *
 *  @param decimalcount 小数点后几位, 0或负数 - 无效
 *
 *  @return
 */
- (BOOL)isFloatNumber:(NSString*)plusminus DecimalCount:(NSInteger)decimalcount;

/**
 *  @author zhyilong, 16-08-18 11:08:35
 *
 *  判断整数
 *
 *  @param plusminus 符号 + - 正数，- - 负数，nil - 忽略符号
 *
 *  @return
 */
- (BOOL)isIntegerNumber:(NSString*)plusminus;

@end
