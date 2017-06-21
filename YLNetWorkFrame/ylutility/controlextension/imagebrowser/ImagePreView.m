//
//  ImagePreView.m
//  SchoolBadge_teacher
//
//  Created by zhangyilong on 15/8/7.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "ImagePreView.h"
#import "UIImageView+YLNetWorkFrame.h"

@implementation PreSubScroll

@synthesize imageView;

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        self.maximumZoomScale = 1.5;
        self.minimumZoomScale = 1;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        
        return self;
    }
    
    return nil;
}

- (void)updateImage:(UIImage*)image
{
    CGSize size = imageView.image.size;
    CGFloat scale = self.frame.size.width / size.width;
    
    size.width = self.frame.size.width;
    size.height *= scale;
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.contentSize = imageView.frame.size;

    [self centerContent];
}

- (void)centerContent
{
    CGRect frame = imageView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (nil == imageView.image) return nil;
    
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

@end




@interface ImagePreView ()

@end

@implementation ImagePreView
{
    PreSubScroll*   curPage;
}

@synthesize scrollView;

@synthesize items;

@synthesize topview;
@synthesize toptitle;
@synthesize back;

- (void)dealloc
{
    [self.items removeAllObjects];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        UIView* shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        shadow.backgroundColor = [UIColor blackColor];
        [self addSubview:shadow];
        
//        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//        title.textColor = [UIColor whiteColor];
//        title.text = @"图片加载中...";
//        title.font = [UIFont systemFontOfSize:15];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
//        [self addSubview:title];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Top_Height, frame.size.width, frame.size.height - Top_Height)];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, Top_Height)];
        topview.backgroundColor = [UIColor clearColor];
        [self addSubview:topview];
        
        shadow = [[UIView alloc] initWithFrame:topview.bounds];
        shadow.backgroundColor = [UIColor blackColor];
        [topview addSubview:shadow];
        
        toptitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, Top_Height)];
        toptitle.textColor = [UIColor whiteColor];
        toptitle.text = @"0/0";
        toptitle.font = [UIFont boldSystemFontOfSize:18];
        toptitle.textAlignment = NSTextAlignmentCenter;
        toptitle.center = CGPointMake(topview.frame.size.width / 2, topview.frame.size.height / 2 + 10);
        [topview addSubview:toptitle];
        
        back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.backgroundColor = [UIColor clearColor];
        back.frame = CGRectMake(frame.size.width - 64, 0, 44, Top_Height);
        back.center = CGPointMake(back.center.x, topview.frame.size.height / 2 + 10);
//        back.imageEdgeInsets = UIEdgeInsetsMake(-35, 0, 0, 0);
//        [back setImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
        [back setTitle:@"完成" forState:UIControlStateNormal];
        [back setTitle:@"完成" forState:UIControlStateHighlighted];
        [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [back setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [topview addSubview:back];
        
        self.items = [NSMutableArray array];
        
        return self;
    }
    
    return nil;
}

- (void)setImages:(NSArray*)urls Filenames:(NSArray*)filenames
{
    PreSubScroll* scroll = nil;
    NSInteger cnt = 0;
    //UIImage* defimage = [UIImage imageNamed:@"cardefault"];
    
    for (NSString* url in urls)
    {
        scroll = [[PreSubScroll alloc] initWithFrame:CGRectMake(cnt * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [scrollView addSubview:scroll];
        [items addObject:scroll];
        
        __weak typeof(PreSubScroll*)blockscroll = scroll;
        [scroll.imageView setDataWithUrl:url IsLoadCache:YES CacheName:[[url componentsSeparatedByString:@"/"] lastObject] CallBack:^(UIImageView *view, NSError *error) {
            
            if (!error)
            {
                [blockscroll updateImage:view.image];
            }
            
        }];
//        [scroll.imageView setImageWithURL:[NSURL URLWithString:url relativeToURL:nil] placeholderImage:defimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            if (image)
//            {
//                [blockscroll updateImage:image];
//            }
//        }];

        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureClicked:)];
        [scroll addGestureRecognizer:gesture];
        
        ++cnt;
        
        scroll.tag = cnt;
    }
    
    curPage = [items firstObject];
    
    scrollView.contentSize = CGSizeMake(cnt * scrollView.frame.size.width, scrollView.frame.size.height);
    
    toptitle.text = [NSString stringWithFormat:@"%d/%ld", 1, (unsigned long)[items count]];
}

- (void)didGestureClicked:(UITapGestureRecognizer*)sender
{
    UIScrollView* scroll = (UIScrollView*)sender.view;
    
    if (scroll.zoomScale > 1.0) [scroll setZoomScale:1.0 animated:YES];
}

- (void)scrollToThePage:(NSInteger)pageno Animate:(BOOL)animate
{
    toptitle.text = [NSString stringWithFormat:@"%ld/%ld", pageno + 1, [items count]];
    
    [scrollView setContentOffset:CGPointMake(pageno * scrollView.frame.size.width, scrollView.contentOffset.y) animated:animate];
    
    if (!animate) [self updatePageTitle];
}

- (void)setImages:(NSArray*)images
{
    PreSubScroll* scroll = nil;
    NSInteger cnt = 0;

    for (UIImage* image in images)
    {
        scroll = [[PreSubScroll alloc] initWithFrame:CGRectMake(cnt * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        scroll.imageView.image = image;
        [scrollView addSubview:scroll];
        [items addObject:scroll];
        
        ++cnt;
    }
    
    scrollView.contentSize = CGSizeMake(cnt * scrollView.frame.size.width, scrollView.frame.size.height);
    
    toptitle.text = [NSString stringWithFormat:@"%d/%ld", 1, (unsigned long)[items count]];
}

- (void)updatePageTitle
{
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 1);
    
    toptitle.text = [NSString stringWithFormat:@"%ld/%ld", (long)page, (unsigned long)[items count]];
    
    if (curPage.tag != page)
    {
        [curPage setZoomScale:curPage.minimumZoomScale];
    }
    
    curPage = [items objectAtIndex:page - 1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageTitle];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageTitle];
}

@end
