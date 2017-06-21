//
//  YLImageEditView.m
//  YLAppUtility
//
//  Created by yilong zhang on 2016/12/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLImageEditView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation YLImageEditView
{
    UIScrollView*               scrollView;
    UIView*                     cropBox;
    UIImageView*                imageView;
}

@synthesize image;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame CropSize:(CGSize)cropsize
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        image = nil;
        delegate = nil;
        self.backgroundColor = [UIColor blackColor];
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor lightGrayColor];
        scrollView.contentSize = self.bounds.size;
        scrollView.maximumZoomScale = 1.5;
        scrollView.minimumZoomScale = 0.5;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        [scrollView addSubview:imageView];
        
        cropBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cropsize.width, cropsize.height)];
        cropBox.backgroundColor = [UIColor clearColor];
        cropBox.layer.borderColor = [UIColor redColor].CGColor;
        cropBox.layer.borderWidth = 1;
        cropBox.userInteractionEnabled = NO;
        cropBox.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:cropBox];
        
        UIView* shadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 80, self.frame.size.width, 80)];
        shadow.backgroundColor = [UIColor clearColor];
        shadow.alpha = 0.8;
        [self addSubview:shadow];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shadow.frame.size.width, shadow.frame.size.height)];
        view.backgroundColor = [UIColor darkGrayColor];
        view.alpha = 0.5;
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
    }
    
    return self;
}

- (void)setMinScale:(CGFloat)scale
{
    scrollView.minimumZoomScale = scale;
}

- (void)setMaxScale:(CGFloat)scale
{
    scrollView.maximumZoomScale = scale;
}

- (void)setImage:(UIImage *)src
{
    image = src;
    
    CGSize size = [self getImageSize];
    CGSize contentsize = scrollView.frame.size;
    CGPoint offset = CGPointMake(0, 0);
    
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (imageView.frame.size.height > cropBox.frame.size.height)
    {
        contentsize.height = scrollView.frame.size.height + (imageView.frame.size.height - cropBox.frame.size.height);
        offset.y = (imageView.frame.size.height - cropBox.frame.size.height) / 2;
    }
    
    if (imageView.frame.size.width > cropBox.frame.size.width)
    {
        contentsize.width = scrollView.frame.size.width + (imageView.frame.size.width - cropBox.frame.size.width);
        offset.x = (imageView.frame.size.width - cropBox.frame.size.width) / 2;
    }
    
    contentsize.width += 1;
    contentsize.height += 1;
    
    scrollView.contentSize = contentsize;
    scrollView.contentOffset = offset;
    
    imageView.center = CGPointMake(contentsize.width / 2, contentsize.height / 2);
    imageView.image = image;
}

- (CGSize)getImageSize
{
    CGSize screensize = scrollView.frame.size;
    CGSize size = image.size;
    CGFloat imgscale = size.width / size.height;
    CGFloat hscale = screensize.width / size.width;
    CGFloat vscale = screensize.height / size.height;
    
    if (size.width > size.height)
    {
        size.width = size.width * hscale;
        size.height = size.width / imgscale;
    }
    else if (size.width < size.height)
    {
        size.height = size.height * vscale;
        size.width = size.height * imgscale;
    }
    else
    {
        if (screensize.width < screensize.height)
        {
            size.width = size.width * vscale;
            size.height = size.height * vscale;
        }
        else
        {
            size.width = size.width * hscale;
            size.height = size.height * hscale;
        }
    }
    
    return size;
}

- (void)OnCancleDown:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(ylimageEditView:DidCropImage:)])
    {
        [delegate ylimageEditView:self DidCropImage:nil];
    }
}

- (void)OnOkDown:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(ylimageEditView:DidCropImage:)])
    {
        [delegate ylimageEditView:self DidCropImage:[self getImage]];
    }
}

