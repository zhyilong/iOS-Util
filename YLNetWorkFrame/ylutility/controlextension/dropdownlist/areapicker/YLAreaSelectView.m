//
//  YLAreaPickerView.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/7/29.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "YLAreaSelectView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSString+Utility.h"

@implementation YLAreaModel

+ (id)list_class
{
    return [YLAreaModel class];
}

+ (id)Root_class
{
    return [YLAreaModel class];
}

@end


@implementation YLAreaSelectView
{
    DropDownNode*   rootNode;
    DropDownNode*   curNode;
    DropDownNode*   selNode;
    
    NSMutableArray* sectionTitles;
    NSInteger       showLevel;
    NSInteger       pickerComs;
    UIButton*       proBtn;
    UIView*         shadow;
    UIView*         pickerPanel;
}

static NSMutableArray* areas = nil;

@synthesize titleLb;
@synthesize tableView;
@synthesize pickerView;
@synthesize style;

@synthesize callback;
@synthesize delegate;
@synthesize topName;

- (void)dealloc
{
    self.callback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame JsonFile:(NSString*)jsonfile Style:(YLAreaSelectViewStyle)Style
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        style = Style;
        showLevel = 0;
        
        [self initData:jsonfile];
        
        shadow = [[UIView alloc] initWithFrame:self.bounds];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0.5;
        shadow.hidden = YES;
        [self addSubview:shadow];
        
        UITapGestureRecognizer* tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didShadowDown:)];
        [shadow addGestureRecognizer:tapgesture];
        
        CGFloat height = 260;//self.frame.size.height * 0.4;
        pickerPanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, height)];
        pickerPanel.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerPanel];
        
        UIView* topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        topview.tag = 34;
        topview.backgroundColor = [UIColor whiteColor];
        [pickerPanel addSubview:topview];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, topview.frame.size.height - 0.5, topview.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [topview addSubview:line];
        
        if (YLAreaView_TableView == style)
        {
            [self initTable];
        }
        else if (YLAreaView_Picker == style)
        {
            [self initPicker];
        }
        else ;
    }
    
    return self;
}

- (void)initTable
{
    UIView* topview = [pickerPanel viewWithTag:34];
    
    proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [proBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [proBtn setTitle:@"上一步" forState:UIControlStateHighlighted];
    [proBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [proBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    proBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [proBtn addTarget:self action:@selector(OnProDown:) forControlEvents:UIControlEventTouchUpInside];
    proBtn.frame = CGRectMake(8, 0, 60, topview.frame.size.height);
    [topview addSubview:proBtn];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(OnOkDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(topview.frame.size.width - 45 - 8, 0, 45, topview.frame.size.height);
    [topview addSubview:btn];
    
    titleLb = [[YLScrollLabel alloc] initWithFrame:CGRectMake(8, 0, btn.frame.origin.x - 16, topview.frame.size.height) Font:[UIFont systemFontOfSize:15]];
    titleLb.backgroundColor = topview.backgroundColor;
    titleLb.textColor = [UIColor whiteColor];
    [topview addSubview:titleLb];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topview.frame.origin.y + topview.frame.size.height, pickerPanel.frame.size.width, pickerPanel.frame.size.height - topview.frame.size.height)];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"areacell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [pickerPanel addSubview:tableView];
}

- (void)initPicker
{
    UIView* topview = [pickerPanel viewWithTag:34];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnOkDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(topview.frame.size.width - 45 - 8, 0, 45, topview.frame.size.height);
    [topview addSubview:btn];
    
    titleLb = [[YLScrollLabel alloc] initWithFrame:CGRectMake(btn.frame.size.width + 8, 0, topview.frame.size.width - 2 * (btn.frame.size.width + 8), topview.frame.size.height - 1) Font:[UIFont systemFontOfSize:16]];
    titleLb.textColor = [UIColor blackColor];
    titleLb.backgroundColor = topview.backgroundColor;
    [topview addSubview:titleLb];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topview.frame.size.height, pickerPanel.frame.size.width, pickerPanel.frame.size.height - topview.frame.size.height)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerPanel addSubview:pickerView];
}

