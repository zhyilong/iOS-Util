//
//  ImagePreviewGrid.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/25.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ImagePreviewGrid.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+YLNetWorkFrame.h"

@implementation ImagePreviewGrid
{
    NSMutableArray*     datas;
    UIImage*            defImage;
    UIImage*            defDelImage;
    ImagePreviewItem*   addItem;
    ImagePreviewItem*   coverItem;
    NSInteger           column;
    
    UICollectionView*   itemsView;
    ImagePreviewCell*   selectedCell;
    
    CGSize              itemViewSize;
    ImgGridOpType       opType;
}

@synthesize delegate;
@synthesize maxItemNum;
@synthesize minItemNum;
@synthesize isCanAdd;
@synthesize isCanEdit;
@synthesize isCanSetCover;
@synthesize coverImage;
@synthesize itemEdgeInsets;
@synthesize itemSize;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame ItemSize:(CGSize)itemsize DefImage:(UIImage*)defimage DefDelImage:(UIImage*)defdelimage
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        datas          = [NSMutableArray array];
        itemSize       = itemsize;
        itemViewSize   = itemsize;
        itemEdgeInsets = UIEdgeInsetsZero;
        defImage       = defimage;
        defDelImage    = defdelimage;
        selectedCell   = nil;
        delegate       = nil;
        isCanAdd       = YES;
        isCanEdit      = YES;
        isCanSetCover  = NO;
        maxItemNum     = 0;
        minItemNum     = 0;
        coverItem      = nil;
        opType         = ImgGridOp_Unkonw;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        itemsView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [itemsView registerClass:[ImagePreviewCell class] forCellWithReuseIdentifier:@"cell"];
        itemsView.delegate = self;
        itemsView.dataSource = self;
        itemsView.backgroundColor = [UIColor clearColor];
        [itemsView setScrollEnabled:NO];
        itemsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:itemsView];
        
        column = itemsView.frame.size.width / itemSize.width;
        //添加
        addItem = [[ImagePreviewItem alloc] init];
        addItem.isNew = NO;
        addItem.image = defimage;
        addItem.delImage = defdelimage;
        addItem.imagePath = @"add";
        [datas addObject:addItem];
        
        return self;
    }
    
    return nil;
}

- (void)setItemEdgeInsets:(UIEdgeInsets)itemedgeinsets
{
    itemEdgeInsets = itemedgeinsets;
    
    itemViewSize = CGSizeMake(itemSize.width - itemEdgeInsets.left - itemEdgeInsets.right, itemSize.height - itemEdgeInsets.top - itemEdgeInsets.bottom);
}

- (ImagePreviewItem*)coverItem
{
    return coverItem;
}

- (NSMutableArray*)dataSource
{
    return datas;
}

- (void)setMinItemNum:(NSInteger)minitemnum DefImage:(UIImage*)image DelImage:(UIImage*)delimage
{
    self.minItemNum = minitemnum;
    ImagePreviewItem* item = nil;
    for (int i=0; i<self.minItemNum-1; i++)
    {
        item = [[ImagePreviewItem alloc] init];
        
        item.isNew = YES;
        
        if (image) item.image = image;
        else item.image = defImage;
        
        if (delimage) item.delImage = delimage;
        else item.delImage = defDelImage;
        
        NSInteger row = [datas count] - 1;
        [datas insertObject:item atIndex:row];
        
        //到达最大上限，不能再添加
        if (maxItemNum == [datas count] - 1 && isCanAdd)
        {
            isCanAdd = NO;
            break;
        }
    }
}

- (void)updateCell:(ImagePreviewCell*)cell Image:(UIImage*)image
{
    if (cell)
    {
        [cell updateImage:image];
        
        if (defImage == image) cell.delBtn.hidden = YES;
        else cell.delBtn.hidden = !isCanEdit;
    }
}

