//
//  YLSearchBar.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/21.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLSearchBar;

@protocol YLSearchBarDelegate <NSObject>

@optional
- (void)ylsearchBarSelected:(YLSearchBar*)bar Text:(NSString*)text;

@end

@interface YLSearchBar : UIView <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UIView*                 backView;
@property(nonatomic, weak) IBOutlet UITextField*            textField;
@property(nonatomic, weak) IBOutlet UIImageView*            icon;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint*     iconContraint;

@property(nonatomic, weak) id<YLSearchBarDelegate>          delegate;

+ (YLSearchBar*)createYLSearchBar:(UIImage*)image;

- (NSString*)text;
- (void)setText:(NSString*)text;

@end
