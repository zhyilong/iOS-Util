//
//  TableRefreshHeader.m
//  QQCar
//
//  Created by qqcy on 15/3/6.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import "YLRefresh+UIScrollView.h"
#import <objc/runtime.h>

@implementation UIScrollView (YLLoader)

- (void)setTopLoader:(YLTableTopLoader*)loader
{
    objc_setAssociatedObject(self, "YLTopLoader", loader, OBJC_ASSOCIATION_ASSIGN);
    
    [self updateLoadingState:YLTable_Load_Free];
}

- (YLTableTopLoader*)getTopLoader
{
    return objc_getAssociatedObject(self, "YLTopLoader");
}

- (void)setBottomLoader:(YLTableBottomLoader*)loader
{
    objc_setAssociatedObject(self, "YLBottomLoader", loader, OBJC_ASSOCIATION_ASSIGN);
    
    [self updateLoadingState:YLTable_Load_Free];
}

- (YLTableBottomLoader*)getBottomLoader
{
    return objc_getAssociatedObject(self, "YLBottomLoader");
}

- (void)updateLoadingState:(YLTableLoadingState)state
{
    objc_setAssociatedObject(self, "loadtype", [NSNumber numberWithInteger:state], OBJC_ASSOCIATION_RETAIN);
}

- (YLTableLoadingState)getLoadingState
{
    id state = objc_getAssociatedObject(self, "loadtype");
    
    if (nil == state) return YLTable_Load_Free;
    
    return [state integerValue];
}

- (void)stopLoading
{
    if (YLTable_Load_Top == [self getLoadingState])
    {
        [[self getTopLoader] stop];
    }
    else if (YLTable_Load_Bottom == [self getLoadingState])
    {
        [[self getBottomLoader] stop];
    }
    else ;
}

- (void)dealloc
{
    [[self getTopLoader] free];
    [[self getBottomLoader] free];
}

@end

/*****************************************
 *
 * 刷新
 *
 ****************************************/
@implementation YLTableTopLoader

@synthesize title;
@synthesize indicator;
@synthesize accessory;

@synthesize delegate;
@synthesize state;

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll
{
    if ([super initWithFrame:frame])
    {
        self.delegate = nil;
        isDraged = NO;
        state = YLTable_Loader_Free;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.frame.size.width - indicator.frame.size.width / 2, self.frame.size.height / 2);
        indicator.hidesWhenStopped = YES;
        indicator.hidden = YES;
        [self addSubview:indicator];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, 0, self.frame.size.width, self.frame.size.height)];
        title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setTopLoader:self];
        
        [scroll addSubview:self];

        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<YLTableTopLoaderDelegate>)delegatep
{
    if ([super initWithFrame:frame])
    {
        [scroll addSubview:self];
        
        self.delegate = delegatep;
        isDraged = NO;
        state = YLTable_Loader_Free;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.frame.size.width - indicator.frame.size.width / 2, self.frame.size.height / 2);
        indicator.hidesWhenStopped = YES;
        indicator.hidden = YES;
        [self addSubview:indicator];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, 0, frame.size.width, frame.size.height)];
        title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:title];

        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setTopLoader:self];

        return self;
    }
    
    return nil;
}

- (void)setUpAccessory:(UIView *)accessoryp
{
    [self.accessory removeFromSuperview];
    
    self.accessory = accessoryp;
    self.accessory.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:accessoryp];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView* scroll = (UIScrollView*)object;
    
    if (delegate)
    {
        //状态回调
        if ([delegate respondsToSelector:@selector(didYLTableTopLoaderDragingForState:State:ContentOffset:)]) [delegate didYLTableTopLoaderDragingForState:self State:state ContentOffset:scroll.contentOffset];
        
        //scroll手指刚开始拖动
        if (!isDraged && scroll.dragging)
        {
            isDraged = YES;
            
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableTopLoaderAccessoryView:self State:state];
                [self setUpAccessory:view];
            }
            
            if (!accessory)
            {
                title.text = [delegate didYLTableTopLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
  
    //scroll手指松开,回调刷新
    if (scroll.contentOffset.y < self.frame.origin.y / 2 && !scroll.dragging)
    {
        //从闲置到开始
        if (YLTable_Loader_Free == state)
        {
            state = YLTable_Loader_Will;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(startCallback)];
            scroll.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
            [UIView commitAnimations];
        }
    }
}