- (void)initData:(NSString*)jsonfile
{
    rootNode = [[DropDownNode alloc] init];
    
    if (nil == areas)
    {
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil];
        NSString *json = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        NSArray* dic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        areas = [NSMutableArray array];
        YLAreaModel* model = nil;
        for (NSDictionary* info in dic)
        {
            model = [[YLAreaModel alloc] initWithDictionary:info];
            [areas addObject:model];
        }
    }
}

- (void)convertToDropDownNode:(NSArray*)models Node:(DropDownNode*)parent
{
    DropDownNode* node = nil;
    for (YLAreaModel* child in models)
    {
        node = [[DropDownNode alloc] init];
        
        node.userData = child;
        node.parent = parent;
        node.title = child.name;
        node.key = child.id;
        
        [parent.children addObject:node];
        
        [self convertToDropDownNode:child.list Node:node];
    }
}

- (NSArray*)sort:(NSArray*)array
{
    if ([array count] > 0)
    {
        return [array sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(DropDownNode*  _Nonnull obj1, DropDownNode*  _Nonnull obj2) {
            
            YLAreaModel* m1 = obj1.userData;
            YLAreaModel* m2 = obj2.userData;
            
            char c1 = [[m1.name HanCharacter2Pinyin:NO] characterAtIndex:0];
            char c2 = [[m2.name HanCharacter2Pinyin:NO] characterAtIndex:0];
            
            if (c1 > c2) return NSOrderedDescending;
            else if (c1 < c2) return NSOrderedAscending;
            else return NSOrderedSame;
            
        }];
    }
    
    return nil;
}

