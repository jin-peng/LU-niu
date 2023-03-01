//
//  NSString+randomGenerator.m
//  MobileBusiness
//
//  Created by McMillen on 12-6-14.
//  Copyright (c) 2012年 Daoyoudao (Beijing) Technology Co., Ltd. All rights reserved.
//

#import "NSString+randomGenerator.h"

@implementation NSString (randomGenerator)

+ (NSString *)genRandomStringForLength:(NSInteger)len
{

    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
