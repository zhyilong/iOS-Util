//
//  YLImageEditView.h
//  YLAppUtility
//
//  Created by yilong zhang on 2016/12/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLImageEditView;

@protocol YLImageEditViewDelegate <NSObject>

//image为nil是取消处理
- (void)ylimageEditView:(YLImageEditView*)view DidCropImage:(UIImage*)image;

@end

@interface YLImageEditView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) UIImage*                       image;
@property(nonatomic, weak)   id<YLImageEditViewDelegate>    delegate;

- (instancetype)initWithFrame:(CGRect)frame CropSize:(CGSize)cropsize;
- (void)setMinScale:(CGFloat)scale;
- (void)setMaxScale:(CGFloat)scale;

@end
