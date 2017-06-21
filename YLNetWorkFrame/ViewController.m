//
//  ViewController.m
//  YLNetWorkFrame
//
//  Created by zhangyilong on 16/4/5.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ViewController.h"
#import "DateUtility.h"
#import "NSString+Utility.h"
#import "YLZoomImgCtrl.h"
#import "TestDropDownList.h"
#import "YLTextField.h"
#import "YLToast.h"
#import "YLLoading.h"
#import "YLScrollLabel.h"
#import "SDAdScrollView.h"
#import "UIImageView+YLNetWorkFrame.h"
#import "YLPlaceholderTextView.h"
#import "TestRecorder.h"
#import "YLAreaSelectView.h"
#import "ImagePreviewGrid.h"
#import "YLDocPreviewCtrl.h"
#import "YLNetWorkFrame.h"
#import "YLSearchBar.h"
#import "YLImageEditView.h"
#import "YLInputView.h"
#import "YLRippleView.h"
#import "YLScrltchCard.h"
#import "CLLocation+Transform.h"
#import "AFNetworking.h"

@interface ViewController () <YLZoomImgDelegate, YLImageEditViewDelegate, YLTextFieldDelegate, YLInputViewDelegate>

@end

@implementation ViewController
{
    BOOL                    isLoaded;
    NSMutableArray* cellTitles;
    
    ImagePreviewGrid*   gridView;
    dispatch_source_t    timer;
}

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YLTableTopLoader* toploader = [[YLTableTopLoader alloc] initWithFrame:CGRectMake(0, -80, tableView.frame.size.width, 80) Scroll:tableView Delegate:self];
    YLTableBottomLoader* btmloader = [[YLTableBottomLoader alloc] initWithFrame:CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, 80) Scroll:tableView Delegate:self];
    
//    NSLog(@"%@", [DateUtility timestampToDateString:1461340799 FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:nil]);
//    NSLog(@"%@", [DateUtility dateToDateString:[NSDate date] FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:nil]);
//    NSDate* date = [DateUtility dateStringToDate:@"2016-04-22 17:30:30" FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:[DateUtility dateChinaTimeZone]];
//    NSLog(@"%@", [DateUtility dateToDateString:date FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:nil]);
//    NSLog(@"%ld", [DateUtility dateStringToTimestamp:[DateUtility dateToDateString:date FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:nil] FormatString:@"yyyy-MM-dd HH:mm:ss" TimeZone:nil]);
//    
//    UInt64 seconds = [[NSDate date] timeIntervalSince1970];// + [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
//    date = [DateUtility dateTimestampToDate:seconds FormatString:@"yyyy年MM月dd日 HH:mm:ss" TimeZone:nil];
//    NSLog(@"###3");
    
    isLoaded = NO;
    cellTitles = [NSMutableArray array];
    
    [UIImageView setCachePath:[NSString stringWithFormat:@"%@/Documents/cache", [UIImageView getHomeDirectory]]];
    
    [cellTitles addObject:@"YLToast"];
    [cellTitles addObject:@"YLLoading"];
    [cellTitles addObject:@"YLScrollLabel"];
    [cellTitles addObject:@"SDAdScrollView"];
    [cellTitles addObject:@"DropDownList"];
    [cellTitles addObject:@"BTNTextField"];
    [cellTitles addObject:@"TextFieldMax"];
    [cellTitles addObject:@"YLPLaceholderTextView"];
    [cellTitles addObject:@"YLRecorder"];
    [cellTitles addObject:@"汉字转拼音"];
    [cellTitles addObject:@"汉字排序"];
    [cellTitles addObject:@"地区"];
    [cellTitles addObject:@"检测手机号"];
    [cellTitles addObject:@"图片裁剪"];
    [cellTitles addObject:@"gridview"];
    [cellTitles addObject:@"文档预览"];
    [cellTitles addObject:@"NetWork"];
    [cellTitles addObject:@"GCDTimer"];
    [cellTitles addObject:@"searchbar"];
    [cellTitles addObject:@"inputview"];
    [cellTitles addObject:@"editimage"];
    [cellTitles addObject:@"ripple"];
    [cellTitles addObject:@"scratchcard"];
    [cellTitles addObject:@"location"];
    
    /*
    CGSize itemsize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3);
    ImagePreviewGrid* grid = [[ImagePreviewGrid alloc] initWithFrame:self.view.bounds ItemSize:itemsize DefImage:[UIImage imageNamed:@"addImage"] DefDelImage:[UIImage imageNamed:@"mailbox_unsent_icon@"]];
    for (int i=0; i<50; i++)
    {
        [grid addItem:[UIImage imageNamed:@"addImage"] DelImage:[UIImage imageNamed:@"fm_ico50"] IsReload:NO];
    }
    [self.view addSubview:grid];
    */
    
