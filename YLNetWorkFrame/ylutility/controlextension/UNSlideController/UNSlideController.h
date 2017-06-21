//
//  UNSlideController.h
//  UNSlideController
//
//  Created by zhangyilong on 16/1/13.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNSlideController : UIViewController <UIGestureRecognizerDelegate>

///左侧
@property(nonatomic, strong) UIViewController*      menuController;
///主视图
@property(nonatomic, strong) UIViewController*      homeController;

///右侧边界水平中心位置
@property(nonatomic, assign) float      rightBoundry;
///最小缩放最大1,默认0.9
@property(nonatomic, assign) float      minScale;

- (instancetype)initWithController:(UIViewController*)homecontroller MenuController:(UIViewController*)menucontroller;

@end
