//
//  ImagePreviewCell.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/25.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ImagePreviewCell.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+YLNetWorkFrame.h"

@implementation ImagePreviewItem

@synthesize isNew;
@synthesize isCover;
@synthesize image;
@synthesize delImage;
@synthesize imagePath;
@synthesize isLoadFromNet;
@synthesize usrData;

- (instancetype)init
{
    if (self = [super init])
    {
        image = nil;
        delImage = nil;
        imagePath = nil;
        isNew = YES;
        isLoadFromNet = NO;
        isCover = NO;
        
        return self;
    }
    
    return nil;
}

@end

@implementation ImagePreviewCell
{
    UIView* rootView;
}

@synthesize data;

@synthesize imgView;
@synthesize coverView;
@synthesize delBtn;
@synthesize coverBtn;
@synthesize title;

@synthesize edgeInsets;

- (void)dealloc
{
    //if (data.isLoadFromNet) [imgView cancelCurrentImageLoad];
    if (data.isLoadFromNet) [imgView cancelDownload];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        data = nil;
        edgeInsets = UIEdgeInsetsZero;
        
        rootView = [[UIView alloc] initWithFrame:self.bounds];
        rootView.backgroundColor = [UIColor whiteColor];
        [self addSubview:rootView];
        
        coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        coverBtn.backgroundColor = [UIColor clearColor];
        coverBtn.frame = CGRectMake(0, 0, imgView.frame.size.width, 32);
        coverBtn.hidden = YES;
        coverBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:coverBtn];
        
        [coverBtn setTitle:@"设置封面" forState:UIControlStateNormal];
        [coverBtn setTitle:@"设置封面" forState:UIControlStateHighlighted];
        [coverBtn setTitle:@"设置封面" forState:UIControlStateSelected];
        
        [coverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [coverBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [coverBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];

        imgView = [[UIImageView alloc] initWithFrame:rootView.bounds];
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [rootView addSubview:imgView];
        
        NSDictionary* views = @{@"imgView":imgView};
        NSArray* contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imgView]-0-|" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imgView]-0-|" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.backgroundColor = [UIColor clearColor];
        delBtn.frame = CGRectMake(CGRectGetMaxX(imgView.frame) - 25, imgView.frame.origin.y, 25, 25);
        delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 8, 0);
        delBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [rootView addSubview:delBtn];
        
        views = @{@"delBtn":delBtn};
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[delBtn(25)]-0-|" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[delBtn(25)]" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];

        title = [[UILabel alloc] initWithFrame:imgView.frame];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor blackColor];
        title.numberOfLines = 0;
        title.translatesAutoresizingMaskIntoConstraints = NO;
        [rootView addSubview:title];
        
        views = @{@"title":title};
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[title]-0-|" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[title]-0-|" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        coverView.backgroundColor = [UIColor clearColor];
        coverView.translatesAutoresizingMaskIntoConstraints = NO;
        [rootView addSubview:coverView];
        
        views = @{@"coverView":coverView};
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[coverView(30)]" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];
        
        contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[coverView(30)]" options:0 metrics:nil views:views];
        [rootView addConstraints:contraints];

        return self;
    }
    
    return nil;
}

- (void)showSetCoverButton:(BOOL)isshow Height:(CGFloat)height
{
    coverBtn.hidden = !isshow;
    coverBtn.frame = CGRectMake(0, 0, coverBtn.frame.size.width, height);
    
    [self layoutSubViewsPosition];
}

- (void)layoutSubviews
{
    [self layoutSubViewsPosition];
}

- (void)layoutSubViewsPosition
{
    if (coverBtn.hidden)
    {
        rootView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.frame.size.width - edgeInsets.left - edgeInsets.right, self.frame.size.height - edgeInsets.top - edgeInsets.bottom);
    }
    else
    {
        rootView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.frame.size.width - edgeInsets.left - edgeInsets.right, self.frame.size.height - edgeInsets.top - coverBtn.frame.size.height - edgeInsets.bottom);
        coverBtn.frame = CGRectMake(rootView.frame.origin.x, CGRectGetMaxY(rootView.frame) + edgeInsets.bottom, rootView.frame.size.width, coverBtn.frame.size.height);
    }
}

- (void)updateImage:(UIImage*)image
{
    data.isNew = NO;
    
    imgView.image = image;
    data.image = image;
}

@end
