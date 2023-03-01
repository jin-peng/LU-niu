//
//  ARCommUtils.m
//  AnyRadio
//
//  Created by 罗 泽锋 on 14-3-20.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import "ARCommUtils.h"
//#import "PlaybackEngine.h"

@implementation NSDictionary (compare)


@end

@implementation ARCommUtils

+ (long)getMinutes:(NSString *)time{
    NSArray *array = [time componentsSeparatedByString:@":"];
    if ([array count] == 2) {
        NSString *hour = [array objectAtIndex:0];
        NSString *minute = [array objectAtIndex:1];
        
        return [hour intValue] * 60 + [minute intValue];
    }
    return 0;
}

+ (UIImage*) grayscale:(UIImage*)anImage type:(char)type {
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            
            switch (type) {
                case 1://モノクロ
                    // 輝度計算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                    
                case 2://セピア
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.5;
                    *(tmp + 2) = blue * 0.4;
                    break;
                    
                case 3://色反転
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                    
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
            
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

+ (NSString*) getCachePath{
    return [NSString stringWithFormat:@"%@/Documents/ProtocolCaches", NSHomeDirectory()];
}

+ (NSMutableDictionary *)LoadDictFromFile:(NSString*)fileName{
    //    NSData *data = [NSData dataWithContentsOfFile:fileName];
    //    NSMutableDictionary *ret = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSError *error = nil;
    NSData *json = [NSData dataWithContentsOfFile:fileName];
    NSMutableDictionary *ret = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        //DLog(@" error: %@", error);
        ret = nil;
    }
    //DLog(@" ret: %d fileName: %@", ret!=nil, fileName);
    return ret;
}

+ (BOOL)SaveDictToFile:(NSString*)fileName dict:(NSMutableDictionary*)dict {
    //[NSKeyedArchiver archivedDataWithRootObject:dict];

    BOOL ret = NO;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
       // DLog(@" error: %@", error);
        ret = NO;
    } else {
        ret = [data writeToFile:fileName atomically:YES];
    }
    //DLog(@" ret :%d fileName: %@", ret, fileName);
    return ret;
}

+ (BOOL)checkIsValidIp:(NSString*)ip{
    
    return ip.length;
    NSInteger len = ip.length;
    if (len<7 || len>15)
        return NO;
    
    NSArray *ips = [ip componentsSeparatedByString:@"."];
    if ([ips count] != 4)
        return NO;
    for (int i=0;i<[ips count];i++) {
        NSString *p = [ips objectAtIndex:i];
        int c = [p intValue];
        if (c<0 || c>255)
            return NO;
    }
    return YES;
}


//判断用户是否登录
+ (BOOL)isUserLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *appLoginOK = [userDefaults objectForKey:@"AppLoginOK"];
    BOOL isLogin = NO;
    if ([appLoginOK intValue]==1) {
        isLogin = [appLoginOK boolValue];
    } else {
        isLogin = NO;
    }
    
    return isLogin;
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:@"需要登录才能下载"]&&buttonIndex == 0) {
        NSNotificationCenter *noticeCenter = [NSNotificationCenter defaultCenter];
        [noticeCenter postNotificationName:@"showLogin"
                                    object:self
                                  userInfo:nil];
    }
}

+ (BOOL)isCollectEnable
{
    return YES;
    
}

@end
