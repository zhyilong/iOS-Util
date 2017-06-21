//
//  ImagePreviewCell.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/25.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewItem : NSObject

///是否已经设置了用户图片
@property(nonatomic, assign) BOOL       isNew;
///是否是封面项
@property(nonatomic, assign) BOOL       isCover;
///在列表中的索引
@property(nonatomic, assign) NSInteger  index;
///是否从网络加载图片
@property(nonatomic, assign) BOOL       isLoadFromNet;
///图片
@property(nonatomic, strong) UIImage*   image;
///删除按钮图片
@property(nonatomic, strong) UIImage*   delImage;
///图片的路径（本地或者网络）
@property(nonatomic, strong) NSString*  imagePath;
///用户数据
@property(nonatomic, strong) id         usrData;

@end

@interface ImagePreviewCell : UICollectionViewCell

///选项数据源
@property(nonatomic, weak) ImagePreviewItem*  data;
///显示图片
@property(nonatomic, strong) UIImageView*     imgView;
///封面图片
@property(nonatomic, strong) UIImageView*     coverView;
///删除
@property(nonatomic, strong) UIButton*        delBtn;
///设置封面
@property(nonatomic, strong) UIButton*        coverBtn;
///标题
@property(nonatomic, strong) UILabel*         title;
///图片边距
@property(nonatomic, assign) UIEdgeInsets     edgeInsets;

- (void)updateImage:(UIImage*)image;
- (void)showSetCoverButton:(BOOL)isshow Height:(CGFloat)height;

@end
