//
//  DocPreviewCtrl.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLDocPreviewCtrl : UIViewController <UIWebViewDelegate>

- (instancetype)init:(BOOL)isshownavbar Path:(NSString*)path;

@end