- (void)startCallback
{
    UIScrollView* table = (UIScrollView*)[self superview];
    [table updateLoadingState:YLTable_Load_Top];
    
    //刷新回调
    if (delegate && [delegate respondsToSelector:@selector(didYLTableTopLoaderSelected:)])
    {

        [delegate didYLTableTopLoaderSelected:self];
    }
    
    //设置状态，从将要开始到正在刷新
    if (YLTable_Loader_Will == state)
    {
        state = YLTable_Loader_Runing;

        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableTopLoaderAccessoryView:self State:state];
                [self setUpAccessory:view];
            }
            
            if (!accessory)
            {
                indicator.hidden = NO;
                [indicator startAnimating];
                
                title.text = [delegate didYLTableTopLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
}

- (void)stop
{
    if (YLTable_Loader_Will == state || YLTable_Loader_Runing == state)
    {
        state = YLTable_Loader_Free;
        isDraged = NO;
        
        UIScrollView* scroll = (UIScrollView*)self.superview;
        
        [UIView beginAnimations:nil context:nil];
        scroll.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];

        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableTopLoaderAccessoryView:self State:state];
                [self setAccessory:view];
            }
            
            if (!accessory)
            {
                [indicator stopAnimating];
                
                title.text = [delegate didYLTableTopLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
}

- (void)setTitlePosition:(NSString*)titlep
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attribute = @{NSFontAttributeName:self.title.font};
    CGRect rect = [titlep boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.title.frame.size.height) options:options attributes:attribute context:nil];
    
    if (rect.size.width > self.frame.size.width - indicator.frame.size.width)
    {
        rect.size.width = self.frame.size.width - indicator.frame.size.width;
    }
    
    if (!indicator.hidden)
    {
        CGFloat x = (self.frame.size.width - indicator.frame.size.width - rect.size.width) / 2;
        indicator.frame = CGRectMake(x, indicator.frame.origin.y, indicator.frame.size.width, indicator.frame.size.height);
        self.title.frame = CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, self.title.frame.origin.y, rect.size.width, self.title.frame.size.height);
    }
    else
    {
        self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, rect.size.width, self.title.frame.size.height);
        self.title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

- (void)rotationView:(UIView*)view Animate:(BOOL)animate
{
    if (view)
    {
        if (YLTable_Loader_Free == state)
        {
            if (animate)
            {
                [UIView beginAnimations:nil context:nil];
                view.transform = CGAffineTransformMakeRotation(0);
                [UIView commitAnimations];
            }
            else
            {
                view.transform = CGAffineTransformMakeRotation(0);
            }
        }
        else
        {
            if (animate)
            {
                [UIView beginAnimations:nil context:nil];
                view.transform = CGAffineTransformMakeRotation(M_PI);
                [UIView commitAnimations];
            }
            else
            {
                view.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }
    }
}

- (void)free
{
    [[self superview] removeObserver:self forKeyPath:@"contentOffset"];
}

@end


/*****************************************
 *
 * 更多
 *
 ****************************************/

@implementation YLTableBottomLoader

@synthesize title;
@synthesize indicator;
@synthesize accessory;

@synthesize delegate;
@synthesize state;
@synthesize superHeight;

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll
{
    if ([super initWithFrame:frame])
    {
        self.delegate = nil;
        isDraged = NO;
        state = YLTable_Loader_Free;
        superHeight = scroll.contentSize.height;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.frame.size.width - indicator.frame.size.width / 2, self.frame.size.height / 2);
        indicator.hidesWhenStopped = YES;
        indicator.hidden = YES;
        [self addSubview:indicator];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, 0, frame.size.width, frame.size.height)];
        title.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:13];
        title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:title];
        
        [scroll addSubview:self];
        
        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scroll addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setBottomLoader:self];
        
        self.hidden = YES;
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<YLTableTopLoaderDelegate>)delegate
{
    if ([super initWithFrame:frame])
    {
        self.delegate = delegate;
        isDraged = NO;
        state = YLTable_Loader_Free;
        superHeight = scroll.contentSize.height;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.frame.size.width - indicator.frame.size.width / 2, self.frame.size.height / 2);
        indicator.hidesWhenStopped = YES;
        indicator.hidden = YES;
        [self addSubview:indicator];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, 0, frame.size.width, frame.size.height)];
        title.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:13];
        title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:title];
        
        [scroll addSubview:self];
        
        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scroll addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setBottomLoader:self];
        
        self.hidden = YES;
        
        return self;
    }
    
    return nil;
}

