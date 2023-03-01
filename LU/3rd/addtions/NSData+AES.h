//
//  NSData+AES.h
//  MobileBusiness
//
//  Created by McMillen on 12-6-8.
//  Copyright (c) 2012年 Daoyoudao (Beijing) Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;

@end
