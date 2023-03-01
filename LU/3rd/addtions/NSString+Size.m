//
//  NSString+Size.m
//
//  Created by wangzhiming on 14-11-26.
//  Copyright (c) 2014年 wangzhiming. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font {
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    return [self sizeWithAttributes:@{NSFontAttributeName : font} maxSize:size];
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs maxSize:(CGSize)size {
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [self boundingRectWithSize:size
                                     options:option
                                  attributes:attrs
                                     context:nil];
    return rect.size;
}

@end
