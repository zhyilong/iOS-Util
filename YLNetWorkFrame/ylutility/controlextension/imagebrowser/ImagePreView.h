//
//  ImagePreView.h
//  SchoolBadge_teacher
//
//  Created by zhangyilong on 15/8/7.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Top_Height  64


@interface PreSubScroll : UIScrollView <UIScrollViewDelegate>

@property(nonatomic, strong) UIImageView*      imageView;

- (void)updateImage:(UIImage*)image;

@end




@interface ImagePreView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView*          scrollView;

@property(nonatomic, strong) NSMutableArray*    items;
@property(nonatomic, strong) UIView*                   topview;
@property(nonatomic, strong) UILabel*                  toptitle;
@property(nonatomic, strong) UIButton*                back;

- (void)setImages:(NSArray*)urls Filenames:(NSArray*)filenames;
- (void)scrollToThePage:(NSInteger)pageno Animate:(BOOL)animate;
- (void)setImages:(NSArray*)images;

@end
