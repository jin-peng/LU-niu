//
//  NSString+Valid.m
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

-(BOOL)isChinese{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isMatchsRegex:(NSString *)regex {
    return [self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound;
}

- (BOOL)isBlank {
    return ![self isNotBlank];
}

- (BOOL)isNotBlank {
    return [self isMatchsRegex:RegexNotBlack];
}

+ (BOOL)isBlank:(NSString *)string {
    return !string || [string isKindOfClass:[NSNull class]] || [string isBlank];
}

+ (BOOL)isNotBlank:(NSString *)string {
    return ![self isBlank:string];
}

@end
