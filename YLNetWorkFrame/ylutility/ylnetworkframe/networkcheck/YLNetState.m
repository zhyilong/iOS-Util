//
//  UNNetState.m
//  UNCheckNetState
//
//  Created by zhangyilong on 15/10/20.
//  Copyright © 2015年 zhangyilong. All rights reserved.
//

#import "YLNetState.h"
#import <UIKit/UIKit.h>

@implementation YLNetState
{
    Reachability*       _reachability;
    UIView*             _view;
    UILabel*            _title;
    BOOL                _isShown;
}

- (void)dealloc
{
    //
}

- (instancetype)initWithHostName:(NSString *)url
{
    self = [super init];
    if (nil != self)
    {
        [self setupView];
        
        _reachability = [Reachability reachabilityWithHostName:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        [_reachability startNotifier];
    }
    
    return self;
}

- (void)setupView
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    _view.backgroundColor = [UIColor clearColor];
    _view.layer.shadowOpacity = 0.8;
    _view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _view.layer.shadowOffset = CGSizeMake(1, 1);
    _view.center = CGPointMake(winsize.width / 2, winsize.height / 2 - 50);
    _view.userInteractionEnabled = NO;
    [window addSubview:_view];
    
    UIView* view = [[UIView alloc] initWithFrame:_view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.alpha = 0.7;
    [_view addSubview:view];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, _view.bounds.size.width - 4, _view.bounds.size.height - 4)];
    _title.backgroundColor = [UIColor clearColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14];
    _title.textColor = [UIColor whiteColor];
    _title.numberOfLines = 0;
    [_view addSubview:_title];
    
    _view.alpha = 0;
    _isShown = NO;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability * reach = [notification object];
    
    if(NotReachable == [reach currentReachabilityStatus])
    {
        _title.text = @"没有可用网络";
    }
    else
    {
        if (ReachableViaWiFi == [reach currentReachabilityStatus])
        {
            _title.text = @"当前通过wifi连接";
        }
        else if (ReachableViaWWAN == [reach currentReachabilityStatus])
        {
            _title.text = @"当前通过2G/3G/4G连接";
        }
        else
        {
            _title.text = @"没有可用网络";
        }
    }
    
    [self show];
}

- (void)show
{
    if (!_isShown)
    {
        _isShown = YES;
        
        [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(shown)];
        _view.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)shown
{
    [self performSelector:@selector(hidde) withObject:nil afterDelay:1];
}

- (void)hidde
{
    [UIView beginAnimations:nil context:nil];
    _isShown = NO;
    _view.alpha = 0.0;
    [UIView commitAnimations];
}

@end
