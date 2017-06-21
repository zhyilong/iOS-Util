//
//  YLDropDownList.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLDropDownList.h"

@implementation YLDropDownList

@synthesize nodeManager;
@synthesize yldelegate;
@synthesize isCloseNodes;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    
    if (self)
    {
        nodeManager = [[DropDownNodeManager alloc] init];
        yldelegate  = nil;
        isCloseNodes = YES;
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"yldoplstcell"];
        self.delegate   = self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)loadRootNode:(DropDownNode*)node
{
    node.isOpened = YES;
    
    nodeManager.rootNode  = node;
    [nodeManager.showNodes removeAllObjects];
    
    [self initShowNodes:node];
    
    [self reloadData];
}

- (BOOL)initShowNodes:(DropDownNode*)node
{
    if (node.isOpened)
    {
        if (nodeManager.rootNode != node) [nodeManager.showNodes addObject:node];

        for (DropDownNode* child in node.children)
        {
            if (child.isOpened) [self initShowNodes:child];
            else [nodeManager.showNodes addObject:child];
        }
        
        return YES;
    }
    
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nodeManager.showNodes count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"yldoplstcell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownNode* node = [nodeManager.showNodes objectAtIndex:indexPath.row];
    
    node.indexInList = indexPath.row;
    
    if ([node.iconName length] > 0) cell.imageView.image = [UIImage imageNamed:node.iconName];
    else cell.imageView.image = nil;
    
    cell.textLabel.font = node.font;
    cell.textLabel.text = node.title;
    
    if (node.isSelected) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownNode* newnode = [nodeManager.showNodes objectAtIndex:indexPath.row];
    
    [newnode updateNodeSelected:!newnode.isSelected Node:newnode];
    
    if (!newnode.isOpened)
    {
        nodeManager.selectedNode = newnode;
        newnode.indexInList = indexPath.row;

        //关闭上次展开
        /*if (![oldnode isMyChild:newnode])
        {
            if (oldnode.indexInList < indexPath.row) newnode.indexInList = indexPath.row - [oldnode.children count];
            
            [self closeChildren:oldnode IndexPath:[NSIndexPath indexPathForRow:oldnode.indexInList inSection:0]];
        }*/
        
        //展开下一级
        [self openChildren:newnode IndexPath:[NSIndexPath indexPathForRow:newnode.indexInList inSection:0]];
        
        //回调
        if ([yldelegate respondsToSelector:@selector(ylDropDownList:SelectedNode:)])
        {
            [yldelegate ylDropDownList:self SelectedNode:nodeManager.selectedNode];
        }
    }
    else
    {
        if (isCloseNodes) [self closeChildren:newnode IndexPath:indexPath];
    }
    
    [tableView reloadData];
}

- (void)openChildren:(DropDownNode*)parent IndexPath:(NSIndexPath*)indexpath
{
    if (parent)
    {
        if ([parent.children count] > 0)
        {
            parent.isOpened = YES;
            
            [nodeManager.showNodes insertObjects:parent.children atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexpath.row + 1, [parent.children count])]];
            
            [self beginUpdates];
            
            NSMutableArray* indexPathes = [NSMutableArray array];
            NSInteger index = indexpath.row + 1;
            NSInteger cnt = [parent.children count];
            for (NSInteger i=0; i<cnt; i++)
            {
                [indexPathes addObject:[NSIndexPath indexPathForRow:index++ inSection:0]];
            }
            [self insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationMiddle];
            
            [self endUpdates];
        }
    }
}

- (void)closeChildren:(DropDownNode*)parent  IndexPath:(NSIndexPath*)indexpath
{
    if (parent)
    {
        if ([parent.children count] > 0)
        {
            NSInteger increase = 0;
            DropDownNode* child = parent;
            increase = [self getOpenChildCnt:child];
            
            [nodeManager.showNodes removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexpath.row + 1, increase)]];
            
            [self beginUpdates];
            
            NSMutableArray* indexPathes = [NSMutableArray array];
            NSInteger index = indexpath.row + 1;
            for (NSInteger i=0; i<increase; i++)
            {
                [indexPathes addObject:[NSIndexPath indexPathForRow:index++ inSection:0]];
            }
            [self deleteRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationMiddle];
            
            [self endUpdates];
        }
    }
}

- (NSInteger)getOpenChildCnt:(DropDownNode*)node
{
    NSInteger cnt = 0;
    
    if (node.isOpened)
    {
        node.isOpened = NO;
        
        cnt += [node.children count];
        for (DropDownNode* child in node.children)
        {
            cnt += [self getOpenChildCnt:child];
        }
    }
    
    return cnt;
}

@end
