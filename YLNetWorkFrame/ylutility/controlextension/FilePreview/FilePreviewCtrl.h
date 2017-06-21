//
//  FilePreviewCtrl.h
//  QQCar
//
//  Created by yilong zhang on 2017/1/11.
//  Copyright © 2017年 qqcy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLFileModel.h"
#import "FilePreviewCell.h"

@class FilePreviewCtrl;

@protocol FilePreviewCtrlDelegate <NSObject>

@optional
- (void)filePreviewCtrl:(FilePreviewCtrl*)ctrl DidSelected:(YLFileModel*)file;
- (void)filePreviewCtrlCanceled:(FilePreviewCtrl*)ctrl;

@end

@interface FilePreviewCtrl : UIViewController <UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout,
                                               UIScrollViewDelegate,
                                               UIWebViewDelegate>

@property(nonatomic, weak) IBOutlet UIView*             topView;
@property(nonatomic, strong) UICollectionView*          collectionview;
@property(nonatomic, weak) id<FilePreviewCtrlDelegate>  delegate;
@property(nonatomic, assign) NSInteger                  fileMaxSize;

@property(nonatomic, strong) UIView*                    preView;
@property(nonatomic, strong) UIWebView*                 preWebView;

@property(nonatomic, strong) UIScrollView*              preScroll;
@property(nonatomic, strong) UIImageView*               preImgView;

@property(nonatomic, strong) UIButton*                  playBtn;

- (IBAction)OnBackDown:(UIButton*)sender;

@end