- (void)setUpAccessory:(UIView *)accessory
{
    [self.accessory removeFromSuperview];
    
    self.accessory = accessory;
    self.accessory.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:accessory];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView* scroll = (UIScrollView*)object;
    
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(didYLTableBottomLoaderDragingForState:State:ContentOffset:)]) [delegate didYLTableBottomLoaderDragingForState:self State:state ContentOffset:scroll.contentOffset];
        
        if (!isDraged && scroll.dragging)
        {
            isDraged = YES;
            
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableBottomLoaderAccessoryView:self State:state];
                [self setUpAccessory:view];
            }
            
            if (!accessory)
            {
                title.text = [delegate didYLTableBottomLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
    
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if (superHeight != scroll.contentSize.height)
        {
            superHeight = scroll.contentSize.height;
            self.frame = CGRectMake(0, superHeight, self.frame.size.width, self.frame.size.height);
        }
    }
    else
    {
        CGFloat h = scroll.frame.size.height;

        CGFloat height = scroll.contentOffset.y + h;
        
        if ( (height - scroll.contentSize.height) > self.frame.size.height / 2 && !scroll.dragging)
        {
            if (YLTable_Loader_Free == state && scroll.contentSize.height >= h)
            {
                state = YLTable_Loader_Will;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(startCallback)];
                scroll.contentInset = UIEdgeInsetsMake(0, 0, self.frame.size.height, 0);
                [UIView commitAnimations];
            }
        }
    }
    
    [self isShow];
}

- (void)startCallback
{
    UIScrollView* table = (UIScrollView*)[self superview];
    [table updateLoadingState:YLTable_Load_Bottom];

    if (delegate && [delegate respondsToSelector:@selector(didYLTableBottomLoaderSelected:)]) [delegate didYLTableBottomLoaderSelected:self];
    
    if (YLTable_Loader_Will == state)
    {
        state = YLTable_Loader_Runing;
        
        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableBottomLoaderAccessoryView:self State:state];
                [self setUpAccessory:view];
            }
            
            if (!accessory)
            {
                indicator.hidden = NO;
                [indicator startAnimating];
                
                title.text = [delegate didYLTableBottomLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
}

- (void)setTitlePosition:(NSString*)title
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attribute = @{NSFontAttributeName:self.title.font};
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.title.frame.size.height) options:options attributes:attribute context:nil];
    
    if (rect.size.width > self.frame.size.width - indicator.frame.size.width)
    {
        rect.size.width = self.frame.size.width - indicator.frame.size.width;
    }
    
    if (!indicator.hidden)
    {
        CGFloat x = (self.frame.size.width - indicator.frame.size.width - rect.size.width) / 2;
        indicator.frame = CGRectMake(x, indicator.frame.origin.y, indicator.frame.size.width, indicator.frame.size.height);
        self.title.frame = CGRectMake(indicator.frame.origin.x + indicator.frame.size.width + 5, self.title.frame.origin.y, rect.size.width, self.title.frame.size.height);
    }
    else
    {
        self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, rect.size.width, self.title.frame.size.height);
        self.title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

- (void)stop
{
    if (YLTable_Loader_Runing == state || YLTable_Loader_Will == state)
    {
        state = YLTable_Loader_Free;
        isDraged = NO;
        
        UIScrollView* scroll = (UIScrollView*)self.superview;
        
        [UIView beginAnimations:nil context:nil];
        scroll.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
        
        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(didYLTableTopLoaderAccessoryView:State:)])
            {
                UIView* view = [delegate didYLTableBottomLoaderAccessoryView:self State:state];
                [self setAccessory:view];
            }
            
            if (!accessory)
            {
                [indicator stopAnimating];
                
                title.text = [delegate didYLTableBottomLoaderTitleForState:self State:state];
                [self setTitlePosition:title.text];
            }
        }
    }
}

- (void)free
{
    [[self superview] removeObserver:self forKeyPath:@"contentOffset"];
    [[self superview] removeObserver:self forKeyPath:@"contentSize"];
}

- (void)isShow
{
    UIScrollView* scroll = (UIScrollView*)self.superview;

    if (scroll.contentSize.height > scroll.frame.size.height)
    {
        indicator.hidden = NO;
        [indicator startAnimating];
        
        self.hidden = NO;
    }
    else
    {
        self.hidden = YES;
        
        indicator.hidden = YES;
        [indicator stopAnimating];
    }
}

@end

