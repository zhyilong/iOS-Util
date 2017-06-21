//
//  ZoomImgCtrl.h
//  scrollzoom
//
//  Created by zhangyilong on 15/3/29.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLZoomImgCtrl;

@protocol YLZoomImgDelegate <NSObject>

@optional
- (void)didYLZoomImgSelected:(YLZoomImgCtrl*)ctrl Image:(UIImage*)image;

@end

/**
 图片裁剪
 */

@interface YLZoomImgCtrl : UIViewController <UIScrollViewDelegate>
{
    UIScrollView*     m_Scroll;
    UIImageView*      m_ImageView;
    UIView*           m_CutFrame;
    CGSize            m_Size;
    CGFloat           m_Increase;
}

@property(nonatomic, assign) id<YLZoomImgDelegate>          delegate;

- (instancetype)initWithImage:(UIImage*)image ClipSize:(CGSize)clipsize;

@end
