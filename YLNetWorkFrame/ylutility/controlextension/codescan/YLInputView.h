//
//  YLInputView.h
//  YLAppUtility
//
//  Created by yilong zhang on 2016/12/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLInputView;

typedef NS_ENUM(NSInteger, YLInputStyle)
{
    YLInput_Style_Text,
    YLInput_Style_Number,
    YLInput_Style_TablePicker,
    YLInput_Style_ImagePicker,
};

@protocol YLInputViewDelegate <UITextFieldDelegate>

@optional
- (void)ylInputViewMaxLength:(YLInputView*)inputview;
- (void)ylInputView:(YLInputView*)inputview didcontenSizeChanged:(CGSize)contentsize;

@end




@interface YLInputView : UITextField <UITextViewDelegate>

@property(nonatomic, weak) UIView*                      coverView;

@property(nonatomic, weak)   id<YLInputViewDelegate>    delegate;
@property(nonatomic, assign) NSInteger                  maxLength;
@property(nonatomic, assign) YLInputStyle               inputStyle;
@property(nonatomic, assign) BOOL                       isMultiLine;
@property(nonatomic, assign) BOOL                       isScroll;

- (CGSize)contentSize;

@end