- (void)isCanScrollContentView:(BOOL)iscan
{
    itemsView.scrollEnabled = iscan;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = [datas count];
    if (!isCanAdd)
    {
        row -= 1;
    }
    
    return row;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = itemSize;
    
    if (isCanSetCover) size.height += 32;
    
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImagePreviewCell* cell = (ImagePreviewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.edgeInsets = itemEdgeInsets;
    cell.tag = indexPath.row;
    [self setCell:(ImagePreviewCell*)cell IndexPath:indexPath];
    
    return cell;
}

- (void)setCell:(ImagePreviewCell*)cell IndexPath:(NSIndexPath*)indexpath
{
    ImagePreviewItem* item = [datas objectAtIndex:indexpath.row];
    cell.data = item;
    cell.data.index = indexpath.row;

    //封面设置
    [cell showSetCoverButton:isCanSetCover Height:32];
    cell.coverBtn.tag = indexpath.row;
    cell.coverBtn.selected = item.isCover;
    cell.coverView.image = coverImage;
    cell.coverView.hidden = !item.isCover;
    if (item.isCover) coverItem = item;
    if (0 == [[cell.coverBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count])
        [cell.coverBtn addTarget:self action:@selector(OnSetCoverDown:) forControlEvents:UIControlEventTouchUpInside];
    
    //删除设置
    [cell.delBtn setImage:item.delImage forState:UIControlStateNormal];
    cell.delBtn.tag = indexpath.row;
    if (0 == [[cell.delBtn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count])
        [cell.delBtn addTarget:self action:@selector(OnDeleteDown:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加项
    if (addItem == item)
    {
        //添加不显示删除
        cell.delBtn.hidden = YES;
        
        [self setCellCoverBtnTitle:cell Title:@" "];
    }
    //普通项
    else
    {
        //是否可编辑
        if (!isCanEdit)
        {
            cell.delBtn.hidden = YES;
        }
        else
        {
            //最小显示范围内部显示且是默认图片未编辑图片
            if (indexpath.row < minItemNum && item.isNew) cell.delBtn.hidden = YES;
            else cell.delBtn.hidden = NO;
        }
        
        [self setCellCoverBtnTitle:cell Title:@"设置封面"];
    }
    
    //设置图片
    if (item.isLoadFromNet && [item.imagePath length] > 0)
    {
        //加载网路图片
        //[cell.imgView cancelCurrentImageLoad];
        //[cell.imgView setImageWithURL:[NSURL URLWithString:item.imagePath]];
        //[cell.imgView setImageWithURL:[NSURL URLWithString:item.imagePath] placeholderImage:defImage];
        
        [cell.imgView cancelDownload];
        NSString* cachename = [[item.imagePath componentsSeparatedByString:@"/"] lastObject];
        [cell.imgView setDataWithUrl:[NSURL URLWithString:item.imagePath] IsLoadCache:YES CacheName:cachename CallBack:^(UIImageView *view, NSError *error) {
            
            //
            
        }];
    }
    else
    {
        cell.imgView.image = item.image;
    }
}

- (void)setCellCoverBtnTitle:(ImagePreviewCell*)cell Title:(NSString*)title
{
    [cell.coverBtn setTitle:title forState:UIControlStateNormal];
    [cell.coverBtn setTitle:title forState:UIControlStateHighlighted];
    [cell.coverBtn setTitle:title forState:UIControlStateSelected];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImagePreviewCell* cell = (ImagePreviewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //添加
    if (addItem == cell.data)
    {
        opType = ImgGridOp_Add;
    }
    //编辑
    else
    {
        opType = ImgGridOp_Edit;
        selectedCell = cell;
    }
    if ([delegate respondsToSelector:@selector(imagePreviewGrid:SelectedCell:OpType:)])
        [delegate imagePreviewGrid:self SelectedCell:cell OpType:opType];
}

- (ImagePreviewItem*)addItem:(UIImage*)image DelImage:(UIImage*)delimage IsReload:(BOOL)isreload
{
    ImagePreviewItem* item = [self emptyItem];
    if (!item)
    {
        item = [[ImagePreviewItem alloc] init];
        
        NSInteger row = [datas count] - 1;
        [datas insertObject:item atIndex:row];
        
        //到达最大上限，不能再添加
        if (maxItemNum == [datas count] - 1 && isCanAdd) isCanAdd = NO;
    }
    
    item.isNew = NO;
    
    if (image) item.image = image;
    else item.image = defImage;
    
    if (delimage) item.delImage = delimage;
    else item.delImage = defDelImage;

    if (isreload) [self reload];
    return item;
}

- (ImagePreviewItem*)emptyItem
{
    ImagePreviewItem* item = nil;
    
    for (ImagePreviewItem* tmp in datas)
    {
        if (tmp.isNew)
        {
            item = tmp;
            break;
        }
    }
    
    return item;
}

- (void)updateCurCell:(UIImage*)image
{
    ImagePreviewCell* cell = [self selectedCell];
    [cell updateImage:image];
    
    ImagePreviewItem* item = cell.data;
    item.image = image;
    
    if (isCanEdit) cell.delBtn.hidden = NO;
    else cell.delBtn.hidden = YES;
}

- (void)removeItem:(NSInteger)index
{
    NSInteger total = [datas count] - 1;
    ImagePreviewItem* item = [datas objectAtIndex:index];
    if (index >=0 && index < total)
    {
        if (coverItem == item)
        {
            item.isCover = NO;
            coverItem = nil;
        }
        
        //删除不在最小显示范围内项
        if (total > minItemNum - 1)
        {
            [datas removeObjectAtIndex:index];
        }
        else
        {
            item.image = defImage;
            item.imagePath = nil;
            item.isNew = YES;
            item.isLoadFromNet = NO;
            //用户数据
            item.usrData = nil;
        }
        
        if ([datas count] - 1 < maxItemNum && !isCanAdd) isCanAdd = YES;
        
        [self reload];
    }
}

- (void)reload
{
    [itemsView reloadData];
}

- (void)OnDeleteDown:(UIButton*)sender
{
    ImagePreviewCell* cell = (ImagePreviewCell*)[[sender superview] superview];
    ImagePreviewItem* item = (ImagePreviewItem*)[datas objectAtIndex:sender.tag];
    
    //if (item.isLoadFromNet) [cell.imgView cancelCurrentImageLoad];

    [self removeItem:sender.tag];
    
    if (selectedCell.data.index == self.tag) selectedCell = nil;
    
    opType = ImgGridOp_Remove;
    
    if ([delegate respondsToSelector:@selector(imagePreviewGrid:SelectedCell:OpType:)])
        [delegate imagePreviewGrid:self SelectedCell:cell OpType:opType];
}

- (void)OnSetCoverDown:(UIButton*)sender
{
    ImagePreviewItem* item = (ImagePreviewItem*)[datas objectAtIndex:sender.tag];
    ImagePreviewCell* cell = (ImagePreviewCell*)[sender superview];
    ImagePreviewItem* proitem = nil;
    
    //设置了图片可以设置封面
    if (defImage !=  cell.imgView.image)
    {
        proitem = coverItem;
        coverItem.isCover = NO;
        
        if (item.isCover)
        {
            item.isCover = NO;
            if (item == coverItem) coverItem = nil;
        }
        else
        {
            item.isCover = YES;
            coverItem = item;
        }
        
        if ([delegate respondsToSelector:@selector(imagePreviewGrid:ProCover:CurCover:)])
            [delegate imagePreviewGrid:self ProCover:proitem CurCover:coverItem];

        [self reload];
    }
    else
    {
        //添加
        if (addItem == item)
        {
            opType = ImgGridOp_Add;
            
            if ([delegate respondsToSelector:@selector(imagePreviewGrid:SelectedCell:OpType:)])
                [delegate imagePreviewGrid:self SelectedCell:cell OpType:opType];
        }
    }
}

- (NSArray<ImagePreviewItem*>*)getItems
{
    NSMutableArray* items = [NSMutableArray array];
    
    for (ImagePreviewItem* item in datas)
    {
        //不返回添加项
        if (addItem != item) [items addObject:item];
    }
    
    return items;
}

- (NSArray<ImagePreviewItem*>*)getValidItems
{
    NSMutableArray* items = [NSMutableArray array];
    
    for (ImagePreviewItem* item in datas)
    {
        //不返回添加项，图片不是默认图片
        if (addItem != item && defImage != item.image) [items addObject:item];
    }
    
    return items;
}

- (ImagePreviewCell*)selectedCell
{
    return selectedCell;
}

- (void)addEnabled:(BOOL)enabled IsReload:(BOOL)isreload
{
    if (!enabled && isCanAdd)
    {
        isCanAdd = enabled;

        if (isreload) [self reload];
    }
    else if (enabled && !isCanAdd)
    {
        isCanAdd = enabled;

        if (isreload) [self reload];
    }
    else return;
}

- (CGSize)contentSize
{
    NSInteger countIndex = [datas count];
    if(!isCanAdd)
    {
        countIndex = countIndex-1;
    }
    NSInteger row = countIndex / column;
    if (0 != countIndex % column)
    {
        row += 1;
    }
    return CGSizeMake(column * itemSize.width, row * (itemSize.height + ((isCanSetCover) ? (32) : (0))));
}

- (void)updateContentSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (ImgGridOpType)operateType
{
    return opType;
}

@end
