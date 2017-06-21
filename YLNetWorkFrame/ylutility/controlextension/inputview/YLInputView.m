//
//  YLInputView.m
//  YLAppUtility
//
//  Created by yilong zhang on 2016/12/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLInputView.h"

@implementation YLInputView
{
    UITextView*     textView;
    
    CGSize          contentSize;
}

@synthesize coverView;

@synthesize delegate;
@synthesize maxLength;
@synthesize inputStyle;
@synthesize isMultiLine;
@synthesize isScroll;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.borderStyle = UITextBorderStyleNone;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.clipsToBounds = YES;
        
        maxLength   = 0;
        contentSize = frame.size;
        inputStyle  = YLInput_Style_Text;
        isScroll = NO;
        delegate = nil;
        
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
        textView.backgroundColor = self.backgroundColor;
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        textView.font = self.font;
        textView.textColor = self.textColor;
        textView.contentInset = UIEdgeInsetsMake(-7, 0, 0, 0);
        textView.hidden = YES;
        textView.delegate = self;
        [self addSubview:textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self resetLayout];
}

- (void)setMaxLength:(NSInteger)maxlength
{
    maxLength = maxlength;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    textView.backgroundColor = backgroundColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    textView.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    textView.text = text;
}

- (NSString*)text
{
    NSString* str = [super text];
    
    if (!textView.hidden) str = textView.text;
    
    return str;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    textView.textColor = textColor;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [super setReturnKeyType:returnKeyType];
    
    textView.returnKeyType = returnKeyType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    [super setKeyboardType:keyboardType];
    
    textView.keyboardType = keyboardType;
}

- (void)setDelegate:(id<YLInputViewDelegate>)Delegate
{
    [super setDelegate:Delegate];
    
    delegate = Delegate;
}

- (id<YLInputViewDelegate>)delegate
{
    return delegate;
}

- (CGSize)contentSize
{
    if (isMultiLine)
    {
        self.text = textView.text;
    
        contentSize = [self showSizeInFixedWidth:textView.frame.size.width Font:self.font];
    }
    else
    {
        contentSize = self.frame.size;
    }
    
    return contentSize;
}

- (BOOL)becomeFirstResponder
{
    BOOL bret = YES;
    
    if (isMultiLine) bret = [textView becomeFirstResponder];
    else bret = [super becomeFirstResponder];
    
    return bret;
}

- (BOOL)resignFirstResponder
{
    BOOL bret = YES;
    
    bret = [super resignFirstResponder];

    if ([textView isFirstResponder]) bret = [textView resignFirstResponder];
    
    return bret;
}

- (void)setIsMultiLine:(BOOL)ismultiline
{
    isMultiLine = ismultiline;
    
    [self resetLayout];
    
    if (self.userInteractionEnabled)
    {
        if (ismultiline) [textView becomeFirstResponder];
        else [self becomeFirstResponder];
    }
}

- (void)setIsScroll:(BOOL)isscroll
{
    [textView setScrollEnabled:isscroll];
    textView.showsVerticalScrollIndicator = isscroll;
    textView.showsHorizontalScrollIndicator = isscroll;
}

- (void)setLeftView:(UIView *)leftView
{
    [super setLeftView:leftView];
    
    [self resetLayout];
}

- (void)setRightView:(UIView *)rightView
{
    [super setRightView:rightView];
    
    [self resetLayout];
}