- (UIImage*)getImage
{
    //获取图像
    UIImage* image = nil;
    CGRect rect = CGRectZero;
    CGFloat scale = scrollView.zoomScale;
    rect = imageView.frame;
    rect = [self convertRect:cropBox.frame toView:scrollView];
    
    UIView* view1 = [[UIView alloc] initWithFrame:rect];
    view1.backgroundColor = [UIColor clearColor ];
    [scrollView addSubview:view1];
    
    scale = self.image.size.width / imageView.frame.size.width;
    
    rect = [scrollView convertRect:view1.frame toView:imageView];
    
    UIView* view2 = [[UIView alloc] initWithFrame:rect];
    view2.backgroundColor = [UIColor clearColor];
    //view2.layer.borderColor = [UIColor greenColor].CGColor;
    //view2.layer.borderWidth = 1;
    [imageView addSubview:view2];
    
    CGSize imagesize = imageView.image.size;
    
    UIImageView* imbv = [[UIImageView alloc] initWithImage:nil];
    imbv.frame = CGRectMake(0, 0, imagesize.width, imagesize.height);
    imbv.layer.borderColor = [UIColor orangeColor].CGColor;
    imbv.layer.borderWidth = 5;
    [scrollView addSubview:imbv];
    
    scrollView.contentSize = imagesize;
    scrollView.contentOffset = CGPointZero;
    
    scale = [UIScreen mainScreen].scale;
    rect = view2.frame;
    rect.origin = CGPointMake(rect.origin.x * scale + 0.5, rect.origin.y * scale + 0.5);
    rect.size = CGSizeMake(rect.size.width * scale + 0.5, rect.size.height * scale + 0.5);
    
    //imagesize = CGSizeMake(imagesize.width * scale, imagesize.height * scale);
    
    //if (rect.origin.x < 0) rect.origin.x = 0;
    //if (rect.origin.y < 0) rect.origin.y = 0;
    //if (rect.size.width > imagesize.width) rect.size.width = imagesize.width;
    //if (rect.size.height > imagesize.height) rect.size.height = imagesize.height;
    
    //view2 = [[UIView alloc] initWithFrame:rect];
    //view2.backgroundColor = [UIColor clearColor];
    //view2.alpha = 0.8;
    //[imbv addSubview:view2];
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.image.CGImage, rect);
    //UIImageView* v = [[UIImageView alloc] initWithFrame:cropBox.frame];
    //v.contentMode = UIViewContentModeScaleAspectFit;
    image = [UIImage imageWithCGImage:subImageRef];
    //v.image = image;
    //[self addSubview:v];
    
    return image;
}

//delegate of scrollview
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    //
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSString* str = [NSString stringWithFormat:@"imageView’size: (%.2f, %.2f)", imageView.frame.size.width, imageView.frame.size.height];
    NSLog(@"%@", str);
    
    str = [NSString stringWithFormat:@"scrollView’contentSize: (%.2f, %.2f)", scrollView.contentSize.width, scrollView.contentSize.height];
    NSLog(@"%@", str);
    
    CGSize contentSize = scrollView.contentSize;
    CGPoint point = imageView.center;
    
    if (imageView.frame.size.width < scrollView.frame.size.width)
    {
        contentSize.width = scrollView.frame.size.width;
        point.x = scrollView.frame.size.width / 2;
    }
    else
    {
        //
    }
    
    if (imageView.frame.size.height < scrollView.frame.size.height)
    {
        contentSize.height = scrollView.frame.size.height;
        point.y = scrollView.frame.size.height / 2;
    }
    else
    {
        //
    }
    
    //imageView.center = point;
    //scrollView.contentSize = contentSize;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize contentsize = scrollView.frame.size;
    CGPoint offset = CGPointMake(0, 0);
    CGPoint center = imageView.center;

    //
    if (imageView.frame.size.height > cropBox.frame.size.height)
    {
        contentsize.height = scrollView.frame.size.height + (imageView.frame.size.height - cropBox.frame.size.height);
        offset.y = (imageView.frame.size.height - cropBox.frame.size.height) / 2;
    }
    else
    {
        center.y = contentsize.height / 2;
    }
    
    if (imageView.frame.size.width > cropBox.frame.size.width)
    {
        contentsize.width = scrollView.frame.size.width + (imageView.frame.size.width - cropBox.frame.size.width);
        offset.x = (imageView.frame.size.width - cropBox.frame.size.width) / 2;
    }
    else
    {
        center.x = contentsize.width / 2;
    }
    
    contentsize.width += 1;
    contentsize.height += 1;
    
    scrollView.contentSize = contentsize;
    center = CGPointMake(contentsize.width / 2, contentsize.height / 2);
    
    [UIView beginAnimations:nil context:nil];
    imageView.center = center;
    [UIView commitAnimations];
}

@end
