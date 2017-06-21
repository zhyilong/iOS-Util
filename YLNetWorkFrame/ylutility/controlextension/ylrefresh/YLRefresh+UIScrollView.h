//
//  TableRefreshHeader.h
//  QQCar
//
//  Created by qqcy on 15/3/6.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLTableTopLoader;
@class YLTableBottomLoader;

/**
 *  @author zhangyilong, 16-04-07 15:04:20
 *
 *  加载状态
 */
typedef NS_ENUM(NSInteger) {
    /**
     *  @author zhangyilong, 16-04-07 15:04:20
     *
     *  空闲
     */
    YLTable_Loader_Free,
    /**
     *  @author zhangyilong, 16-04-07 15:04:20
     *
     *  将要加载
     */
    YLTable_Loader_Will,
    /**
     *  @author zhangyilong, 16-04-07 15:04:20
     *
     *  正在加载
     */
    YLTable_Loader_Runing,
    /**
     *  @author zhangyilong, 16-04-07 15:04:20
     *
     *  加载完成
     */
    YLTable_Loader_Finish,
}YLTableLoaderState;

/**
 *  @author zhangyilong, 16-04-07 15:04:46
 *
 *  scrollview加载状态
 */
typedef NS_ENUM(NSInteger) {
    /**
     *  @author zhangyilong, 16-04-07 15:04:46
     *
     *  空闲
     */
    YLTable_Load_Free,
    /**
     *  @author zhangyilong, 16-04-07 15:04:46
     *
     *  顶部加载
     */
    YLTable_Load_Top,
    /**
     *  @author zhangyilong, 16-04-07 15:04:46
     *
     *  底部加载
     */
    YLTable_Load_Bottom,
}YLTableLoadingState;

/**
 *  @author zhangyilong, 16-04-07 15:04:48
 *
 *
 */
@interface UIScrollView (YLLoader)

- (void)setTopLoader:(YLTableTopLoader*)loader;
- (YLTableTopLoader*)getTopLoader;

- (void)setBottomLoader:(YLTableBottomLoader*)loader;
- (YLTableBottomLoader*)getBottomLoader;

- (YLTableLoadingState)getLoadingState;
- (void)stopLoading;

@end

/**
 *  @author zhangyilong, 16-04-07 15:04:51
 *
 *  上拉视图
 */
@protocol YLTableTopLoaderDelegate <NSObject>

@required
- (NSString*)didYLTableTopLoaderTitleForState:(YLTableTopLoader*)loader State:(YLTableLoaderState)state;

@optional
- (void)didYLTableTopLoaderSelected:(YLTableTopLoader*)loader;
- (void)didYLTableTopLoaderDragingForState:(YLTableTopLoader*)loader State:(YLTableLoaderState)state ContentOffset:(CGPoint)contentoffset;
- (UIView*)didYLTableTopLoaderAccessoryView:(YLTableTopLoader*)loader State:(YLTableLoaderState)state;

@end

@interface YLTableTopLoader : UIView
{
    BOOL    isDraged;
}

@property(nonatomic, strong) UILabel*                           title;
@property(nonatomic, strong) UIActivityIndicatorView*           indicator;
@property(nonatomic, strong) UIView*                            accessory;

@property(nonatomic, weak)   id<YLTableTopLoaderDelegate>       delegate;
@property(nonatomic, assign) YLTableLoaderState                 state;

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll;
- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<YLTableTopLoaderDelegate>)delegatep;
- (void)stop;
- (void)free;

- (void)rotationView:(UIView*)view Animate:(BOOL)animate;

@end

/**
 *  @author zhangyilong, 16-04-07 15:04:16
 *
 *  下拉视图
 */
@protocol YLTableBottomLoaderDeleate <NSObject>

@required
- (NSString*)didYLTableBottomLoaderTitleForState:(YLTableBottomLoader*)loading State:(YLTableLoaderState)state;

@optional
- (void)didYLTableBottomLoaderSelected:(YLTableBottomLoader*)loader;
- (void)didYLTableBottomLoaderDragingForState:(YLTableBottomLoader*)loader State:(YLTableLoaderState)state ContentOffset:(CGPoint)contentoffset;
- (UIView*)didYLTableBottomLoaderAccessoryView:(YLTableBottomLoader*)loader State:(YLTableLoaderState)state;

@end

@interface YLTableBottomLoader: UIView
{
    BOOL    isDraged;
}

@property(nonatomic, strong) UILabel*                       title;
@property(nonatomic, strong) UIActivityIndicatorView*       indicator;
@property(nonatomic, strong) UIView*                        accessory;

@property(nonatomic, weak) id<YLTableBottomLoaderDeleate>   delegate;
@property(nonatomic, assign) YLTableLoaderState             state;
@property(nonatomic, readonly) CGFloat                      superHeight;

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll;
- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<YLTableTopLoaderDelegate>)delegate;
- (void)stop;
- (void)free;
- (void)isShow;

@end
