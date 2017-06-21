//
//  DropDownNodeManager.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropDownNode.h"

@interface DropDownNodeManager : NSObject

@property(nonatomic, strong) DropDownNode*      rootNode;
@property(nonatomic, strong) NSMutableArray*    showNodes;

@property(nonatomic, weak)   DropDownNode*      selectedNode;

/**
 *  @author zhyilong, 16-06-24 09:06:04
 *
 *  add
 *
 *  @param parent
 *  @param nodes
 */
- (void)insertNodesToParent:(DropDownNode*)parent Nodes:(NSArray<DropDownNode*>*)nodes;
- (void)insertNodesToParent:(DropDownNode*)parent Nodes:(NSArray<DropDownNode*>*)nodes AtIndex:(NSInteger)atindex;

/**
 *  @author zhyilong, 16-06-24 09:06:14
 *
 *  remove
 */
- (void)deleteNodesFromParent:(DropDownNode*)parent;
- (void)deleteNodesFromParent:(DropDownNode*)parent FromIndex:(NSInteger)fromindex Length:(NSInteger)length;
- (void)deleteNodesFromParent:(DropDownNode*)parent Nodes:(NSArray<DropDownNode*>*)nodes;

/**
 *  @author zhyilong, 16-06-24 10:06:40
 *
 *  query
 */
- (DropDownNode*)getNodeFromParent:(DropDownNode*)parent AtIndex:(NSInteger)atindex;

@end
