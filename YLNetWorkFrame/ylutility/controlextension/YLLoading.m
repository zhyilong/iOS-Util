//
//  Loading.m
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/15.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "YLLoading.h"
#import <objc/runtime.h>

@interface YLLoading ()

@property(nonatomic, strong) dispatch_source_t   timer;

@end

@implementation YLLoading
{
    UIView*             contentView;
}

@synthesize shadow;
@synthesize indicator;
@synthesize uiTitle;
@synthesize icon;
@synthesize mask;
@synthesize style;
@synthesize timer;

- (void)dealloc
{
    if (timer) dispatch_source_cancel(timer);
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title Image:(UIImage*)image
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0;
        
        style = YLLoading_Accessory_Top;
        
        //透明背景
        mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.3;
        mask.hidden = YES;
        [self addSubview:mask];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
        contentView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        shadow = [[UIView alloc] initWithFrame:contentView.bounds];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.layer.cornerRadius = 6;
        shadow.layer.borderColor = [UIColor whiteColor].CGColor;
        shadow.layer.borderWidth = 1;
        shadow.alpha = 0.8;
        [contentView addSubview:shadow];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2);
        indicator.hidesWhenStopped = NO;
        [contentView addSubview:indicator];

        //图片
        if (image)
        {
            indicator.hidden = YES;
            
            icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, indicator.frame.size.width, indicator.frame.size.height)];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            icon.image = image;
        
            [contentView addSubview:icon];
        }
        
        //标题
        if ([title length] > 0)
        {
            uiTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            uiTitle.backgroundColor = [UIColor clearColor];
            uiTitle.textColor = [UIColor whiteColor];
            uiTitle.font = [UIFont systemFontOfSize:13];;
            uiTitle.textAlignment = NSTextAlignmentCenter;
            uiTitle.lineBreakMode = NSLineBreakByTruncatingTail;
            uiTitle.numberOfLines = 0;
            uiTitle.text = title;
            [contentView addSubview:uiTitle];

            CGSize size = [self getTitleShowSize:CGSizeMake(contentView.frame.size.width - 10, CGFLOAT_MAX)];
            
            if (image)
            {
                contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, 5 + icon.frame.size.height + 5 + size.height + 5);
                icon.frame = CGRectMake((contentView.frame.size.width - icon.frame.size.width) / 2, 5, icon.frame.size.width, icon.frame.size.height);
                uiTitle.frame = CGRectMake((contentView.frame.size.width - size.width) / 2, CGRectGetMaxY(icon.frame) + 5, size.width, size.height);
            }
            else
            {
                contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, 5 + indicator.frame.size.height + 5 + size.height + 5);
                indicator.frame = CGRectMake((contentView.frame.size.width - indicator.frame.size.width) / 2, 5, indicator.frame.size.width, indicator.frame.size.height);
                uiTitle.frame = CGRectMake((contentView.frame.size.width - size.width) / 2, CGRectGetMaxY(indicator.frame) + 5, size.width, size.height);
            }
        }
        else
        {
            if (image)
            {
                contentView.frame = CGRectMake(0, 0, 5 + icon.frame.size.width + 5, 5 + icon.frame.size.height + 5);
                icon.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2);
            }
            else
            {
                contentView.frame = CGRectMake(0, 0, 5 + indicator.frame.size.width + 5, 5 + indicator.frame.size.height + 5);
                indicator.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2);
            }
        }
        
        shadow.frame = contentView.bounds;
        
        contentView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        return self;
    }
    
    return nil;
}

- (void)hiddeSubViews
{
    mask.hidden = YES;
    shadow.hidden = YES;
    indicator.hidden = YES;
    uiTitle.hidden = YES;
    icon.hidden = YES;
}

- (void)showSubViews
{
    mask.hidden = NO;
    shadow.hidden = NO;
    indicator.hidden = NO;
    uiTitle.hidden = NO;
    icon.hidden = NO;
}

+ (YLLoading*)CreateFullScreenLoading:(NSString*)title Image:(UIImage*)image AtonceShow:(BOOL)atonceshow
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    
    YLLoading* loading = [[YLLoading alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height) Title:title Image:image];
    
    [[UIApplication sharedApplication].keyWindow addSubview:loading];
    
    [[UIApplication sharedApplication].keyWindow setLoading:loading];
    
    if (atonceshow) [loading show];
    
    return loading;
}

+ (YLLoading*)CreateLoadingInView:(UIView*)inview Title:(NSString*)title Image:(UIImage*)image AtonceShow:(BOOL)atonceshow
{
    CGRect frame = inview.frame;
    
    YLLoading* loading = [[YLLoading alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) Title:title Image:image];
    
    [inview addSubview:loading];
    
    [inview setLoading:loading];
    
    if (atonceshow) [loading show];
    
    return loading;
}

