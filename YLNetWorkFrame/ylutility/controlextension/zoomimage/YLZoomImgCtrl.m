//
//  ZoomImgCtrl.m
//  scrollzoom
//
//  Created by zhangyilong on 15/3/29.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "YLZoomImgCtrl.h"

@interface YLZoomImgCtrl ()

@end

@implementation YLZoomImgCtrl
{
    BOOL isChange;
    CGFloat ff;
}

@synthesize delegate;
//@synthesize m_Scroll;
//@synthesize m_ImageView;
//@synthesize m_CutFrame;
//@synthesize m_Size;
//@synthesize m_Increase;

- (void)dealloc
{
}

- (instancetype)initWithImage:(UIImage*)image ClipSize:(CGSize)clipsize
{
    if ([super init])
    {
        CGSize winsize = [UIScreen mainScreen].bounds.size;
        
        self.view.backgroundColor = [UIColor blackColor];
        
        m_Scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
        m_Scroll.contentSize = CGSizeMake(winsize.width + 1, winsize.height + 1);
        m_Scroll.minimumZoomScale = 1.0;
        m_Scroll.maximumZoomScale = 2.0;
        m_Scroll.delegate = self;
        [self.view addSubview:m_Scroll];
        
        m_Scroll.contentOffset = CGPointMake(1, 1);
        
        //纠错裁剪尺寸在屏幕内
        //宽度纠错
        if (clipsize.width > winsize.width)
        {
            CGFloat f = clipsize.width / clipsize.height;
            clipsize.width = winsize.width;
            clipsize.height = clipsize.width / f;
        }
        
        //高度纠错
        if (clipsize.height > winsize.height) clipsize.height = winsize.height;
        
        m_CutFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, clipsize.width, clipsize.height)];
        m_CutFrame.backgroundColor = [UIColor clearColor];
        m_CutFrame.userInteractionEnabled = NO;
        m_CutFrame.layer.borderColor = [[UIColor whiteColor] CGColor];
        m_CutFrame.center = CGPointMake(winsize.width / 2, winsize.height / 2);
        m_CutFrame.layer.borderWidth = 1;
        
        CGFloat scale = image.size.width / image.size.height;
        m_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, clipsize.width, clipsize.width / scale)];
        m_ImageView.userInteractionEnabled = NO;
        m_Size = m_ImageView.frame.size;

        m_Scroll.clipsToBounds = NO;
        [m_Scroll addSubview:m_ImageView];
        
        //update
        m_ImageView.center = CGPointMake(m_Scroll.contentSize.width / 2, m_Scroll.contentSize.height / 2);
        ff = (m_CutFrame.frame.size.height - m_ImageView.frame.size.height) / 2;
        
        m_ImageView.image = image;
        m_Size = m_ImageView.frame.size;

        CGFloat height = m_CutFrame.frame.size.height;
        CGFloat width = clipsize.width;
        CGFloat alpha = 0.5;
        UIView* shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, (winsize.height - height) / 2)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.userInteractionEnabled = NO;
        shadow.alpha = alpha;
        [self.view addSubview:shadow];
        
        shadow = [[UIView alloc] initWithFrame:CGRectMake(0, winsize.height - (winsize.height - height) / 2, winsize.width, (winsize.height - height) / 2)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.userInteractionEnabled = NO;
        shadow.alpha = alpha;
        [self.view addSubview:shadow];
        
        shadow = [[UIView alloc] initWithFrame:CGRectMake(0, (winsize.height - height) / 2, (winsize.width - width) / 2, height)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.userInteractionEnabled = NO;
        shadow.alpha = alpha;
        [self.view addSubview:shadow];
        
        shadow = [[UIView alloc] initWithFrame:CGRectMake(winsize.width - (winsize.width - width) / 2, (winsize.height - height) / 2, (winsize.width - width) / 2, height)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.userInteractionEnabled = NO;
        shadow.alpha = alpha;
        [self.view addSubview:shadow];
        
        [self.view addSubview:m_CutFrame];
        
        shadow = [[UIView alloc] initWithFrame:CGRectMake(0, winsize.height - 80, winsize.width, 80)];
        shadow.backgroundColor = [UIColor clearColor];
        shadow.alpha = 0.8;
        [self.view addSubview:shadow];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shadow.frame.size.width, shadow.frame.size.height)];
        view.backgroundColor = [UIColor darkGrayColor];
        view.alpha = alpha;
        [shadow addSubview:view];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 15, 100, 50);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(OnCancleDown:) forControlEvents:UIControlEventTouchUpInside];
        [shadow addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(shadow.frame.size.width - 110, 15, 100, 50);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitle:@"确定" forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(OnOkDown:) forControlEvents:UIControlEventTouchUpInside];
        [shadow addSubview:btn];
        
        delegate = nil;
        
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)OnCancleDown:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(didYLZoomImgSelected:Image:)])
    {
        [delegate didYLZoomImgSelected:self Image:nil];
    }
}

