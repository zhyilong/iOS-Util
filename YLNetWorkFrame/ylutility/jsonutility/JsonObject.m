//
//  JsonObject.m
//  WisdomSchoolBadge
//
//  Created by jack on 15/6/18.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "JsonObject.h"

@implementation JsonObject

- (NSString*)toJson
{
    NSError* err=nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.toDictionary options:NSJSONWritingPrettyPrinted error:&err];
    
    if ([jsonData length] > 0 && err == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        return jsonString;
    }
    else
    {
        return nil;
    }
}

- (instancetype)initFromJson:(NSString*)json
{
    self = [super init];
    if(!self || json==nil) return nil;
    
    NSError *error = nil;
    NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil)
    {
        return [self initWithDictionary:jsonObject];
    }
    else
    {
        // 解析错误
        return nil;
    }
}

- (instancetype)initFromData:(NSData*)data
{
    self = [super init];
    if(!self || data == nil) return nil;
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil)
    {
        return [self initWithDictionary:jsonObject];
    }
    else
    {
        // 解析错误
        return nil;
    }
}

@end
