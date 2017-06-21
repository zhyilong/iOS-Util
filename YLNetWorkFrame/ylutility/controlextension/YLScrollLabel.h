//
//  ScrollLabel.h
//  ScrollLabel
//
//  Created by zhangyilong on 15/9/2.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLScrollLabel : UIView
{
    BOOL            isAnimating;
    BOOL            isAnimate;
    BOOL            isStop;
    UIScrollView*   scroll;
    UILabel*        firstLabel;
    UILabel*        secondLabel;
}

@property(nonatomic, strong) UIFont*    font;
@property(nonatomic, strong) NSString*  text;
@property(nonatomic, strong) UIColor*   textColor;

- (instancetype)initWithFrame:(CGRect)frame Font:(UIFont*)font;
- (void)setTitle:(NSString*)title Animate:(BOOL)animate;
- (void)setTextColor:(UIColor*)color;
- (void)setTextAlignmentStyle:(NSTextAlignment)style;

@end