//    UIBTNTextField* filed = [[UIBTNTextField alloc] initWithFrame:CGRectMake(100, 100, 100, 35)];
//    filed.placeholder = @"uibutton";
//    filed.borderStyle = UITextBorderStyleRoundedRect;
//    [filed addTarget:self Action:@selector(didBTNTextFieldDown:)];
//    [self.view addSubview:filed];
}

- (IBAction)OnBTNTextFieldDown:(UITextField*)textField
{
    NSLog(@"hell BTNTextField");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded)
    {
        isLoaded = YES;
        
        /*
        UIImagePickerController* ctrl = [[UIImagePickerController alloc] init];
        ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ctrl.delegate = self;
        [self presentViewController:ctrl animated:YES completion:^{
            //
        }];
        */ 
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableview willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = [cellTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    NSString* title = [cellTitles objectAtIndex:indexPath.row];
    
    if ([title isEqualToString:@"YLToast"])
    {
        UIImage* image = [UIImage imageNamed:@"face_smile"];
        
        YLToast* toast = [YLToast createWithTitle:@"Center" Image:image Seconds:1];
        [toast showInView:tableview];
        
        toast = [YLToast createWithTitle:@"Top" Image:image Seconds:1];
        toast.positionStyle = YLToast_Position_Top;
        toast.contentStyle = YLToast_Content_ImageTop;
        [toast showInView:tableview];
        
        toast = [YLToast createWithTitle:@"Bottom多行测试，多行测试，多行测试，多行测试，多行测试!!!" Image:image Seconds:1];
        toast.positionStyle = YLToast_Position_Bottom;
        toast.contentStyle = YLToast_Content_TextTop;
        //[toast showInView:tableview];
        [toast showInView:tableView AnimateStyle:1];
    }
    else if ([title isEqualToString:@"YLLoading"])
    {
        
        UIImage* image = [UIImage imageNamed:@"face_smile"];
        
        //YLLoading* loading = [YLLoading CreateLoadingInView:self.view Title:@"测试中测试中..." Image:nil AtonceShow:YES];

        YLLoading* loading = [YLLoading CreateLoadingInView:self.view Title:@"测试中测试中..." Image:nil AtonceShow:NO];
        [loading setStyle:YLLoading_Accessory_Left];
        [loading setTimeOut:5 Callback:^(YLLoading *loading) {
            
            NSLog(@"timeout");
            
        }];
        
        [self performSelector:@selector(hiddeLoading) withObject:nil afterDelay:2];
    }
    else if ([title isEqualToString:@"YLScrollLabel"])
    {
        YLScrollLabel* label = [[YLScrollLabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, (self.view.frame.size.height - 25) / 2, 150, 25) Font:[UIFont systemFontOfSize:15]];
        [self.view addSubview:label];
        
        [label setTitle:@"多行测试，多行测试，多行测试，多行测试，多行测试!!!" Animate:YES];
        
        [self performSelector:@selector(hiddeScrollLabel:) withObject:label afterDelay:5];
    }
    else if ([title isEqualToString:@"SDAdScrollView"])
    {
        SDAdScrollView* view = [[SDAdScrollView alloc] initWithFrame:CGRectMake(16, (self.view.frame.size.height - 150) / 2, self.view.frame.size.width - 32, 150)];
        [self.view addSubview:view];
        
        [view setAdList:[NSArray arrayWithObjects:@"http://image.lxway.com/thumb/280x220/3/0a/30a34bb4f16a3d0d6eca63e79f902548.png", @"http://images.cnitblog.com/i/561443/201404/111700530909362.png", nil]];
        
        [self performSelector:@selector(hiddeSDAdScrollView:) withObject:view afterDelay:10];
    }
    else if ([title isEqualToString:@"DropDownList"])
    {
        TestDropDownList* ctrl = [[TestDropDownList alloc] init];
        
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"BTNTextField"])
    {
        YLTextField* textField = [[YLTextField alloc] initWithFrame:CGRectMake(32, 200, self.view.frame.size.width - 64, 35)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.backgroundColor = [UIColor whiteColor];
        textField.inpunStyle = Input_External;
        textField.isNull = NO;
        textField.title = @"测试测试测试";
        [self.view addSubview:textField];
        
        textField = [[YLTextField alloc] initWithFrame:CGRectMake(32, 240, self.view.frame.size.width - 64, 35)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.backgroundColor = [UIColor whiteColor];
        textField.inpunStyle = Input_External;
        textField.isNull = YES;
        textField.title = @"测试测试测试";
        [self.view addSubview:textField];
        
        textField = [[YLTextField alloc] initWithFrame:CGRectMake(32, 280, self.view.frame.size.width - 64, 35)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.backgroundColor = [UIColor whiteColor];
        textField.inpunStyle = Input_External;
        textField.isNull = NO;
        textField.title = nil;
        [self.view addSubview:textField];
        
        textField = [[YLTextField alloc] initWithFrame:CGRectMake(32, 320, self.view.frame.size.width - 64, 35)];
        textField.borderStyle = UITextBorderStyleLine;
        textField.backgroundColor = [UIColor whiteColor];
        textField.inpunStyle = Input_External;
        textField.isNull = YES;
        textField.title = nil;
        [self.view addSubview:textField];
        
        //[textField showLoader:[UIColor clearColor]];
        
        //[self performSelector:@selector(hiddeBTNTextField:) withObject:textField afterDelay:3];
    }
    else if ([title isEqualToString:@"TextFieldMax"])
    {
        YLTextField* textField = [[YLTextField alloc] initWithFrame:CGRectMake(32, 200, self.view.frame.size.width - 64, 35)];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.backgroundColor = [UIColor whiteColor];
        textField.maxLength = 10;
        [self.view addSubview:textField];
    }
    else if ([title isEqualToString:@"YLPLaceholderTextView"])
    {
        YLPlaceholderTextView* view = [[YLPlaceholderTextView alloc] initWithFrame:CGRectMake(32, 200, self.view.frame.size.width - 64, 90)];
        view.backgroundColor = [UIColor orangeColor];
        view.font = [UIFont systemFontOfSize:14];
        view.placeholder = @"Placeholder";
        [self.view addSubview:view];
        
        [view setCharacterCntFont:[UIFont systemFontOfSize:13] TextColor:[UIColor darkGrayColor]];
        [view showCharacterCount:100];
        
        [self performSelector:@selector(hiddePlaceholderTextView:) withObject:view afterDelay:60];
    }
    else if ([title isEqualToString:@"YLRecorder"])
    {
        TestRecorder* ctrl = [[TestRecorder alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"汉字转拼音"])
    {
        NSString* han = @"中国";
        NSString* str = [han HanCharacter2Pinyin:YES];
        NSLog(@"%@", str);
        
        han = @"陕西";
        str = [han HanCharacter2Pinyin:NO];
        NSLog(@"%@", str);
    }
    else if ([title isEqualToString:@"汉字排序"])
    {
        NSArray* hans = [NSArray arrayWithObjects:@"陕西", @"beijing", @"青海", @"hainan", @"深圳", @"新疆", @"yunnan", nil];
        NSMutableArray* inital = [NSMutableArray array];
        for (NSString* name in hans)
        {
            [inital addObject:[[name HanCharacter2Pinyin:NO] substringFromIndex:0]];
        }
        
        NSArray* result = [inital sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
            
            char ch1 = [obj1 characterAtIndex:0];
            char ch2 = [obj2 characterAtIndex:0];
            
            if (ch1 > ch2) return NSOrderedAscending;
            else if (ch1 < ch2) return NSOrderedDescending;
            else return NSOrderedSame;
            
        }];
        
        NSLog(@"%@", result);
    }
    else if ([title isEqualToString:@"地区"])
    {
        YLAreaSelectView* view = [[YLAreaSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) JsonFile:nil Style:YLAreaView_Picker];
        [view addTitle:@"地区"];
        view.topName = @"陕西";
        [self.view addSubview:view];
        
        [view showYLAreaPicker];
    }
    else if ([title isEqualToString:@"检测手机号"])
    {
        NSString* phone = @"18169121138";
        if ([phone isMobileNumber])
        {
            NSLog(@"是手机号码");
        }
    }
    else if ([title isEqualToString:@"图片裁剪"])
    {
        CGSize winsize = [UIScreen mainScreen].bounds.size;
        winsize.height *= 0.6;
        YLZoomImgCtrl* ctrl = [[YLZoomImgCtrl alloc] initWithImage:[UIImage imageNamed:@"image2.png"] ClipSize:winsize];
        ctrl.delegate = self;
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"gridview"])
    {
        gridView = [[ImagePreviewGrid alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 350) ItemSize:CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3) DefImage:[UIImage imageNamed:@"addImage"] DefDelImage:[UIImage imageNamed:@"face_smile"]];
        gridView.maxItemNum = 5;
        gridView.isCanSetCover = YES;
        [gridView setItemEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [gridView setMinItemNum:3 DefImage:nil DelImage:nil];
        gridView.coverImage = [UIImage imageNamed:@"fm_ico50"];
        gridView.delegate = self;
        [self.view addSubview:gridView];
    }
    else if ([title isEqualToString:@"文档预览"])
    {
        NSLog(@"%@", NSHomeDirectory());
        NSString* path = [[NSBundle mainBundle] pathForResource:@"doc" ofType:@"pdf"];
        path = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", @"doc.xls"];
        YLDocPreviewCtrl* ctrl = [[YLDocPreviewCtrl alloc] init:YES Path:path];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"NetWork"])
    {
        for (NSInteger i=0; i<100; i++)
        {
//            [[YLNetWorkManager Default] get:@"https://www.baidu.com" TimeOut:15 CallBack:^(YLUrlSession *session, NSData *data, id userdata, NSError *error) {
//                
//                NSLog(@"%ld", [userdata integerValue]);
//                
//            } Owner:self UserData:[NSNumber numberWithInteger:i]];
            
            AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            [[AFHTTPSessionManager manager] GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%ld", i);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error - %@", error);
            }];
        }
    }
    else if ([title isEqualToString:@"GCDTimer"])
    {
        [self GCDTimer];
    }
    else if ([title isEqualToString:@"searchbar"])
    {
        YLSearchBar* bar = [YLSearchBar createYLSearchBar:[UIImage imageNamed:@"filter_black"]];
        bar.frame = CGRectMake(16, 150, winsize.width - 32, 46);
        [self.view addSubview:bar];
    }
    else if ([title isEqualToString:@"editimage"])
    {
        CGSize winsize = [UIScreen mainScreen].bounds.size;
        winsize.height *= 0.6;

        UIAlertController* ctrl = [UIAlertController alertControllerWithTitle:@"选择" message:@"目标图片" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* action = nil;
        for (NSInteger i=1; i<=5; i++)
        {
            action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"image%ld.png", i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                YLImageEditView* view = [[YLImageEditView alloc] initWithFrame:[UIScreen mainScreen].bounds CropSize:winsize];
                
                [view setImage:[UIImage imageNamed:action.title]];
                view.delegate = self;
                
                [self.view addSubview:view];
                
            }];
            
            [ctrl addAction:action];
        }
        
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"inputview"])
    {
        YLInputView* view = [[YLInputView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, 30)];
        
        view.delegate = self;
        view.text = @"快快快快快快捷方式开的房间打开就分开的房价款看到就分开的机房监控贷款纠纷快递费";
        view.backgroundColor = [UIColor orangeColor];
        
        [self.view addSubview:view];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        v.backgroundColor = [UIColor redColor];
        [view setLeftView:v];
        
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        v.backgroundColor = [UIColor redColor];
        [view setRightView:v];
        
        [view setIsMultiLine:YES];
    }
    else if ([title isEqualToString:@"ripple"])
    {
        YLRippleView* view = [[YLRippleView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) Count:8];
        [self.view addSubview:view];
    }
    else if ([title isEqualToString:@"scratchcard"])
    {
        YLScrltchCard* view = [[YLScrltchCard alloc] initWithFrame:CGRectMake(100, 100, 100, 40) SurfaceText:@"刮开有奖" AwardText:@"10000元"];
        [self.view addSubview:view];
    }
    else if ([title isEqualToString:@"location"])
    {
        CLLocation* baidu = [[CLLocation alloc] initWithLatitude:39.921327 longitude:116.407754];
        
        CLLocation* ret = [baidu Baidu2Spark];
        
        NSLog(@"百度转火星：(%f, %f)", ret.coordinate.longitude, ret.coordinate.latitude);
        
        CLLocation* spark = [[CLLocation alloc] initWithLatitude:ret.coordinate.latitude longitude:ret.coordinate.longitude];
        
        ret = [spark Spark2Baidu];
        
        NSLog(@"火星转百度：(%f, %f)", ret.coordinate.longitude, ret.coordinate.latitude);
        
    }
    else ;
}