- (void)resetLayout
{
    CGRect leftframe = self.leftView.frame;
    CGRect rightframe = self.rightView.frame;
    
    if (isMultiLine)
    {
        CGSize size = CGSizeMake(self.bounds.size.width - leftframe.size.width - rightframe.size.width, self.bounds.size.height);
        
        size.height = [self showSizeInFixedWidth:size.width Font:self.font].height;
        if (size.height < 30) size.height = 30;
        
        textView.frame = CGRectMake(CGRectGetMaxX(leftframe), textView.frame.origin.y, size.width, size.height);
        
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);

        leftframe.size.height = size.height;
        self.leftView.frame = leftframe;
        
        rightframe.size.height = size.height;
        self.rightView.frame = rightframe;

        //记录原始文字颜色
        UIColor* oldcolor = textView.textColor;
        
        self.textColor = [UIColor clearColor];
        textView.textColor = oldcolor;
        textView.hidden = NO;
        
        if ([self isFirstResponder]) [textView becomeFirstResponder];
        
        if ([delegate respondsToSelector:@selector(ylInputView:didcontenSizeChanged:)])
        {
            [delegate ylInputView:self didcontenSizeChanged:self.frame.size];
        }
    }
    else
    {
        self.text = textView.text;
        textView.hidden = YES;
        
        //设置文字颜色
        self.textColor = textView.textColor;
        
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30);
        
        leftframe.size.height = frame.size.height;
        self.leftView.frame = leftframe;
        
        rightframe.size.height = frame.size.height;
        self.rightView.frame = rightframe;
        
        if ([textView isFirstResponder]) [self becomeFirstResponder];
        
        if ([delegate respondsToSelector:@selector(ylInputView:didcontenSizeChanged:)])
        {
            [delegate ylInputView:self didcontenSizeChanged:self.frame.size];
        }
    }
}

- (CGSize)showSizeInFixedWidth:(CGFloat)fixedwidth Font:(UIFont *)font
{
    /*
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [self.text boundingRectWithSize:CGSizeMake(fixedwidth, MAXFLOAT)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    retSize.height += 1;
    
    return retSize;
    */
    
    CGSize retSize = [textView sizeThatFits:CGSizeMake(fixedwidth, CGFLOAT_MAX)];
    retSize.height -= 14;
    
    return retSize;
}

//notification
- (void)textFiledEditChanged:(NSNotification*)notification
{
    if (maxLength > 0)
    {
        UITextField* textField = (UITextField*)notification.object;
        
        NSString *toBeString = textField.text;
        
        [self isComeMaxlength:toBeString];
        
    }
}

- (void)textViewEditChanged:(NSNotification*)notification
{
    if (maxLength > 0)
    {
        UITextView* textview = (UITextView*)notification.object;
        
        NSString *toBeString = textview.text;
        
        [self isComeMaxlength:toBeString];
    }
    
    CGSize size = [self contentSize];
    if (textView.frame.size.height != size.height/* || textView.frame.size.height != size.width*/)
    {
        if ([delegate respondsToSelector:@selector(ylInputView:didcontenSizeChanged:)])
        {
            size.width = self.frame.size.width;
            [delegate ylInputView:self didcontenSizeChanged:size];
        }
    }
}

- (BOOL)isComeMaxlength:(NSString*)text
{
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication].textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = nil;
        if (isMultiLine) selectedRange = [textView markedTextRange];
        else selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = nil;
        if (isMultiLine) position = [textView positionFromPosition:selectedRange.start offset:0];
        else position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (text.length > maxLength)
            {
                self.text = [text substringToIndex:maxLength];
                
                if ([delegate respondsToSelector:@selector(ylInputViewMaxLength:)])
                {
                    [delegate ylInputViewMaxLength:self];
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
        if (text.length > maxLength)
        {
            self.text = [text substringToIndex:maxLength];
            
            if ([delegate respondsToSelector:@selector(ylInputViewMaxLength:)])
            {
                [delegate ylInputViewMaxLength:self];
            }
        }
    }
    
    return YES;
}

//delegate of uiscrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isScroll)
    {
        scrollView.contentOffset = CGPointMake(0, 7);
    }
}

//delegate of uitextview
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL bret = YES;
    
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        bret = [delegate textFieldShouldBeginEditing:self];
    }
    
    return bret;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL bret = YES;
    
    if ([text isEqualToString:@"\n"])
    {
        if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)])
        {
            bret = [delegate textFieldShouldReturn:self];
        }
    }
    else
    {
        if ([delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)])
        {
            bret = [delegate textField:self shouldChangeCharactersInRange:range replacementString:text];
        }
    }
        
    return bret;
}

@end
