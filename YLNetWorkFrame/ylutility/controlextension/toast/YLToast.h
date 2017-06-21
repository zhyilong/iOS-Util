//
//  UNToast.h
//  UNToast
//
//  Created by zhangyilong on 15/9/16.
//  Copyright © 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLToast;

typedef NS_ENUM(NSInteger, YLToastPositionStyle)
{
    YLToast_Position_Center,
    YLToast_Position_Top,
    YLToast_Position_Bottom,
};

typedef NS_ENUM(NSInteger, YLToastContentStyle)
{
    YLToast_Content_ImageText,
    YLToast_Content_ImageTop,
    YLToast_Content_TextTop,
};

typedef void(^YLToastCallBack)(YLToast* toast);

@interface YLToast : UIView
{
    UILabel*        title;
    UIImageView*    icon;
    NSInteger       showSeconds;
}

@property(nonatomic, assign) YLToastPositionStyle       positionStyle;
@property(nonatomic, assign) YLToastContentStyle        contentStyle;
@property(nonatomic, copy)   YLToastCallBack            callBack;

+ (YLToast*)createWithTitle:(NSString*)title Seconds:(NSInteger)seconds;
+ (YLToast*)createWithTitle:(NSString*)title Image:(UIImage*)image Seconds:(NSInteger)seconds;

- (void)showInView:(UIView*)view;
- (void)showInView:(UIView*)view AnimateStyle:(NSInteger)style;

@end
