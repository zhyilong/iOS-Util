//
//  Loading.h
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/15.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLLoading;

typedef NS_ENUM(NSInteger, YLLoadingStyle)
{
    YLLoading_Accessory_Top,
    YLLoading_Accessory_Left,
};

typedef void(^YLLoadingTimeout)(YLLoading* loading);

@interface YLLoading : UIView

@property(nonatomic, strong) UIView*                  shadow;
@property(nonatomic, strong) UIActivityIndicatorView* indicator;
@property(nonatomic, strong) UILabel*                 uiTitle;
@property(nonatomic, strong) UIImageView*             icon;
@property(nonatomic, strong) UIView*                  mask;
@property(nonatomic, assign) YLLoadingStyle           style;

+ (YLLoading*)CreateFullScreenLoading:(NSString*)title Image:(UIImage*)image AtonceShow:(BOOL)atonceshow;
+ (YLLoading*)CreateLoadingInView:(UIView*)inview Title:(NSString*)title Image:(UIImage*)image AtonceShow:(BOOL)atonceshow;
+ (void)HiddeFullScreenLoading;

- (void)show;
- (void)hidde;
- (void)remove;

- (void)hiddeSubViews;
- (void)showSubViews;

- (void)setTimeOut:(NSInteger)seconds Callback:(YLLoadingTimeout)callback;

@end

@interface UIView (YLLoading)

- (void)setLoading:(YLLoading*)loading;
- (YLLoading*)getLoading;
- (void)removeLoading;

@end
