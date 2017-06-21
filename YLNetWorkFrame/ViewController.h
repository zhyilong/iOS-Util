//
//  ViewController.h
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLRefresh+UIScrollView.h"
#import "ImagePreviewGrid.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, YLTableTopLoaderDelegate, YLTableBottomLoaderDeleate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePreviewGridDelegate>

@property(nonatomic, weak) IBOutlet UITableView*    tableView;

- (IBAction)OnBTNTextFieldDown:(UITextField*)textField;

@end