- (void)setStyle:(YLLoadingStyle)styleparam
{
    style = styleparam;
    
    switch (style)
    {
        case YLLoading_Accessory_Top:
            break;
        case YLLoading_Accessory_Left:
            [self layoutIndicatorLeft];
            break;
        default:
            break;
    }
    
    [self show];
}

- (CGSize)getTitleShowSize:(CGSize)srcsize
{
    return [uiTitle.text boundingRectWithSize:srcsize
                               options:\
     NSStringDrawingTruncatesLastVisibleLine |
     NSStringDrawingUsesLineFragmentOrigin |
     NSStringDrawingUsesFontLeading
                            attributes:@{NSFontAttributeName:uiTitle.font}
                               context:nil].size;
}

- (void)layoutIndicatorLeft
{
    if ([uiTitle.text length] > 0)
    {
        CGRect frame = self.frame;
        CGSize contentsize = CGSizeZero;
        CGSize textsize =  [self getTitleShowSize:CGSizeMake(CGFLOAT_MAX, indicator.frame.size.height)];
        
        contentsize.width = 5 + indicator.frame.size.width + 5 + textsize.width + 5;

        //与父宽度比较
        if (contentsize.width > (frame.size.width - 32))
        {
            //换行计算高度
            frame.size.width = frame.size.width - 32;
            textsize = [self getTitleShowSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
            
            contentsize.width = 5 + indicator.frame.size.width + 5 + textsize.width + 5;
        }
        
        if (!icon.image) contentsize.height = (textsize.height < indicator.frame.size.height) ? (indicator.frame.size.height) : (textsize.height);
        else contentsize.height = (textsize.height < icon.frame.size.height) ? (icon.frame.size.height) : (textsize.height);
        contentsize.height += 10;

        contentView.frame = CGRectMake(0, 0, contentsize.width, contentsize.height);
        contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        shadow.frame = contentView.bounds;
        
        if (!icon.image)
        {
            frame.origin.x = 5 + indicator.frame.size.width / 2;
            indicator.center = CGPointMake(frame.origin.x, contentsize.height / 2);
            
            frame.origin.x = indicator.frame.origin.x + indicator.frame.size.width + 5;
        }
        else
        {
            frame.origin.x = 5 + icon.frame.size.width / 2;
            icon.center = CGPointMake(frame.origin.x, contentsize.height / 2);
            
            frame.origin.x = icon.frame.origin.x + icon.frame.size.width + 5;
        }
        
        frame.origin.y = (contentsize.height - textsize.height) / 2;
        frame.size = textsize;
        uiTitle.frame = frame;
    }
    else
    {
        if (icon.image)
        {
            contentView.frame = CGRectMake(0, 0, 5 + icon.frame.size.width + 5, 5 + icon.frame.size.height + 5);
            icon.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2);
        }
        else
        {
            contentView.frame = CGRectMake(0, 0, 5 + indicator.frame.size.width + 5, 5 + indicator.frame.size.height + 5);
            indicator.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2);
        }
        
        shadow.frame = contentView.bounds;
        
        contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

+ (void)HiddeFullScreenLoading
{
    [[UIApplication sharedApplication].keyWindow removeLoading];
}

- (void)show
{
    if (!indicator.hidden && !icon.image)
    {
        [indicator startAnimating];
    }
    
    [UIView beginAnimations:nil context:nil];
    self.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hidde
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHidden)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)didHidden
{
    //[indicator stopAnimating];
    //[self showSubViews];
    
    [self remove];
}

- (void)remove
{
    [self removeFromSuperview];
}

- (void)setTimeOut:(NSInteger)seconds Callback:(YLLoadingTimeout)callback
{
    if (seconds > 0)
    {
        __weak typeof(self) blockself = self;
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(seconds * NSEC_PER_SEC);
        dispatch_source_set_timer(timer, start, interval, 0);
        dispatch_source_set_event_handler(timer, ^{
            
            dispatch_source_cancel(blockself.timer);
            blockself.timer = nil;
            
            if (callback) callback(blockself);
            
        });
        dispatch_resume(timer);
    }
}

@end

@implementation UIView (YLLoading)

- (void)setLoading:(YLLoading*)loading
{
    objc_setAssociatedObject(self, "YLLoading", loading, OBJC_ASSOCIATION_ASSIGN);
}

- (YLLoading*)getLoading
{
    return objc_getAssociatedObject(self, "YLLoading");
}

- (void)removeLoading
{
    YLLoading* loading = [self getLoading];
    
    if (loading)
    {
        [loading hidde];
    }
    
    objc_setAssociatedObject(self, "YLLoading", nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
