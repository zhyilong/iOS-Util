//
//  RippleView.h
//  YLAppUtility
//
//  Created by yilong zhang on 2017/3/29.
//  Copyright © 2017年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLRippleView : UIView <CAAnimationDelegate>

- (instancetype)initWithFrame:(CGRect)frame Count:(NSInteger)count;

@end
