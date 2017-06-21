//
//  YLDropDownList.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownNodeManager.h"

@class YLDropDownList;

@protocol YLDropDownListDelegate <NSObject>

@optional
- (void)ylDropDownList:(YLDropDownList*)list SelectedNode:(DropDownNode*)selectednode;

@end



@interface YLDropDownList : UITableView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) DropDownNodeManager*           nodeManager;
@property(nonatomic, weak)   id<YLDropDownListDelegate>     yldelegate;
@property(nonatomic, assign) BOOL                           isCloseNodes;

- (void)loadRootNode:(DropDownNode*)node;

@end
