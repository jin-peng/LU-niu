//
//  UIImage+Resize.m
//
//  Created by Mrng on 14-5-11.
//  Copyright (c) 2014年 Mrng. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

/** 创建一张纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color
                    forSize:(CGSize)size
                     radius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor {
    
    CGRect rect = {CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 处理边框
    if (borderWidth > 0.0 && borderColor) {
        rect.size.width -= borderWidth;
        rect.size.height -= borderWidth;
        rect.origin.x += borderWidth * 0.5;
        rect.origin.y += borderWidth * 0.5;
        
        if (radius > 0.0) {
            CGFloat maxRagius = rect.size.width * 0.5;
            radius = radius > maxRagius ? maxRagius : radius;
        }
    }
    
    // 矩形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, rect, radius, radius);
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    
    // 绘制
    [color setFill];
    if (borderWidth > 0.0 && borderColor) {
        [borderColor setStroke];
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    } else  {
        CGContextDrawPath(ctx, kCGPathFill);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 得到一张可拉伸的图片 */
+ (UIImage *)resizableImageByCenter:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

/** 缩小图片，添加圆角效果 */
- (UIImage *)scaleWithSize:(CGSize)size radius:(CGFloat)radius {
    return [UIImage scaleImage:self forSize:size radius:radius];
}

/** 缩小图片，添加圆角效果 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size radius:(CGFloat)radius {
    return [self scaleImage:image forSize:size radius:radius borderWidth:0.0 borderColor:nil];
}

/** 缩小图片，添加边框 */
- (UIImage *)scaleWithSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [UIImage scaleImage:self forSize:size borderWidth:borderWidth borderColor:borderColor];
}

/** 缩小图片，添加边框 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [self scaleImage:image forSize:size radius:0.0 borderWidth:borderWidth borderColor:borderColor];
}

/** 缩小图片，添加圆角和边框 */
- (UIImage *)scaleWithSize:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [UIImage scaleImage:self forSize:size radius:radius borderWidth:borderWidth borderColor:borderColor];
}

/** 缩小图片，添加圆角和边框 */
+ (UIImage *)scaleImage:(UIImage *)image forSize:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 内容区域
    CGRect contentRect = rect;
    
    // 边框
    if (borderWidth > 0.0 && borderColor) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRoundedRect(path, NULL, rect, radius, radius);
        CGContextAddPath(ctx, path);
        CGPathRelease(path);
        
        [borderColor setFill];
        CGContextFillPath(ctx);
        
        contentRect.size.width -= borderWidth * 2;
        contentRect.size.height -= borderWidth * 2;
        contentRect.origin.x += borderWidth;
        contentRect.origin.y += borderWidth;
        
        if (radius > 0.0) {
            CGFloat maxRagius = contentRect.size.width * 0.5;
            radius = radius > maxRagius ? maxRagius : radius;
        }
    }
    
    // 矩形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, contentRect, radius, radius);
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    CGContextClip(ctx);
    
    // 绘制图片
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/** 缩小图片 */
- (UIImage *)scaleWithSize:(CGSize)size {
    return [UIImage scaleWithImage:self forSize:size];
}

/** 缩小图片 */
+ (UIImage *)scaleWithImage:(UIImage *)image forSize:(CGSize)size {
    return [self scaleImage:image forSize:size radius:0.0];
}

/** 为图片添加圆角效果 */
- (UIImage *)roundedRectWithRadius:(CGFloat)radius {
    return [UIImage roundedRectWithImage:self forRadius:radius];
}

/** 为图片添加圆角效果 */
+ (UIImage *)roundedRectWithImage:(UIImage *)image forRadius:(CGFloat)radius {
    return [self scaleImage:image forSize:image.realSize radius:radius];
}

/** 为图片添加边框 */
- (UIImage *)borderWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [UIImage borderWithImage:self borderWidth:borderWidth borderColor:borderColor];
}

/** 为图片添加边框 */
+ (UIImage *)borderWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [self scaleImage:image forSize:image.realSize borderWidth:borderWidth borderColor:borderColor];
}

/** 按最大尺寸等比例缩小图片 */
- (UIImage *)scaleBySomeProportion:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    return [UIImage scaleBySomeProportionWithImage:self maxWidth:maxWidth maxHeight:maxHeight];
}

/** 按最大尺寸等比例缩小图片 */
+ (UIImage *)scaleBySomeProportionWithImage:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    
    CGSize size = image.realSize;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (width <= maxWidth && height <= maxHeight) {
        return image;
    }
    
    // (宽或高超出限定值)需要缩放
    if (width > maxWidth || height > maxHeight) {
        CGFloat widthScale = maxWidth / width;
        CGFloat heightScale = maxHeight / height;
        CGFloat scale = widthScale < heightScale ? widthScale : heightScale;
        
        width *= scale;
        height *= scale;
        size.width = width;
        size.height = height;
    }
    
    // 压缩图片
    return [image scaleWithSize:size];
}

/** 裁剪图片 */
- (UIImage *)cutAtRect:(CGRect)rect {
    return [UIImage cutWithImage:self atRect:rect];
}

/** 裁剪图片 */
+ (UIImage *)cutWithImage:(UIImage *)image atRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage* subImage = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return subImage;
}

/** px尺寸 */
- (CGSize)realSize {
    CGFloat width = self.size.width * self.scale;
    CGFloat height = self.size.height * self.scale;
    return CGSizeMake(width, height);
}

- (NSString *)fileSize {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    //    NSData *data = UIImagePNGRepresentation(self);
    
    // KB
    CGFloat size  = data.length / 1024.0;
    NSString *unit = @"KB";
    
    // MB
    if (size > 1024.0) {
        size /= 1024.0;
        unit = @"MB";
    }
    
    // GB
    if (size > 1024.0) {
        size /= 1024.0;
        unit = @"GB";
    }
    
    NSString *fileSize = [NSString stringWithFormat:@"（%.1f%@）", size, unit];
    return fileSize;
}

@end
