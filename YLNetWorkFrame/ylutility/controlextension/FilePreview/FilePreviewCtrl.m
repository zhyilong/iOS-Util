//
//  FilePreviewCtrl.m
//  QQCar
//
//  Created by yilong zhang on 2017/1/11.
//  Copyright © 2017年 qqcy. All rights reserved.
//

#import "FilePreviewCtrl.h"

#import "YLDocPreviewCtrl.h"

@interface FilePreviewCtrl ()

@end

@implementation FilePreviewCtrl
{
    NSMutableArray<YLFileModel*>*     files;
    NSMutableArray<YLFileModel*>*     images;
    YLFileModel*                      curFile;
    NSMutableDictionary*              exIcons;
    CGSize                            itemSize;
    BOOL                              isLoaded;
}

@synthesize collectionview;
@synthesize delegate;
@synthesize fileMaxSize;

@synthesize preView;
@synthesize preWebView;

@synthesize preScroll;
@synthesize preImgView;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        fileMaxSize = 10485760;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _topView.backgroundColor = Color_NavBarBack;
    
    isLoaded = NO;
    files = [NSMutableArray array];
    images = [NSMutableArray array];
    
    exIcons = [NSMutableDictionary dictionary];
    NSArray* ex = @[@"dir", @"url", @"doc", @"img", @"mov", @"pdf", @"ppt", @"txt", @"voc", @"xls", @"##"];
    UIImage* image = nil;
    for (NSString* key in ex)
    {
        image = [UIImage imageNamed:key];
        [exIcons setObject:image forKey:[key uppercaseString]];
    }
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WinSize.width, WinSize.height - 64) collectionViewLayout:layout];
    [collectionview registerNib:[UINib nibWithNibName:@"FilePreviewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    collectionview.backgroundColor = Color_ViewBack;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.view addSubview:collectionview];
    
    preView = [[UIView alloc] initWithFrame:CGRectZero];
    preView.translatesAutoresizingMaskIntoConstraints = NO;
    preView.backgroundColor = [UIColor clearColor];
    preView.alpha = 0.0;
    [self.view addSubview:preView];
    
    NSDictionary* views = @{@"preview" : preView};
    NSArray* cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[preview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[preview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:cons];
    
    UIView* back = [[UIView alloc] initWithFrame:CGRectZero];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.8;
    [preView addSubview:back];
    
    views = @{@"back" : back};
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[back]-0-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[back]-0-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    preWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    preWebView.backgroundColor = [UIColor clearColor];
    preWebView.translatesAutoresizingMaskIntoConstraints = NO;
    preWebView.backgroundColor = [UIColor clearColor];
    preWebView.delegate = self;
    //preWebView.hidden = YES;
    [preView addSubview:preWebView];
    
    views = @{@"web" : preWebView};
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[web]-16-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[web]-20-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addTarget:self action:@selector(OnCloseDown:) forControlEvents:UIControlEventTouchUpInside];
    [preView addSubview:btn];
    
    views = @{@"btn" : btn};
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[btn(40)]" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[btn(40)]" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    //图片
    /*
    preScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    preScroll.backgroundColor = [UIColor clearColor];
    preScroll.translatesAutoresizingMaskIntoConstraints = NO;
    preScroll.hidden = YES;
    preScroll.delegate = self;
    preScroll.minimumZoomScale = 0.1;
    preScroll.maximumZoomScale = 2.0;
    [preView addSubview:preScroll];
    
    views = @{@"scroll" : preScroll};
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[scroll]-16-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
        cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-32-[scroll]-32-|" options:0 metrics:nil views:views];
    [preView addConstraints:cons];
    
    preImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    preImgView.backgroundColor = [UIColor clearColor];
    preImgView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
    preImgView.translatesAutoresizingMaskIntoConstraints = NO;
    [preScroll addSubview:preImgView];
    
    views = @{@"imgv" : preImgView};
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imgv]-0-|" options:0 metrics:nil views:views];
    [preScroll addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imgv]-0-|" options:0 metrics:nil views:views];
    [preScroll addConstraints:cons];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded)
    {
        [YLLoading CreateLoadingInView:self.view Title:LoadString(Hdl_Loading) Image:nil AtonceShow:YES];
        
        isLoaded = YES;
        
        preImgView.frame = CGRectMake(0, 0, preScroll.frame.size.width, preScroll.frame.size.height);
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = [UIColor clearColor];
        [_playBtn setImage:[UIImage imageNamed:@"gtk_media_play_ltr"] forState:UIControlStateNormal];
        _playBtn.frame = CGRectMake(0, 0, 50, 50);
        _playBtn.center = CGPointMake(preView.frame.size.width / 2, preView.frame.size.height / 2 - 50);
        _playBtn.hidden = YES;
        [_playBtn addTarget:self action:@selector(OnPlayDown) forControlEvents:UIControlEventTouchUpInside];
        [preView addSubview:_playBtn];
        
        itemSize = CGSizeMake(self.view.frame.size.width / 4, self.view.frame.size.width / 4);
        
        NSString* path = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
        
        [self enumFilesInPath:files Path:path];
        
        [self.view removeLoading];

        if (0 == [files count])
        {
            [[YLToast createInView:@"没有附件可以选择" Seconds:1] showInView:self.view];
        }
        else
        {
            [collectionview reloadData];
            
            [self createThumbnailForImage:[images lastObject]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[YLPlayer currentPlayer] stop];
}

- (void)OnCloseDown:(UIButton*)sender
{
    [[YLPlayer currentPlayer] stop];
    
    preView.alpha = 0;
}

- (void)OnPlayDown
{
    if (![[YLPlayer currentPlayer] isPlaying])
    {
        [YLLoading CreateLoadingInView:self.view Title:@"加载中..." Image:nil AtonceShow:YES];

        YLPlayer* player = [[YLPlayer alloc] initWithData:[NSData dataWithContentsOfFile:curFile.path]];
        
        [player play];
        
        [_playBtn setImage:[UIImage imageNamed:@"gtk_media_pause"] forState:UIControlStateNormal];
        
        [self.view removeLoading];
    }
    else
    {
        [[YLPlayer currentPlayer] pause];
        
        [_playBtn setImage:[UIImage imageNamed:@"gtk_media_play_ltr"] forState:UIControlStateNormal];
    }
}

- (void)loadDocument:(NSString*)path ExName:(NSString*)exname
{
    if ([path length] > 0)
    {
        if ([exname containsString:@"PNG"]
            || [exname containsString:@"JPEG"]
            || [exname containsString:@"JPG"])
        {
            preWebView.hidden = NO;
            preWebView.opaque = NO;
            _playBtn.hidden = YES;
            
            NSString* content = [NSString stringWithFormat:
                                @"<html>"
                                "<head>"
                                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, user-scalable=yes\">"
                                "<style type=\"text/css\">"
                                ".align-center{"
                                "width: %fpx; height: %fpx;padding: 0px;border: 0px solid #ccc;background:#0000;color:#fff;margin: 0px auto;"
                                "display: -webkit-box;-webkit-box-orient: horizontal;-webkit-box-pack: center;-webkit-box-align: center;display: -moz-box;-moz-box-orient: horizontal;-moz-box-pack: center;-moz-box-align: center;display: -o-box;-o-box-orient: horizontal;-o-box-pack: center;-o-box-align: center;display: -ms-box;-ms-box-orient: horizontal;-ms-box-pack: center;-ms-box-align: center;display: box;box-orient: horizontal;box-pack: center;box-align: center;"
                                "}"
                                "<!--"
                                "body{font-size:40pt;line-height:60pt;}"
                                "-->"
                                "</style>"
                                "</head>"
                                "<body style=\"background-color:transparent;\">"
                                "<div class=\"align-center\">"
                                "<img width=\"100%%\" src="
                                "\"file:///%@\"/>"
                                "</div>"
                                "</body>"
                                "</html>"
                                , preWebView.frame.size.width, preWebView.frame.size.height, path];
            
            [preWebView loadHTMLString:content baseURL:nil];
        }
        else if ([exname containsString:@"MP3"]
            || [exname containsString:@"AMR"]
            || [exname containsString:@"CAF"])
        {
            [_playBtn setImage:[UIImage imageNamed:@"gtk_media_play_ltr"] forState:UIControlStateNormal];
            
            preWebView.hidden = YES;
            _playBtn.hidden = NO;
        }
        else
        {
            preWebView.hidden = NO;
            preWebView.opaque = YES;
            _playBtn.hidden = YES;
            
            NSURL* Url = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:Url];
            [preWebView loadRequest:request];
        }
        
        preView.alpha = 1;
    }
    else
    {
        //
    }
}

- (void)enumFilesInPath:(NSMutableArray*)container Path:(NSString*)path
{
    NSArray* items = [self getFilesFromPath:path];
    YLFileModel* file = nil;
    NSString* ex = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* srcpath = nil;
    NSString* srcthpath = nil;
    NSDictionary* fileinfo = nil;
    BOOL isdir = NO;
    for (NSString* text in items)
    {
        file = nil;
        srcpath = [NSString stringWithFormat:@"%@/%@", path, text];
        srcthpath = [NSString stringWithFormat:@"%@/_thumbnail_%@", path, text];
        [manager fileExistsAtPath:srcpath isDirectory:&isdir];
        if (isdir)
        {
//            file = [[YLFileModel alloc] init];
//            file.type = 1;
//            file.exName = @"DIR";
        }
        else
        {
            ex = [[text pathExtension] uppercaseString];
            if ([ex length] > 0)
            {
                fileinfo = [manager attributesOfItemAtPath:srcpath error:nil];
                //文件大小不能大于10M
                if ([[fileinfo objectForKey:NSFileSize] integerValue] <= fileMaxSize)
                {
                    file = [[YLFileModel alloc] init];
                    file.type = 0;
                    file.exName = ex;
                }
            }
        }
        
        if (file)
        {
            file.name = [[text componentsSeparatedByString:@"."] firstObject];
            file.path = srcpath;
            file.icon = [self fileIconWithExName:file.exName];
            [container addObject:file];
            
            //异步生成缩略图
            if ([exIcons objectForKey:@"IMG"] == file.icon)
            {
                file.isExistThumbnail = NO;
                [images addObject:file];
            }
        }
    }
}

- (UIImage*)fileIconWithExName:(NSString*)ex
{
    NSString* icon = nil;
    
    if ([ex containsString:@"DOC"]) icon = @"DOC";
    else if ([ex containsString:@"XLS"]) icon = @"XLS";
    else if ([ex containsString:@"HTM"]) icon = @"URL";
    else if ([ex containsString:@"PDF"]) icon = @"PDF";
    else if ([ex containsString:@"PNG"]) icon = @"IMG";
    else if ([ex containsString:@"JPG"]) icon = @"IMG";
    else if ([ex containsString:@"JPEG"]) icon = @"IMG";
    else if ([ex containsString:@"TXT"]) icon = @"TXT";
    else if ([ex containsString:@"RTF"]) icon = @"TXT";
    else if ([ex containsString:@"MP3"]) icon = @"VOC";
    else if ([ex containsString:@"AMR"]) icon = @"VOC";
    else if ([ex containsString:@"CAF"]) icon = @"VOC";
    else if ([ex containsString:@"DIR"]) icon = @"DIR";
    else icon = @"##";
    
    return [exIcons objectForKey:icon];
}

- (NSArray<NSString*>*)getFilesFromPath:(NSString*)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    return [manager contentsOfDirectoryAtPath:path error:nil];
}

- (IBAction)OnBackDown:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(filePreviewCtrlCanceled:)])
    {
        [delegate filePreviewCtrlCanceled:self];
    }
    
    delegate = nil;
}

- (void)createThumbnailForImage:(YLFileModel*)file
{
    if (file)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSFileManager* filemgr = [NSFileManager defaultManager];
            UIImage* thumbnail = nil;
            if (![filemgr fileExistsAtPath:file.thumbnailPath])
            {
                UIImage* image = [UIImage imageWithContentsOfFile:file.path];
                if (image) thumbnail = [image imageByScalingToSize:itemSize];
            }
            else
            {
                thumbnail = [UIImage imageWithContentsOfFile:file.thumbnailPath];
            }
            
            file.isExistThumbnail = YES;
            
            [images removeLastObject];
            
            if (thumbnail)
            {
                NSData* data = UIImageJPEGRepresentation(thumbnail, 1);
                [data writeToFile:file.thumbnailPath atomically:YES];
                
                file.icon = thumbnail;
                file.imageV.image = file.icon;
            }
            
            [self createThumbnailForImage:[images lastObject]];
            
        });
    }
}

//delegate of uicollectionview
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [files count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return itemSize;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionview dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilePreviewCell* cellex = (FilePreviewCell*)cell;
    YLFileModel* file = [files objectAtIndex:indexPath.row];
    
    cellex.title.text = file.name;
    cellex.icon.image = file.icon;
    
    file.imageV = cellex.icon;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLFileModel* file = [files objectAtIndex:indexPath.row];
    NSString* ex = file.exName;
    
    curFile = file;

    __weak typeof(self)blockself = self;
    
    UIAlertController* ctrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ctrl addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [blockself loadDocument:file.path ExName:ex];
        
    }]];
    
    [ctrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([blockself.delegate respondsToSelector:@selector(filePreviewCtrl:DidSelected:)])
        {
            [blockself.delegate filePreviewCtrl:self DidSelected:file];
        }
        
        blockself.delegate = nil;
        
    }]];
    
    [ctrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //
        
    }]];
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

///delegate of uiscrollview
//- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    if (preScroll == scrollView)
//    {
//        return preImgView;
//    }
//    
//    return nil;
//}

///delegate of uiwebview
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [YLLoading CreateLoadingInView:self.view Title:@"加载中..." Image:nil AtonceShow:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view removeLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view removeLoading];
    
    [YLToast createInView:@"抱歉，加载错误" Seconds:2];
}

@end
