//
//  FileModel.h
//  QQCar
//
//  Created by yilong zhang on 2017/1/11.
//  Copyright © 2017年 qqcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLFileModel : NSObject

@property(nonatomic, strong) NSString*      name;
@property(nonatomic, strong) NSString*      path;
@property(nonatomic, strong) NSString*      thumbnailPath;
@property(nonatomic, strong) NSString*      exName;
/// 0 - 文件， 1 - 目录
@property(nonatomic, assign) NSInteger      type;
@property(nonatomic, strong) UIImage*       icon;
@property(nonatomic, assign) NSInteger      size;
@property(nonatomic, assign) BOOL           isExistThumbnail;
@property(nonatomic, assign) UIImageView*   imageV;

@end
