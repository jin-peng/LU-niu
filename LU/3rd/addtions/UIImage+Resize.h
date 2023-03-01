//
//  UIImage+Resize.h
//
//  Created by Mrng on 14-5-11.
//  Copyright (c) 2014年 Mrng. All rights reserved.
//
// 所有方法中的size参数请使用px

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/** 创建一张纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color
                    forSize:(CGSize)size
                     radius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor;

/** 得到一张可拉伸的图片 */
+ (UIImage *)resizableImageByCenter:(NSString *)imageName;

/** 缩小图片，添加圆角效果 */
- (UIImage *)scaleWithSize:(CGSize)size radius:(CGFloat)radius;

/** 缩小图片，添加圆角效果 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size radius:(CGFloat)radius;

/** 缩小图片，添加边框 */
- (UIImage *)scaleWithSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 缩小图片，添加边框 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 缩小图片，添加圆角和边框 */
- (UIImage *)scaleWithSize:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 缩小图片，添加圆角和边框 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 缩小图片 */
- (UIImage *)scaleWithSize:(CGSize)size;

/** 缩小图片 */
+ (UIImage *)scaleWithImage:(UIImage *)image forSize:(CGSize)size;

/** 为图片添加圆角效果 */
- (UIImage *)roundedRectWithRadius:(CGFloat)radius;

/** 为图片添加圆角效果 */
+ (UIImage *)roundedRectWithImage:(UIImage *)image forRadius:(CGFloat)radius;

/** 为图片添加边框 */
- (UIImage *)borderWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 为图片添加边框 */
+ (UIImage *)borderWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 按最大尺寸等比例缩小图片 */
- (UIImage *)scaleBySomeProportion:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

/** 按最大尺寸等比例缩小图片 */
+ (UIImage *)scaleBySomeProportionWithImage:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

/** 裁剪图片 */
- (UIImage *)cutAtRect:(CGRect)rect;

/** 裁剪图片 */
+ (UIImage *)cutWithImage:(UIImage *)image atRect:(CGRect)rect;

/** px尺寸 */
- (CGSize)realSize;

/** 获取文件大小 */
- (NSString *)fileSize;

@end
