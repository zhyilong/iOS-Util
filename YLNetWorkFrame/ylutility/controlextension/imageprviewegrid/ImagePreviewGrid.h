//
//  ImagePreviewGrid.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/25.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePreviewCell.h"

@class ImagePreviewGrid;

typedef NS_ENUM(NSUInteger, ImgGridOpType)
{
    ImgGridOp_Add,
    ImgGridOp_Remove,
    ImgGridOp_Edit,
    ImgGridOp_Cover,
    ImgGridOp_Unkonw,
};

@protocol ImagePreviewGridDelegate <NSObject>

@optional
///0 - 删除
- (void)imagePreviewGrid:(ImagePreviewGrid*)view SelectedCell:(ImagePreviewCell*)cell OpType:(ImgGridOpType)optype;
- (void)imagePreviewGrid:(ImagePreviewGrid*)view ProCover:(ImagePreviewItem*)procover CurCover:(ImagePreviewItem*)curcover;

@end

@interface ImagePreviewGrid : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    CGSize              itemSize;
}

@property(nonatomic, weak) id<ImagePreviewGridDelegate>  delegate;
///最大数量
@property(nonatomic, assign) NSInteger              maxItemNum;
///最小显示数量（例如：显示3，则赋值为3-1，应为有添加站位）
@property(nonatomic, assign) NSInteger              minItemNum;
///是否可以继续添加
@property(nonatomic, assign) BOOL                   isCanAdd;
///是否可编辑，是否修改图片
@property(nonatomic, assign) BOOL                   isCanEdit;
///是否封面设置
@property(nonatomic, assign) BOOL                   isCanSetCover;
///封面图片
@property(nonatomic, strong) UIImage*               coverImage;
///项的边距
@property(nonatomic, assign) UIEdgeInsets           itemEdgeInsets;
///项显示大小
@property(nonatomic, assign) CGSize                 itemSize;

- (instancetype)initWithFrame:(CGRect)frame ItemSize:(CGSize)itemsize DefImage:(UIImage*)defimage DefDelImage:(UIImage*)defdelimage;
- (ImagePreviewItem*)addItem:(UIImage*)image DelImage:(UIImage*)delimage IsReload:(BOOL)isreload;
- (void)updateCurCell:(UIImage*)image;
- (void)removeItem:(NSInteger)index;
- (NSArray<ImagePreviewItem*>*)getItems;
- (NSArray<ImagePreviewItem*>*)getValidItems;
- (ImagePreviewCell*)selectedCell;
- (void)reload;
- (void)addEnabled:(BOOL)enabled IsReload:(BOOL)isreload;
- (CGSize)contentSize;
- (void)updateContentSize:(CGSize)size;
- (ImgGridOpType)operateType;
- (void)setMinItemNum:(NSInteger)minitemnum DefImage:(UIImage*)image DelImage:(UIImage*)delimage;
- (ImagePreviewItem*)coverItem;
- (NSMutableArray*)dataSource;
- (void)updateCell:(ImagePreviewCell*)cell Image:(UIImage*)image;
- (void)isCanScrollContentView:(BOOL)iscan;

@end
