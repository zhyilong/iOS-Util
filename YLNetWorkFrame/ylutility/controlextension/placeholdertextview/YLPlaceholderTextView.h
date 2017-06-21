//
//  YLPlaceholderTextView.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLPlaceholderTextView : UITextView

@property(nonatomic, strong)  NSString*     placeholder;

///是否显示字数统计，<=0不显示，>0显示；注意：该方法调用必须是textview已经有父view
- (void)showCharacterCount:(NSInteger)total;
- (void)setCharacterCntFont:(UIFont*)font TextColor:(UIColor*)textcolor;

@end
