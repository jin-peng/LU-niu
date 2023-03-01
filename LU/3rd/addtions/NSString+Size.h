//
//  NSString+Size.h
//
//  Created by wangzhiming on 14-11-26.
//  Copyright (c) 2014年 wangzhiming. All rights reserved.
//
// 计算文字尺寸

#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font;
// NSString(NSStringDrawing)中已有此方法
// - (CGSize)sizeWithAttributes:(NSDictionary *)attrs;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs maxSize:(CGSize)size;

@end
