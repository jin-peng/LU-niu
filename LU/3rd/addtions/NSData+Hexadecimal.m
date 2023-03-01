//
//  NSData+Hexadecimal.m
//  MobileBusiness
//
//  Created by McMillen on 12-6-7.
//  Copyright (c) 2012年 Daoyoudao (Beijing) Technology Co., Ltd. All rights reserved.
//

#import "NSData+Hexadecimal.h"

@implementation NSData (Hexadecimal)

- (NSString *)hexadecimalString
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
