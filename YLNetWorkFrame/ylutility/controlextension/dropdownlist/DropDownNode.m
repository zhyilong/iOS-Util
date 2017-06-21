//
//  DropDownNode.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DropDownNode.h"

@implementation DropDownNode

@synthesize indexInList;
@synthesize children;
@synthesize title;
@synthesize subTitle;
@synthesize iconName;
@synthesize isSelected;
@synthesize parent;
@synthesize font;
@synthesize height;
@synthesize isOpened;

@synthesize key;
@synthesize userData;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        indexInList = -1;
        children    = [NSMutableArray array];
        title       = nil;
        subTitle    = nil;
        iconName    = nil;
        font        = nil;
        parent      = nil;
        isSelected  = NO;
        height      = 44;
        isOpened    = NO;
        userData    = nil;
    }
    
    return self;
}

- (BOOL)isMyChild:(DropDownNode*)child
{
    DropDownNode* parentNode = child.parent;
    
    while (parentNode)
    {
        if (self == parentNode) return YES;
        parentNode = parentNode.parent;
    }

    return NO;
}

- (BOOL)isMyParent:(DropDownNode *)Parent
{
    if (Parent == self.parent) return YES;
    
    return NO;
}

- (DropDownNode*)findNodeWithKey:(NSString*)Key Node:(DropDownNode*)node
{
    DropDownNode* ret = nil;
    
    if (![node.key isEqualToString:Key])
    {
        for (DropDownNode* child in node.children)
        {
            if (!ret) ret = [self findNodeWithKey:Key Node:child];
            else break;
        }
    }
    else
    {
        ret = node;
    }

    return ret;
}

- (void)updateNodeSelected:(BOOL)isselected Node:(DropDownNode*)node
{
    [self setChildSelected:node State:isselected];
    
    [self setParentSelected:node State:isselected];
}

- (void)setChildSelected:(DropDownNode*)node State:(BOOL)state
{
    node.isSelected = state;
    
    for (DropDownNode* child in node.children)
    {
        [self setChildSelected:child State:state];
    }
}

- (void)setParentSelected:(DropDownNode*)node State:(BOOL)state
{
    NSInteger cnt = 0;
    DropDownNode* Parent = node.parent;
    
    if (Parent)
    {
        //子节点非选中，父节点选中取消
        if (!state)
        {
            Parent.isSelected = NO;
        }
        //子节点选中，父节点是否全选
        else
        {
            for (DropDownNode* child in Parent.children)
            {
                if (state == child.isSelected) cnt += 1;
            }
            
            if ([Parent.children count] == cnt) Parent.isSelected = YES;
            else Parent.isSelected = NO;
        }
        
        [self setParentSelected:Parent State:state];
    }
}

/*将其它节点转换到DropDownNode, 其它节点的结构必须满足{NSString* id; NSArray* children;}
//parent是跟节点，需要手动创建
- (void)convertToDropDownNode:(CodeBaseModel*)model Node:(DropDownNode*)parent
{
    parent.userData = model;
    parent.key = model.id;
    
    DropDownNode* node = nil;
    for (CodeBaseModel* child in model.childs)
    {
        node = [[DropDownNode alloc] init];
        node.parent = parent;
        [parent.children addObject:node];
        
        [self tesst:child Node:node];
    }
}
*/

@end