- (void)hiddeLoading
{
    [self.view removeLoading];
}

- (void)hiddeScrollLabel:(NSObject*)object
{
    [(YLScrollLabel*)object removeFromSuperview];
}

- (void)hiddeSDAdScrollView:(NSObject*)object
{
    [(SDAdScrollView*)object removeFromSuperview];
}

- (void)hiddeBTNTextField:(NSObject*)object
{
    YLTextField* textField = (YLTextField*)object;
    [textField removeFromSuperview];
}

- (void)hiddePlaceholderTextView:(NSObject*)object
{
    [((YLPlaceholderTextView*)object) removeFromSuperview];
}

//yltextfield
- (void)YLTexTFieldMaxLength:(YLTextField *)textField
{
    YLToast* toast = [YLToast createWithTitle:@"输入长度不能大于10" Seconds:1];
    [toast showInView:self.view];
}

- (void)YLTextFieldClicked:(YLTextField *)textField
{
    //
}

//toploader
- (NSString*)didYLTableTopLoaderTitleForState:(YLTableTopLoader *)loader State:(YLTableLoaderState)state
{
    return @"刷新";
}

- (void)didYLTableTopLoaderDragingForState:(YLTableTopLoader *)loader State:(YLTableLoaderState)state ContentOffset:(CGPoint)contentoffset
{
    NSLog(@"%f", contentoffset.y);
}

