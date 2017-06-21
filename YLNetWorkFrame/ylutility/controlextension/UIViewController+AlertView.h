//
//  UIViewController+AlertView.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertView)

- (void)showNormalAlertView:(NSString*)title Message:(NSString*)message CancelTitle:(NSString*)canceltitle;
- (void)showAlterView:(NSString*)title Message:(NSString*)message Actions:(NSArray*)actions;

@end