- (void)initSections
{
    sectionTitles = [NSMutableArray array];
    NSMutableArray* children = [NSMutableArray array];
    
    char t = '%';
    NSInteger cnt = 0;
    DropDownNode* cnode = nil;
    for (DropDownNode* node in rootNode.children)
    {
        char c = [[node.title HanCharacter2Pinyin:NO] characterAtIndex:0];
        
        if (t != c)
        {
            cnt = 0;
            t = c;
            [sectionTitles addObject:[[NSString alloc] initWithFormat:@"%c", c]];
            cnode = [[DropDownNode alloc] init];
            cnode.title = [[NSString alloc] initWithFormat:@"%c", c];
            cnode.key = @"&";
            [children addObject:cnode];
        }
        
        [cnode.children addObject:node];
    }
    
    rootNode.children = children;
    curNode = rootNode;
    selNode = [rootNode.children firstObject];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (0 == showLevel) return sectionTitles;
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    if (0 == showLevel) sections = [sectionTitles count];
    
    return sections;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = nil;
    if (0 == showLevel) title = [sectionTitles objectAtIndex:section];
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [curNode.children count];
    if (0 == showLevel) rows = [((DropDownNode*)[rootNode.children objectAtIndex:section]).children count];
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownNode* node = [curNode.children objectAtIndex:indexPath.row];
    CGFloat height = 40;
    
    if ([node.key isEqualToString:@"$"]) height = 25;
        
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableview dequeueReusableCellWithIdentifier:@"areacell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownNode* node = nil;
    
    if (0 == showLevel)
    {
        node = (DropDownNode*)[rootNode.children objectAtIndex:indexPath.section];
        node = [node.children objectAtIndex:indexPath.row];
    }
    else
    {
        node = [curNode.children objectAtIndex:indexPath.row];
    }
    
    if ([node.key isEqualToString:@"$"])
    {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (selNode == node) cell.backgroundColor = [UIColor lightGrayColor];
    else cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.text = node.title;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownNode* node = nil;
    
    if (0 == showLevel)
    {
        showLevel = 1;
        
        node = (DropDownNode*)[rootNode.children objectAtIndex:indexPath.section];
        node = [node.children objectAtIndex:indexPath.row];
        
        [self showProBtn];
    }
    else
    {
        node = [curNode.children objectAtIndex:indexPath.row];
    }
    
    if ([node.children count] > 0) curNode = node;
    selNode = node;
    
    if (![selNode.key isEqualToString:@"&"]) [self setTitle];
    
    if ([curNode.children count] > 0)
    {
        [tableview setContentOffset:CGPointZero];
        [tableview reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableview sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableview setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerComs;
}

- (NSInteger)pickerView:(UIPickerView *)pickerview numberOfRowsInComponent:(NSInteger)component
{
    NSInteger cnt = 0;
    DropDownNode* node = nil;
    
    if (0 == component)
    {
        node = rootNode;
        cnt = [node.children count];
    }
    else if (1 == component)
    {
        node = rootNode;
        cnt = [pickerview selectedRowInComponent:0];
        node = [node.children objectAtIndex:cnt];
        cnt = [node.children count];
    }
    else if (2 == component)
    {
        node = rootNode;
        cnt = [pickerview selectedRowInComponent:0];
        node = [rootNode.children objectAtIndex:cnt];
        cnt = [pickerview selectedRowInComponent:1];
        node = [node.children objectAtIndex:cnt];
        cnt = [node.children count];
        
    }
    else ;
    
    return cnt;
}

- (NSString*)pickerView:(UIPickerView *)pickerview titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger cnt = 0;
    NSString* title = nil;
    DropDownNode* node = nil;
    
    if (0 == component)
    {
        node = rootNode;
        node = [node.children objectAtIndex:row];
        title = node.title;
    }
    else if (1 == component)
    {
        node = rootNode;
        cnt = [pickerview selectedRowInComponent:0];
        if (cnt < [node.children count])
        {
            node = [node.children objectAtIndex:cnt];
            if (row < [node.children count])
            {
                node = [node.children objectAtIndex:row];
                title = node.title;
            }
        }
    }
    else if (2 == component)
    {
        node = rootNode;
        cnt = [pickerview selectedRowInComponent:0];
        if (cnt < [node.children count])
        {
            node = [rootNode.children objectAtIndex:cnt];
            cnt = [pickerview selectedRowInComponent:1];
            if (cnt < [node.children count])
            {
                node = [node.children objectAtIndex:cnt];
                if (row < [node.children count])
                {
                    node = [node.children objectAtIndex:row];
                    title = node.title;
                }
            }
        }
    }
    else ;
    
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerview widthForComponent:(NSInteger)component
{
    return pickerview.frame.size.width / pickerComs;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerview didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        [pickerview reloadComponent:1];
        [pickerview reloadComponent:2];
    }
    else if (1 == component)
    {
        [pickerview reloadComponent:2];
    }
    else
    {
        DropDownNode* node = rootNode;
        NSInteger cnt = [pickerview selectedRowInComponent:0];
        if (cnt < [node.children count])
        {
            node = [rootNode.children objectAtIndex:cnt];
            cnt = [pickerview selectedRowInComponent:1];
            if (cnt < [node.children count])
            {
                node = [node.children objectAtIndex:cnt];
                if (row < [node.children count])
                {
                    node = [node.children objectAtIndex:row];
                }
            }
        }
    }
}

- (void)OnProDown:(UIButton*)sender
{
    if (curNode != selNode)
    {
        selNode = selNode.parent;
    }
    
    //设置上一级节点
    NSInteger row = -1;
    NSInteger section = -1;
    BOOL bret = NO;
    if (rootNode == selNode.parent)
    {
        showLevel = 0;
        
        curNode = rootNode;
        for (DropDownNode* sec in curNode.children)
        {
            section += 1;
            row = -1;
            bret = NO;
            for (DropDownNode* child in sec.children)
            {
                row += 1;
                if ([child.title isEqualToString:selNode.title])
                {
                    bret = YES;
                    break;
                }
            }
            
            if (bret) break;
        }
        
        [self hiddeProBtn];
    }
    else
    {
        curNode = curNode.parent;
        
        section = 0;
        for (DropDownNode* child in curNode.children)
        {
            row += 1;
            if ([child.title isEqualToString:selNode.title]) break;
        }
    }

    [self setTitle];
    
    [tableView setContentOffset:CGPointZero];
    [tableView reloadData];
    
    if (section >= 0  && row >= 0)
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)OnOkDown:(UIButton*)sender
{
    NSMutableArray* array = nil;
    NSMutableArray* names = nil;
    
    if (YLAreaView_TableView == style)
    {
        array = [self getSelNode];
        names = [NSMutableArray array];
        
        for (YLAreaModel* model in array)
        {
            [names addObject:model.name];
        }
        
        SEL sel = @selector(ylareaSelectView:Areas:Name:);
        if ([delegate respondsToSelector:sel])
        {
            [delegate ylareaSelectView:self Areas:array Name:[names componentsJoinedByString:@"->"]];
        }
        
        if (callback) callback(self, array, [names componentsJoinedByString:@"->"]);
    }
    else
    {
        NSInteger cnt = -1;
        DropDownNode* node = rootNode;
        array = [NSMutableArray array];
        names = [NSMutableArray array];
        cnt = [pickerView selectedRowInComponent:0];
        if (cnt >= 0 && [node.children count] > 0)
        {
            node = [node.children objectAtIndex:cnt];
            [names addObject:((YLAreaModel*)node.userData).name];
            [array addObject:node.userData];
            
            cnt = [pickerView selectedRowInComponent:1];
            if (cnt >= 0 && [node.children count] > 0)
            {
                node = [node.children objectAtIndex:cnt];
                [names addObject:((YLAreaModel*)node.userData).name];
                [array addObject:node.userData];
                
                cnt = [pickerView selectedRowInComponent:2];
                if (cnt >= 0 && [node.children count] > 0)
                {
                    node = [node.children objectAtIndex:cnt];
                    [names addObject:((YLAreaModel*)node.userData).name];
                    [array addObject:node.userData];
                }
            }
        }
    }
    
    SEL sel = @selector(ylareaSelectView:Areas:Name:);
    if ([delegate respondsToSelector:sel])
    {
        [delegate ylareaSelectView:self Areas:array Name:[names componentsJoinedByString:@"->"]];
    }
    
    if (callback) callback(self, array, [names componentsJoinedByString:@"->"]);
    
    NSLog(@"%@", names);
    
    [self closeYLAreaPicker];
}

- (void)showProBtn
{
    [UIView beginAnimations:nil context:nil];
    titleLb.frame = CGRectMake(proBtn.frame.origin.x + proBtn.frame.size.width + 8, 0, titleLb.frame.size.width - proBtn.frame.size.width - 8, titleLb.frame.size.height);
    [UIView commitAnimations];
}

- (void)hiddeProBtn
{
    [UIView beginAnimations:nil context:nil];
    titleLb.frame = CGRectMake(8, 0, titleLb.frame.size.width + proBtn.frame.size.width + 8, titleLb.frame.size.height);
    [UIView commitAnimations];
}

- (void)setTitle
{
    DropDownNode* node = selNode;
    NSMutableArray* name = [NSMutableArray array];
    
    while (node.title)
    {
        [name insertObject:node.title atIndex:0];
        
        node = node.parent;
    }

    [titleLb setTitle:[name componentsJoinedByString:@"->"] Animate:YES];
}

- (NSMutableArray*)getSelNode
{
    DropDownNode* node = selNode;
    NSMutableArray* sels = [NSMutableArray array];
    
    while (node.title)
    {
        if (node.userData) [sels insertObject:node.userData atIndex:0];
        
        node = node.parent;
    }
    
    return sels;
}

- (void)setTopNode:(NSString*)iD
{
    //字母
    for (DropDownNode* node in rootNode.children)
    {
        //省一级
        for (DropDownNode* child in node.children)
        {
            if ([((YLAreaModel*)child.userData).name isEqualToString:iD])
            {
                [sectionTitles insertObject:[[NSString alloc] initWithFormat:@"%c", '#'] atIndex:0];
                DropDownNode* cnode = [[DropDownNode alloc] init];
                cnode.title = [[NSString alloc] initWithFormat:@"%c", '#'];
                cnode.key = @"&";
                NSMutableArray* children = [NSMutableArray arrayWithObjects:child, nil];
                cnode.children = children;
                
                [rootNode.children insertObject:cnode atIndex:0];
                
                curNode = rootNode;
                selNode = [rootNode.children firstObject];
                showLevel = 0;
                [tableView setContentOffset:CGPointZero];
                [tableView reloadData];
                
                return;
            }
        }
    }
}

- (void)didShadowDown:(UIGestureRecognizer*)sender
{
    [self closeYLAreaPicker];
}

- (void)showYLAreaPicker
{
    shadow.hidden = NO;
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tag = 44;
    if (YLAreaView_TableView == style)
    {
        indicator.center = CGPointMake(tableView.frame.size.width / 2, tableView.frame.size.height / 2);
        [tableView addSubview:indicator];
    }
    else if (YLAreaView_Picker == style)
    {
        indicator.center = CGPointMake(pickerView.frame.size.width / 2, pickerView.frame.size.height / 2);
        [pickerView addSubview:indicator];
    }
    else return;
    [indicator startAnimating];
    
    [UIView beginAnimations:nil context:nil];
    pickerPanel.center = CGPointMake(pickerPanel.center.x, self.frame.size.height - pickerPanel.frame.size.height / 2);
    [UIView commitAnimations];
    
    __weak typeof(self) blockself = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        
        if (YLAreaView_TableView == blockself.style) [blockself initTableView];
        else if (YLAreaView_Picker == blockself.style) [blockself initPickerView];
        else ;
    });
}

