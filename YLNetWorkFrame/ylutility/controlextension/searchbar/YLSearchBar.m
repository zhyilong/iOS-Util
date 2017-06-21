//
//  YLSearchBar.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/21.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLSearchBar.h"

@implementation YLSearchBar

@synthesize backView;
@synthesize textField;
@synthesize icon;

@synthesize iconContraint;

@synthesize delegate;

+ (YLSearchBar*)createYLSearchBar:(UIImage*)image
{
    YLSearchBar* bar = [[[NSBundle mainBundle] loadNibNamed:@"YLSearchBar" owner:nil options:nil] lastObject];
    
    bar.icon.image = image;
    
    return bar;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    backView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1].CGColor;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!icon.image)
    {
        iconContraint.constant = -self.frame.size.width / 2 + icon.frame.size.width + 2;
    }
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (icon.image)
    {
        if ([textField.text length] > 0)
            iconContraint.constant = -self.frame.size.width / 2 + icon.frame.size.width + 2;
        else
            iconContraint.constant = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self layoutIfNeeded];
            
        }];
    }
    else
    {
        iconContraint.constant = -self.frame.size.width / 2 + icon.frame.size.width + 2;
    }
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (icon.image && 0 == [textField.text length])
    {
        iconContraint.constant = -self.frame.size.width / 2 + icon.frame.size.width + 2;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self layoutIfNeeded];
            
        }];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (icon.image && 0 == [textField.text length])
    {
        iconContraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self layoutIfNeeded];
            
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(ylsearchBarSelected:Text:)])
    {
        [delegate ylsearchBarSelected:self Text:textField.text];
    }
    
    return [textField resignFirstResponder];
}

- (NSString*)text
{
    return textField.text;
}

- (void)setText:(NSString*)text
{
    if (icon.image && 0 == [textField.text length])
    {
        iconContraint.constant = -self.frame.size.width / 2 + icon.frame.size.width + 2;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self layoutIfNeeded];
            
        }];
    }
    
    textField.text = text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setText:textField.text];
    
    [textField becomeFirstResponder];
}

@end
