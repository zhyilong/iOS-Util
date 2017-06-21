//
//  TestDropDownList.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/6/24.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "TestDropDownList.h"

@implementation TestDropDownList

@synthesize dropList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dropList = [[YLDropDownList alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    dropList.yldelegate = self;
    dropList.isCloseNodes = NO;
    [self.view addSubview:dropList];
    
    NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[dplist]-8-|" options:0 metrics:nil views:@{@"dplist" : dropList}];
    [self.view addConstraints:constraint];
    
    constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[dplist]-0-|" options:0 metrics:nil views:@{@"dplist" : dropList}];
    [self.view addConstraints:constraint];
    
    //初始化数据
    DropDownNode* rootNode = [[DropDownNode alloc] init];
    
    for (NSInteger i=0; i<10; i++)
    {
        DropDownNode* node1 = [[DropDownNode alloc] init];
        node1.title = [NSString stringWithFormat:@"1 - %ld", (long)i];
        node1.font = [UIFont boldSystemFontOfSize:18];
        node1.isOpened = YES;
        node1.parent = rootNode;
        
        for (NSInteger j=0; j<3; j++)
        {
            DropDownNode* node2 = [[DropDownNode alloc] init];
            node2.title = [NSString stringWithFormat:@"\t\t%ld - %ld", (long)i, j];
            node2.font = [UIFont systemFontOfSize:16];
            node2.isOpened = YES;
            node2.parent = node1;
            
            for (NSInteger k=0; k<3; k++)
            {
                DropDownNode* node3 = [[DropDownNode alloc] init];
                node3.title = [NSString stringWithFormat:@"\t\t\t\t%ld - %ld - %ld", (long)i, j, k];
                node3.font = [UIFont systemFontOfSize:14];
                node3.parent = node2;
                [node2.children addObject:node3];
            }
            
            [node1.children addObject:node2];
        }
        
        [rootNode.children addObject:node1];
    }

    [dropList loadRootNode:rootNode];
}

//delegate of YLDropDownList
- (void)ylDropDownList:(YLDropDownList *)list SelectedNode:(DropDownNode *)selectednode
{
    NSLog(@"%@", selectednode.title);
}

@end
