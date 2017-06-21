//
//  YLPlaceholderTextView.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/7/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLPlaceholderTextView.h"

@implementation YLPlaceholderTextView
{
    UILabel*    placeHolderLb;
    NSInteger   characterCnt;
    UILabel*    characterCntLb;
}

@synthesize placeholder;

- (void)dealloc
{
    UIView* view = [characterCntLb superview];
    if (view) [characterCntLb removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        characterCnt = 0;
        
        placeHolderLb = [[UILabel alloc] initWithFrame:self.bounds];
        placeHolderLb.numberOfLines = 0;
        placeHolderLb.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLb.font = self.font;
        placeHolderLb.textColor = [UIColor lightGrayColor];
        [self addSubview:placeHolderLb];
        
        characterCntLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
        characterCntLb.numberOfLines = 0;
        characterCntLb.lineBreakMode = NSLineBreakByWordWrapping;
        characterCntLb.font = self.font;
        characterCntLb.textAlignment = NSTextAlignmentRight;
        characterCntLb.backgroundColor = self.backgroundColor;
        characterCntLb.textColor = [UIColor lightGrayColor];
        characterCntLb.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    placeHolderLb.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self didTextChanged];
}

- (void)setPlaceholder:(NSString *)text
{
    placeholder = text;
    placeHolderLb.text = text;
    
    NSDictionary *attribute = @{NSFontAttributeName: placeHolderLb.font};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    placeHolderLb.frame = CGRectMake(8, 8, retSize.width, retSize.height);
}

- (void)setCharacterCntFont:(UIFont*)font TextColor:(UIColor*)textcolor
{
    characterCntLb.font = font;
    characterCntLb.textColor = textcolor;
}

- (void)showCharacterCount:(NSInteger)total
{
    UIView* view = [self superview];
    CGRect frame = self.frame;
    characterCnt = total;
    
    if (total > 0)
    {
        if (characterCntLb.hidden)
        {
            characterCntLb.backgroundColor = self.backgroundColor;
            characterCntLb.frame = CGRectMake(frame.origin.x, CGRectGetMaxY(frame) - 20, self.frame.size.width, characterCntLb.frame.size.height);
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - characterCntLb.frame.size.height);
            characterCntLb.hidden = NO;
            [view addSubview:characterCntLb];
        }
    }
    else
    {
        if (!characterCntLb.hidden)
        {
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + characterCntLb.frame.size.height);
            characterCntLb.hidden = YES;
            [characterCntLb removeFromSuperview];
        }
    }
    
    characterCntLb.text = [NSString stringWithFormat:@"%ld/%ld", [self.text length], characterCnt];
}

- (void)didTextChanged
{
    if ([self.text length] > 0) placeHolderLb.hidden = YES;
    else placeHolderLb.hidden = NO;
    
    [self showCharacterCount:characterCnt];
}

@end