- (void)OnOkDown:(UIButton*)sender
{
    //获取图像
    UIImage* image = nil;
    CGRect rect = CGRectZero;
    CGFloat scale = m_Scroll.zoomScale;
    rect = m_ImageView.frame;
    rect = [self.view convertRect:m_CutFrame.frame toView:m_Scroll];
    
    UIView* view1 = [[UIView alloc] initWithFrame:rect];
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.5;
    [m_Scroll addSubview:view1];
    
    scale = m_ImageView.image.size.width / m_ImageView.frame.size.width;
    
    rect = [m_Scroll convertRect:view1.frame toView:m_ImageView];
    
    UIView* view2 = [[UIView alloc] initWithFrame:rect];
    view2.backgroundColor = [UIColor redColor];
    [m_ImageView addSubview:view2];
    
    rect.origin = CGPointMake(view2.frame.origin.x * scale * 2, view2.frame.origin.y * scale * 2);
    rect.size = CGSizeMake(view2.frame.size.width * scale * 2, view2.frame.size.height * scale * 2);
    
    CGSize imagesize = m_ImageView.image.size;
    
    rect.origin = CGPointMake(view2.frame.origin.x * scale, view2.frame.origin.y * scale);
    rect.size = CGSizeMake(view2.frame.size.width * scale, view2.frame.size.height * scale);
    
    CGImageRef imgref = CGImageCreateWithImageInRect(m_ImageView.image.CGImage, rect);
    image = [UIImage imageWithCGImage:imgref];
    
    UIImageView* imbv = [[UIImageView alloc] initWithImage:image];
    imbv.frame = view2.bounds;
    [view2 addSubview:imbv];
    
    return;
    /*
    CGImageRef imgref = CGImageCreateWithImageInRect([m_ImageView.image CGImage], rect);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imgref);
    image = [UIImage imageWithCGImage:imgref];
    UIGraphicsEndImageContext();
    
    CGImageRelease(imgref);
    */
    
    if ([delegate respondsToSelector:@selector(didYLZoomImgSelected:Image:)])
    {
        [delegate didYLZoomImgSelected:self Image:image];
    }
    
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_ImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;

    CGSize contentsize = m_Scroll.contentSize;
    if (contentsize.height < winsize.height) contentsize.height = winsize.height;
    if (contentsize.width < winsize.width) contentsize.width = winsize.width;
    
    if (m_ImageView.frame.size.height > m_CutFrame.frame.size.height)
    {
        contentsize.height += m_ImageView.frame.size.height - m_CutFrame.frame.size.height;
        m_Scroll.contentSize = contentsize;
        CGPoint point = CGPointMake(m_Scroll.contentOffset.x, (m_ImageView.frame.size.height - m_CutFrame.frame.size.height) / 2);
        if (m_Scroll.zoomScale >= m_Scroll.maximumZoomScale) [m_Scroll setContentOffset:point animated:YES];
    }
    else
    {
        m_Scroll.contentSize = contentsize;
    }
    
    m_ImageView.center = CGPointMake(m_Scroll.contentSize.width / 2, m_Scroll.contentSize.height / 2);
}

@end
