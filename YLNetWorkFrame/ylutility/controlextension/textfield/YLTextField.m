//
//  UITextField+UITextField_UIButton.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/29.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLTextField.h"

@interface YLTextField ()

@end

@implementation YLTextField
{
    UIView*                             loadView;
    UIActivityIndicatorView*            indicator;
    UIButton*                           button;
}

@synthesize delegate;
@synthesize maxLength;
@synthesize inpunStyle;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = YES;
        
        [self setupSubView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSubView];
}

- (void)setupSubView
{
    maxLength = 0;
    
    loadView = [[UIView alloc] initWithFrame:CGRectZero];
    loadView.backgroundColor = [UIColor clearColor];
    loadView.hidden = YES;
    [self addSubview:loadView];
    
    UIView* view = [[UIView alloc] initWithFrame:loadView.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.tag = 3;
    [loadView addSubview:view];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadView addSubview:indicator];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.5;
    [self addSubview:button];
    
    NSArray* contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[BTN]-0-|" options:0 metrics:nil views:@{@"BTN" : button}];
    [self addConstraints:contraints];
    
    contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[BTN]-0-|" options:0 metrics:nil views:@{@"BTN" : button}];
    [self addConstraints:contraints];
    
    [button addTarget:self action:@selector(OnButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setInpunStyle:(InputStyle)inpunstyle
{
    inpunStyle = inpunstyle;
    
    if (Input_KeyBoard == inpunStyle)
    {
        button.enabled = NO;
    }
    else if (Input_External == inpunStyle)
    {
        button.enabled = YES;
    }
    else ;
}

- (void)setMaxLength:(NSInteger)maxlength
{
    maxLength = maxlength;
}

- (void)setIsNull:(BOOL)isNull
{
    _isNull = isNull;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
    label.font = self.font;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (!isNull)
    {
        if ([_title length] > 0)
        {
            label.text = [NSString stringWithFormat:@" *%@", _title];
            NSMutableAttributedString* attstr = [[NSMutableAttributedString alloc] initWithString:label.text];
            label.attributedText = attstr;
            
            [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
        }
        else
        {
            label.text = @" *";
            label.textColor = [UIColor redColor];
            self.leftView = label;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    else
    {
        if ([_title length] > 0)
        {
            label.text = [NSString stringWithFormat:@" %@", _title];
        }
        else
        {
            self.leftView = nil;
            return;
        }
    }
    
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, label.frame.size.height)];
    label.frame = CGRectMake(0, 0, size.width + 5, label.frame.size.height);
    
    self.leftView = label;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (0 == [title length]) title = @"";
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
    label.font = self.font;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (!_isNull)
    {
        label.text = [NSString stringWithFormat:@" * %@", title];
        NSMutableAttributedString* attstr = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
        label.attributedText = attstr;
    }
    else
    {
        label.text = [NSString stringWithFormat:@" %@", title];
    }
    
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, label.frame.size.height)];
    label.frame = CGRectMake(0, 0, size.width + 5, label.frame.size.height);
    
    self.leftView = label;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)OnButtonDown:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(YLTextFieldClicked:)] && self.enabled && self.userInteractionEnabled)
    {
        [delegate YLTextFieldClicked:self];
    }
}

- (void)textFiledEditChanged:(NSNotification*)notification
{
    if (maxLength > 0)
    {
        UITextField* textField = (UITextField*)notification.object;
        
        NSString *toBeString = textField.text;
        // 键盘输入模式
        NSString *lang = [[UIApplication sharedApplication].textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"])
        {
            // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position)
            {
                if (toBeString.length > maxLength)
                {
                    textField.text = [toBeString substringToIndex:maxLength];
                    
                    if ([delegate respondsToSelector:@selector(YLTextFieldMaxLength:)])
                    {
                        [delegate YLTextFieldMaxLength:self];
                    }
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else
            {
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else
        {
            if (toBeString.length > maxLength)
            {
                textField.text = [toBeString substringToIndex:maxLength];
                
                if ([delegate respondsToSelector:@selector(YLTextFieldMaxLength:)])
                {
                    [delegate YLTextFieldMaxLength:self];
                }
            }
        }
    }
}

- (void)showLoader:(UIColor*)backcolor
{
    /*
    NSString* str = self.text;
    
    if (0 == [str length]) str = self.placeholder;
    
    if ([str length] > 0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: self.font};
        
        CGSize retSize = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                                        options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                                     attributes:attribute
                                                        context:nil].size;
        
        
    }
    */
    
    loadView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    indicator.center = CGPointMake(loadView.frame.size.width / 2, loadView.frame.size.height / 2);
    [indicator startAnimating];
    
    UIView* view = [loadView viewWithTag:3];
    view.backgroundColor = backcolor;
    
    loadView.hidden = NO;
}

- (void)hiddeLoader
{
    loadView.hidden = YES;
    [indicator stopAnimating];
}

@end
