//
//  UITextField+UITextField_UIButton.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/29.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLTextField;

typedef NS_ENUM(NSInteger, InputStyle)
{
    Input_KeyBoard,
    Input_External,
};

@protocol YLTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)YLTextFieldClicked:(YLTextField*)textField;
- (void)YLTextFieldMaxLength:(YLTextField*)textField;

@end


@interface YLTextField : UITextField

@property(nonatomic, weak) id<YLTextFieldDelegate>    delegate;
@property(nonatomic, assign) NSInteger                maxLength;
@property(nonatomic, assign) InputStyle               inpunStyle;
@property(nonatomic, assign) BOOL                     isNull;
@property(nonatomic, strong) NSString*                title;

- (void)showLoader:(UIColor*)backcolor;
- (void)hiddeLoader;

@end