- (UIView*)didYLTableTopLoaderAccessoryView:(YLTableTopLoader *)loader State:(YLTableLoaderState)state
{
    return nil;
}

- (void)didYLTableTopLoaderSelected:(YLTableTopLoader *)loader
{
    [((UIScrollView*)[loader superview]) stopLoading];
}

//bottomloader
- (NSString*)didYLTableBottomLoaderTitleForState:(YLTableBottomLoader *)loading State:(YLTableLoaderState)state
{
    return @"更多";
}

- (void)didYLTableBottomLoaderDragingForState:(YLTableBottomLoader *)loader State:(YLTableLoaderState)state ContentOffset:(CGPoint)contentoffset
{
    NSLog(@"%f", contentoffset.y);
}

- (UIView*)didYLTableBottomLoaderAccessoryView:(YLTableBottomLoader *)loader State:(YLTableLoaderState)state
{
    return nil;
}

- (void)didYLTableBottomLoaderSelected:(YLTableBottomLoader *)loader
{
    [((UIScrollView*)[loader superview]) stopLoading];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    YLZoomImgCtrl* ctrl = [[YLZoomImgCtrl alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] ClipSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 1.2)];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:ctrl animated:YES completion:^{
            //
        }];
    }];
}

- (void)didYLZoomImgSelected:(YLZoomImgCtrl *)ctrl Image:(UIImage *)image
{
    if (image)
    {
        UIView* view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
        UIView* vieww = [[UIView alloc] initWithFrame:view.bounds];
        vieww.backgroundColor = [UIColor blackColor];
        vieww.alpha = 0.5;
        vieww.userInteractionEnabled = NO;
        [view addSubview:vieww];
        
        UIImageView* imgview = [[UIImageView alloc] initWithFrame:view.bounds];
        imgview.backgroundColor = [UIColor clearColor];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        imgview.userInteractionEnabled = NO;
        [view addSubview:imgview];
        
        imgview.image = image;
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeZoomCtrlView:)];
        [view addGestureRecognizer:gesture];
        
        /*
        if (ImgGridOp_Add == [gridView operateType])
        {
            [gridView addItem:image DelImage:nil IsReload:YES];
        }
        else if (ImgGridOp_Edit == [gridView operateType])
        {
            [gridView updateCurCell:image];
        }
        */ 
    }
    
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}

