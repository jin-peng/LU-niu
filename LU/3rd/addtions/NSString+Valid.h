//
//  NSString+Valid.h
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

/** 是否为中文 */
- (BOOL)isChinese;
/** 是否匹配一个正则表达式 */
- (BOOL)isMatchsRegex:(NSString *)regex;
/** 空白字符串，包含nil */
+ (BOOL)isBlank:(NSString *)string;
+ (BOOL)isNotBlank:(NSString *)string;
/** 空白字符串 */
- (BOOL)isBlank;
- (BOOL)isNotBlank;

@end
