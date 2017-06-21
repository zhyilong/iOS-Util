//
//  NSData+Utility.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/4/21.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utility)

//AES加密
- (NSData *)AES256ParmEncryptWithKey:(NSString *)key;

//AES解密
- (NSData *)AES256ParmDecryptWithKey:(NSString *)key;

//DES加密
- (NSData *)DESEncryptWithKey:(NSString *)key;

//DES解密
- (NSData *)DESDecryptWithKey:(NSString *)key;
@end