- (void)ylimageEditView:(YLImageEditView *)view DidCropImage:(UIImage *)image
{
    if (image)
    {
        UIView* view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
        UIView* vieww = [[UIView alloc] initWithFrame:view.bounds];
        vieww.backgroundColor = [UIColor blackColor];
        vieww.alpha = 0.5;
        vieww.userInteractionEnabled = NO;
        [view addSubview:vieww];
        
        UIImageView* imgview = [[UIImageView alloc] initWithFrame:view.bounds];
        imgview.backgroundColor = [UIColor clearColor];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        imgview.userInteractionEnabled = NO;
        [view addSubview:imgview];
        
        imgview.image = image;
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeZoomCtrlView:)];
        [view addGestureRecognizer:gesture];
        
        /*
         if (ImgGridOp_Add == [gridView operateType])
         {
         [gridView addItem:image DelImage:nil IsReload:YES];
         }
         else if (ImgGridOp_Edit == [gridView operateType])
         {
         [gridView updateCurCell:image];
         }
         */
    }
    
    [view removeFromSuperview];
}

- (void)hiddeZoomCtrlView:(UIGestureRecognizer*)sender
{
    [sender.view removeFromSuperview];
}

- (void)imagePreviewGrid:(ImagePreviewGrid *)view SelectedCell:(ImagePreviewCell *)cell OpType:(ImgGridOpType)optype
{
    if (ImgGridOp_Remove != optype)
    {
        CGSize winsize = [UIScreen mainScreen].bounds.size;
        winsize.height *= 0.6;
        YLZoomImgCtrl* ctrl = [[YLZoomImgCtrl alloc] initWithImage:[UIImage imageNamed:@"image.jpg"] ClipSize:winsize];
        ctrl.delegate = self;
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}

- (void)ylInputView:(YLInputView *)inputview didcontenSizeChanged:(CGSize)contentsize
{
    NSLog(@"ContentSize: (%f, %f)", contentsize.width, contentsize.height);
    CGRect frame = inputview.frame;
    frame.size = contentsize;
    inputview.frame = frame;
}

- (void)GCDTimer
{
    //获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1 * NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        
        NSLog(@"timer!!!");

    });

    dispatch_resume(timer);
}

@end
