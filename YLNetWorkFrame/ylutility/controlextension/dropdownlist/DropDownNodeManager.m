//
//  DropDownNodeManager.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DropDownNodeManager.h"

@implementation DropDownNodeManager

@synthesize rootNode;
@synthesize showNodes;

@synthesize selectedNode;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        rootNode     = [[DropDownNode alloc] init];
        showNodes    = [NSMutableArray array];
        selectedNode = nil;
    }
    
    return self;
}

///add
- (void)insertNodesToParent:(DropDownNode*)parent Nodes:(NSArray<DropDownNode*>*)nodes
{
    if (parent && [nodes count] > 0)
    {
        //添加到尾部
        [parent.children addObjectsFromArray:nodes];
    }
}

- (void)insertNodesToParent:(DropDownNode *)parent Nodes:(NSArray<DropDownNode *> *)nodes AtIndex:(NSInteger)atindex
{
    if (parent && [nodes count] > 0)
    {
        //长度内某个位置
        if (atindex < [parent.children count])
        {
            [parent.children insertObjects:nodes atIndexes:[NSIndexSet indexSetWithIndex:atindex]];
        }
        //插入到尾部
        else
        {
            [self insertNodesToParent:parent Nodes:nodes];
        }
    }
}

///remove
- (void)deleteNodesFromParent:(DropDownNode *)parent
{
    if (parent)
    {
        [parent.children removeAllObjects];
    }
}

- (void)deleteNodesFromParent:(DropDownNode *)parent FromIndex:(NSInteger)fromindex Length:(NSInteger)length
{
    if (parent && length > 0)
    {
        NSInteger childCnt = [parent.children count] - 1;
        if (fromindex <= childCnt)
        {
            if ( (fromindex + length - 1) > childCnt) length = childCnt - fromindex + 1;
            
            [parent.children removeObjectsInRange:NSMakeRange(fromindex, length)];
        }
    }
}

- (void)deleteNodesFromParent:(DropDownNode*)parent Nodes:(NSArray<DropDownNode*>*)nodes
{
    if (parent && [nodes count] > 0)
    {
        [parent.children removeObjectsInArray:nodes];
    }
}

///query
- (DropDownNode*)getNodeFromParent:(DropDownNode*)parent AtIndex:(NSInteger)atindex
{
    if (parent)
    {
        if (atindex < [parent.children count]) return [parent.children objectAtIndex:atindex];
    }
    
    return nil;
}

@end
