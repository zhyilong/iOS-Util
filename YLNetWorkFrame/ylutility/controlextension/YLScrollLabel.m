//
//  ScrollLabel.m
//  ScrollLabel
//
//  Created by zhangyilong on 15/9/2.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "YLScrollLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation YLScrollLabel
{
    CGFloat margin;
}

@synthesize font;
@synthesize text;
@synthesize textColor;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    //
}

- (instancetype)initWithFrame:(CGRect)frame Font:(UIFont*)Font
{
    if ([super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];

        isAnimate = YES;
        isAnimating = NO;
        isStop = NO;
        self.font = Font;
        margin = 0;
        
        [self setUp];
        
        return self;
    }
    
    return nil;
}

- (void)setUp
{
    [scroll removeFromSuperview];
    scroll = nil;
    
    scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    scroll.scrollEnabled = NO;
    [self addSubview:scroll];

    firstLabel = [[UILabel alloc] initWithFrame:self.bounds];
    firstLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    firstLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    firstLabel.font = font;
    firstLabel.textColor = textColor;
    [scroll addSubview:firstLabel];
    
    secondLabel = [[UILabel alloc] initWithFrame:self.bounds];
    secondLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    secondLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    secondLabel.font = font;
    secondLabel.textColor = textColor;
    [scroll addSubview:secondLabel];
    
    scroll.contentOffset = CGPointZero;
}

- (void)setTitle:(NSString *)title Animate:(BOOL)animate
{
    text = title;
    isAnimate = animate;
    isAnimating = NO;
    isStop = YES;
    
    [self setUp];
    
    [self animate:text Animate:isAnimate];
}

- (void)animate:(NSString *)title Animate:(BOOL)animate
{
    isAnimate = animate;
    
    NSDictionary *attribute = @{NSFontAttributeName: firstLabel.font};
    CGSize size = CGSizeMake(0, firstLabel.frame.size.height);
    CGSize retSize = [title boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    firstLabel.text  = title;
    secondLabel.text = title;
    
    if (retSize.width > self.frame.size.width)
    {
        margin = 20;
        firstLabel.frame = CGRectMake(0, firstLabel.frame.origin.y, retSize.width, retSize.height);
        secondLabel.frame= CGRectMake(retSize.width + margin, secondLabel.frame.origin.y, retSize.width, retSize.height);
        scroll.contentSize = CGSizeMake(retSize.width * 2 + margin, self.frame.size.height);
        scroll.contentOffset = CGPointZero;
        
        firstLabel.center = CGPointMake(firstLabel.center.x, self.frame.size.height / 2);
        secondLabel.center = CGPointMake(secondLabel.center.x, self.frame.size.height / 2);
    }
    else
    {
        isAnimate = NO;
        
        firstLabel.frame = CGRectMake(0, firstLabel.frame.origin.y, self.frame.size.width, firstLabel.frame.size.height);
        secondLabel.text = nil;
        scroll.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        firstLabel.center = CGPointMake(firstLabel.center.x, self.frame.size.height / 2);
        secondLabel.center = CGPointMake(secondLabel.center.x, self.frame.size.height / 2);
    }
    
    [self textScroll:isAnimate];
}

- (void)setTextColor:(UIColor*)color
{
    textColor = color;
    
    firstLabel.textColor = color;
    secondLabel.textColor = color;
}

- (void)textScroll:(BOOL)animate
{
    if (animate && !isAnimating)
    {
        isAnimating = YES;
        isStop = NO;
        
        CGFloat duration = scroll.contentSize.width / 30;

        [UIView beginAnimations:[NSString stringWithFormat:@"%0x", scroll] context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelay:1];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(scrollEnd:)];
        [UIView setAnimationRepeatCount:HUGE_VAL];
        scroll.contentOffset = CGPointMake(secondLabel.frame.origin.x, scroll.contentOffset.y);
        [UIView commitAnimations];
    }
}

//- (void)scrollEnd:(NSString*)animateid
//{
//    NSString* tmp = [NSString stringWithFormat:@"%0x", scroll];
//
//    if ([tmp isEqualToString:animateid])
//    {
//        CGSize retSize = firstLabel.frame.size;
//        
//        firstLabel.frame = CGRectMake(0, firstLabel.frame.origin.y, retSize.width, retSize.height);
//        secondLabel.frame= CGRectMake(retSize.width + margin, secondLabel.frame.origin.y, retSize.width, retSize.height);
//        
//        scroll.contentOffset = CGPointMake(0, scroll.contentOffset.y);
//        
//        isAnimating = NO;
//        [self textScroll:isAnimate];
//    }
//}

- (void)setTextAlignmentStyle:(NSTextAlignment)style
{
    firstLabel.textAlignment = style;
    secondLabel.textAlignment = style;
}

@end
