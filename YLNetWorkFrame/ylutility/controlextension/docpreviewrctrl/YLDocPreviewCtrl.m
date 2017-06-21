//
//  DocPreviewCtrl.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLDocPreviewCtrl.h"

@implementation YLDocPreviewCtrl
{
    UIWebView*                  webView;
    NSString*                   url;
    BOOL                        isLoaded;
    UIActivityIndicatorView*    indicator;
    UILabel*                    notice;
}

- (instancetype)init:(BOOL)isshownavbar Path:(NSString*)path
{
    self = [super init];
    if (self)
    {
        url = path;
        if (isshownavbar) webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 0, 0)];
        else webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoaded = NO;
    
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:webView];
    
    NSArray* constraint = nil;
    if (webView.frame.origin.y > 0)
    {
        constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webView]-0-|" options:0 metrics:nil views:@{@"webView":webView}];
    }
    else
    {
        constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":webView}];
    }
    
    [self.view addConstraints:constraint];
    
    constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":webView}];
    [self.view addConstraints:constraint];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded)
    {
        isLoaded = YES;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        indicator.hidesWhenStopped = YES;
        [self.view addSubview:indicator];
        [indicator startAnimating];
        
        notice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        notice.backgroundColor = [UIColor clearColor];
        notice.textColor = [UIColor grayColor];
        notice.textAlignment = NSTextAlignmentCenter;
        notice.font = [UIFont systemFontOfSize:13];
        notice.numberOfLines = 0;
        notice.text = @"数据错误，加载失败！";
        notice.hidden = YES;
        [self.view addSubview:notice];
        
        [self loadDocument:url];
    }
}

- (void)loadDocument:(NSString*)path
{
    if ([path length] > 0)
    {
        NSURL* Url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:Url];
        [webView loadRequest:request];
    }
    else
    {
        //
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    indicator.hidden = YES;
    notice.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    indicator.hidden = YES;
    
    [self showNotice];
}

- (void)showNotice
{
    notice.frame = CGRectMake(0, 0, 200, 30);
    notice.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    notice.textColor = [UIColor whiteColor];
    notice.layer.shadowRadius = 5;
    notice.layer.shadowOpacity = 0.6;
    notice.layer.shadowColor = [UIColor blackColor].CGColor;
    notice.layer.shadowOffset = CGSizeMake(3, 3);
    notice.text = @" 手指捏合或者连续点击进行缩放 ";
    
    CALayer* layer = [CALayer layer];
    layer.frame = notice.bounds;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    [notice.layer insertSublayer:layer atIndex:0];

    notice.hidden = NO;
    [self performSelector:@selector(hiddeNotice) withObject:nil afterDelay:1.5];
}

- (void)hiddeNotice
{
    notice.hidden = YES;
}

@end
