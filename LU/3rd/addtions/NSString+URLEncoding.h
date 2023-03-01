//
//  NSString+URLEncoding.h
//  APIKit
//
//  Created by McMillen on 2/13/14.
//  Copyright (c) 2014 McMillen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString *)playbackEncodedString;
- (NSString *)URLDecodedString64;

@end
