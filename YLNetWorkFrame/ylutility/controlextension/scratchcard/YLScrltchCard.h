//
//  YLScrltchCard.h
//  YLAppUtility
//
//  Created by yilong zhang on 2017/3/30.
//  Copyright © 2017年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLScrltchCard : UIView

- (instancetype)initWithFrame:(CGRect)frame SurfaceText:(NSString*)surface AwardText:(NSString*)Award;
- (instancetype)initWithFrame:(CGRect)frame Surface:(UIImage*)surface Award:(UIImage*)award;
- (void)reset;

@end
