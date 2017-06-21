//
//  FileModel.m
//  QQCar
//
//  Created by yilong zhang on 2017/1/11.
//  Copyright © 2017年 qqcy. All rights reserved.
//

#import "YLFileModel.h"

@implementation YLFileModel

@synthesize name;
@synthesize path;
@synthesize exName;
@synthesize type;
@synthesize icon;
@synthesize isExistThumbnail;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        isExistThumbnail = NO;
    }
    
    return self;
}

@end
