//
//  UIViewController+AlertView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//
//  注意：只适用于8.0以上的版本
//

#import "UIViewController+AlertView.h"

@implementation UIViewController (AlertView)

- (void)showNormalAlertView:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)canceltitle
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _PHONE_8
    UIAlertController* alertctrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertctrl addAction:[UIAlertAction actionWithTitle:canceltitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    
    [self presentViewController:alertctrl animated:YES completion:^{
        //
    }];
#endif
}

- (void)showAlterView:(NSString*)title Message:(NSString*)message Actions:(NSArray*)actions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _PHONE_8
    UIAlertController* alertctrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction* action in actions)
    {
        [alertctrl addAction:action];
    }
    
    [self presentViewController:alertctrl animated:YES completion:^{
        //
    }];
#endif
}

@end
