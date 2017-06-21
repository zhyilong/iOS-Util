//
//  DropDownNode.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DropDownNode;

@interface DropDownNode : NSObject

@property(nonatomic, assign) NSInteger          indexInList;
@property(nonatomic, strong) NSMutableArray*    children;
@property(nonatomic, strong) NSString*          title;
@property(nonatomic, strong) NSString*          subTitle;
@property(nonatomic, strong) NSString*          iconName;
@property(nonatomic, assign) BOOL               isSelected;
@property(nonatomic, weak)   DropDownNode*      parent;
@property(nonatomic, strong) UIFont*            font;
@property(nonatomic, assign) CGFloat            height;
@property(nonatomic, assign) BOOL               isOpened;

@property(nonatomic, strong) NSString*          key;
@property(nonatomic, strong) id                 userData;

- (BOOL)isMyChild:(DropDownNode*)child;
- (BOOL)isMyParent:(DropDownNode*)parent;
- (DropDownNode*)findNodeWithKey:(NSString*)Key Node:(DropDownNode*)node;
- (void)updateNodeSelected:(BOOL)isselected Node:(DropDownNode*)node;

@end
