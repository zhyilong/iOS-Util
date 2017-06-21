//
//  JsonObject.h
//  WisdomSchoolBadge
//
//  Created by jack on 15/6/18.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "Jastor.h"
///**
// *  json结果协议
// */
//@protocol JsonObjectAns
//@optional
//-(bool) isSuccess;
//@end

/**
 *  json对象基类
 */
@interface JsonObject : Jastor


- (NSString*)toJson;
- (instancetype)initFromJson:(NSString*)json;
- (instancetype)initFromData:(NSData*)data;

@end
