//
//  ARCommUtils.h
//  AnyRadio
//
//  Created by 罗 泽锋 on 14-3-20.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import  <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@interface ARCommUtils : NSObject


// 图像处理，反色
+(UIImage*) grayscale:(UIImage*)anImage type:(char)type;

+(NSString*) getCachePath;

+(NSMutableDictionary *)LoadDictFromFile:(NSString*)fileName;
+(BOOL)SaveDictToFile:(NSString*)fileName dict:(NSMutableDictionary*)dict;

+(BOOL)checkIsValidIp:(NSString*)ip;

//判断用户是否登录
+ (BOOL)isUserLogin;
//判断是否可收藏
+ (BOOL)isCollectEnable;

@end