- (void)closeYLAreaPicker
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hiddeShadow)];
    pickerPanel.center = CGPointMake(pickerPanel.center.x, self.frame.size.height + pickerPanel.frame.size.height / 2);
    [UIView commitAnimations];
}

- (void)addTitle:(NSString*)title
{
    if (YLAreaView_Picker == style)
    {
        UIView* topview = [pickerPanel viewWithTag:34];
        
        titleLb.frame = CGRectMake(50, 0, topview.frame.size.width - 50 * 2, topview.frame.size.height - 1);
        [titleLb setTitle:title Animate:YES];
        [titleLb setTextAlignmentStyle:NSTextAlignmentCenter];
    }
}

- (void)initTableView
{
    [self convertToDropDownNode:areas Node:rootNode];
    
    rootNode.children = (NSMutableArray*)[self sort:rootNode.children];
    
    [self initSections];
    
    if ([topName length] > 0) [self setTopNode:topName];
    
    [tableView reloadData];
    
    UIActivityIndicatorView* indicator = [pickerPanel viewWithTag:44];
    indicator.hidden = YES;
    [indicator stopAnimating];
}

- (void)initPickerView
{
    [self convertToDropDownNode:areas Node:rootNode];
    
    if ([topName length] > 0)
    {
        NSInteger index = 0;
        for (DropDownNode* node in rootNode.children)
        {
            if ([((YLAreaModel*)node.userData).name isEqualToString:topName])
            {
                if (0 != index)
                {
                    [rootNode.children exchangeObjectAtIndex:0 withObjectAtIndex:index];
                    break;
                }
            }
            
            ++index;
        }
    }
    
    NSInteger row = [rootNode.children count];
    [rootNode.children addObjectsFromArray:rootNode.children];
    
    pickerComs = 3;
    
    [pickerView reloadAllComponents];
    
    [pickerView selectRow:row inComponent:0 animated:YES];
    
    UIActivityIndicatorView* indicator = [pickerPanel viewWithTag:44];
    indicator.hidden = YES;
    [indicator stopAnimating];
}

- (void)hiddeShadow
{
    shadow.hidden = YES;
    [self removeFromSuperview];
}

@end
