//
//  UNToast.m
//  UNToast
//
//  Created by zhangyilong on 15/9/16.
//  Copyright © 2015年 zhangyilong. All rights reserved.
//

#import "YLToast.h"

@implementation YLToast

@synthesize positionStyle;
@synthesize contentStyle;
@synthesize callBack;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    self.callBack = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5;
        self.layer.shadowColor  = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity= 0.8;
        self.layer.shadowOffset = CGSizeMake(1, 2);
        
        title = [[UILabel alloc] initWithFrame:self.bounds];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:14];
        title.textAlignment = NSTextAlignmentCenter;
        title.numberOfLines = 0;
        [self addSubview:title];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:icon];
        
        self.callBack = nil;
        self.positionStyle = YLToast_Position_Center;
        self.contentStyle = YLToast_Content_ImageText;
        self.alpha = 0.0;
        
        return self;
    }
    
    return nil;
}

+ (YLToast*)createWithTitle:(NSString *)title Seconds:(NSInteger)seconds
{
    YLToast* toast = [[YLToast alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [toast setTitle:title Seconds:seconds];
    
    return toast;
}

+ (YLToast*)createWithTitle:(NSString *)title Image:(UIImage *)image Seconds:(NSInteger)seconds
{
    YLToast* toast = [[YLToast alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (image)
    {
        [toast setTitle:title Image:image Seconds:seconds];
    }
    else
    {
        [toast setTitle:title Seconds:seconds];
    }
    
    return toast;
}

- (void)setTitle:(NSString*)text Seconds:(NSInteger)seconds
{
    title.text = text;
    showSeconds = seconds;
}

- (void)setTitle:(NSString*)text Image:(UIImage*)image Seconds:(NSInteger)seconds
{
    title.text = text;
    icon.image = image;
    showSeconds = seconds;
}

- (void)layoutInit
{
    if (icon.image)
    {
        [self layoutImage];
    }
    else
    {
        [self layoutAnyText];
    }
    
    UIView* view = self.superview;
    
    switch (positionStyle)
    {
        case YLToast_Position_Top:
            self.center = CGPointMake(view.frame.size.width / 2, self.frame.size.height / 2 + 8);
            break;
        case YLToast_Position_Center:
            self.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
            break;
        case YLToast_Position_Bottom:
            self.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height - self.frame.size.height - 8);
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shown)];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)layoutAnyText
{
    UIView* view = self.superview;
    
    NSDictionary *attribute = @{NSFontAttributeName: title.font};
    
    CGSize retSize = [title.text boundingRectWithSize:CGSizeMake(view.frame.size.width - 20, view.frame.size.height - 20)
                                              options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    self.frame = CGRectMake(0, 0, retSize.width + 10, retSize.height + 10);
    
    title.frame = self.bounds;
    title.center= CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)layoutImage
{
    UIView* view = self.superview;
    
    CGSize imageSize = CGSizeZero;
    
    NSDictionary *attribute = @{NSFontAttributeName: title.font};
    
    CGSize retSize = [title.text boundingRectWithSize:CGSizeMake(view.frame.size.width - 20 - 10, view.frame.size.height - 20)
                                              options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    imageSize.width = retSize.height;
    imageSize.height= retSize.height;
    
    retSize = [title.text boundingRectWithSize:CGSizeMake(view.frame.size.width - 20 - 10 - imageSize.width - 5, view.frame.size.height - 20)
                                       options:\
               NSStringDrawingTruncatesLastVisibleLine |
               NSStringDrawingUsesLineFragmentOrigin |
               NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    CGRect selfFrame = CGRectZero;
    CGRect textFrame = CGRectZero;
    CGRect imageFrame= CGRectZero;
    CGPoint point = CGPointZero;
    
    switch (contentStyle)
    {
        case YLToast_Content_ImageText:
        {
            selfFrame = CGRectMake(0, 0, retSize.width + imageSize.width + 5 + 10, retSize.height + 10);
            point = CGPointMake((selfFrame.size.width - retSize.width - imageSize.width - 5) / 2, selfFrame.size.height / 2);
            
            imageFrame = CGRectMake(point.x, (selfFrame.size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
            point.x += imageFrame.size.width + 5;
            
            textFrame = CGRectMake(point.x, (selfFrame.size.height - retSize.height) / 2, retSize.width, retSize.height);
        }
            break;
        case YLToast_Content_ImageTop:
        {
            selfFrame = CGRectMake(0, 0, (imageSize.width > retSize.width) ? (imageSize.width + 10) : (retSize.width + 10), imageSize.height + retSize.height + 5 + 10);
            point = CGPointMake((selfFrame.size.width - imageSize.width) / 2, 5);
            
            imageFrame = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
            point.y += imageFrame.size.height + 5;
            
            textFrame = CGRectMake((selfFrame.size.width - retSize.width) / 2, point.y, retSize.width, retSize.height);
        }
            break;
        case YLToast_Content_TextTop:
        {
            selfFrame = CGRectMake(0, 0, (imageSize.width > retSize.width) ? (imageSize.width + 10) : (retSize.width + 10), imageSize.height + retSize.height + 5 + 10);
            point = CGPointMake((selfFrame.size.width - retSize.width) / 2, 5);
            
            textFrame = CGRectMake(point.x, point.y, retSize.width, retSize.height);
            point.y += textFrame.size.height + 5;
            
            imageFrame = CGRectMake((selfFrame.size.width - imageSize.width) / 2, point.y, imageSize.width, imageSize.height);
        }
            break;
        default:
            break;
    }
    
    self.frame = selfFrame;
    icon.frame = imageFrame;
    title.frame= textFrame;
}

- (void)shown
{
    [self performSelector:@selector(hidde) withObject:nil afterDelay:showSeconds];
}

- (void)hidde
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hidden)];
    [UIView setAnimationDuration:0.5];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)hidden
{
    if (callBack) callBack(self);
    
    [self removeFromSuperview];
}

- (void)showInView:(UIView*)view
{
    [view addSubview:self];
    
    [self layoutInit];
}

- (void)showInView:(UIView*)view AnimateStyle:(NSInteger)style
{
    [view addSubview:self];
    [self layoutInit];
    
    if (1 == style)
    {
        CAKeyframeAnimation* keyanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        
        keyanimation.duration = 0.3;
        keyanimation.fillMode = kCAFillModeForwards;
        keyanimation.values = [NSArray arrayWithObjects:
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 1)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                               nil];
        
        NSArray *frameTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:1],
                               nil];
        [keyanimation setKeyTimes:frameTimes];
        
        [self.layer addAnimation:keyanimation forKey:@"transFormScale"];
    }
}

@end




