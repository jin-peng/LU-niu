//
//  SettingsManager.m
//  ChinaNews
//
//  Created by JinPeng on 2016/11/19.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "NewSettingsManager.h"
#import "GTMBase64.h"
@implementation NewSettingsManager

+ (NSDictionary * )getGeneralParameters{
    
    return [SettingsManager getGeneralParameters];
    
    NSDictionary * dic = @{@"ce" : @"",
                           @"ci" : @"6001",
                           @"co" : @"",
                           @"cr" : @"",
                           @"ct" : @"",
                           @"ds" : @"5001",
                           @"la" : @"",
                           @"lc" : @"",
                           @"lg" : [[NSUserDefaults standardUserDefaults]objectForKey:@"lg"],
                           @"ln" : @"",
                           @"lo" : @"",
                           @"m2" : @"f33d75b5a52f957656cfeb8ab86da52b51c5835d",
                           @"me" : @"2E7B4E72-C75F-44F1-9BB5-EACA412CF96F",
                           @"ms" : @"",
                           @"nt" : @"unknown",
                           @"ov" : @"ios10.0",
                           @"pn" : @"",
                           @"pr" : @"",
                           @"sd" : @"cloudApp",
                           @"sh" : [NSNumber numberWithFloat:MAINHEIGHT],
                           @"si" : @"8085",
                           @"so" : @"portrait",
                           @"st" : @"",
                           @"sw" : [NSNumber numberWithFloat:MAINWIDTH],
                           @"tb" : @"apple",
                           @"tm" : @"x86_64",
                           @"tv" : @"10.0",
                           @"ui" : @"",
                           @"un" : @"",
                           @"up" : @"",
                           @"vc" : @"0001",
                           @"vi" : @"7001",
                           @"vn" : @"1.0.0",
                           @"wm" : @"9C:F3:87:BE:87:CE",
                           };
    return dic;
}

/** 生成POST请求参数 */
+ (NSDictionary *)postParameters:(NSDictionary *)baseParameter
                          action:(NSString *)action {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:[NewSettingsManager getGeneralParameters]];
    if (baseParameter.count) {
        [parameters addEntriesFromDictionary:baseParameter];
    }
    NSString *dataStringEncoded = [self getUrlStringWithParam:nil prarm:parameters].URLDecodedString;
    NSDictionary *newParams = @{@"data": [self encodeBase64:dataStringEncoded],
                                @"action" : action,
                                @"verf" : [dataStringEncoded md5],
                                @"pv" : @"3",
                                @"format" : @"json"};
    return newParams;
}

/** 根据接口生成URLString */
+ (NSString *)URLStringWithServerInterface:(NSString *)serverInterface {
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/%@", [NewSettingsManager applicationServerURL], serverInterface];
    return URLString;
}

+ (NSString *)getUrlStringWithParam:(NSString *)baseURL prarm:(NSDictionary *)paramDict
{
    
    NSString *retURL = (baseURL == nil? @"" : [baseURL stringByAppendingString:@"?"]);
    
    for (NSString *key in paramDict.allKeys)
    {
        if ([[paramDict objectForKey:key] isKindOfClass:[NSString class]])
        {
            retURL = [retURL stringByAppendingFormat:@"%@=%@&", key, [paramDict objectForKey:key]];
        }
        else if ([[paramDict objectForKey:key] isKindOfClass:[NSNumber class]])
        {
            retURL = [retURL stringByAppendingFormat:@"%@=%@&", key, [paramDict objectForKey:key]];
        }
        else if ([[paramDict objectForKey:key] isKindOfClass:[NSArray class]])
        {
            retURL = [retURL stringByAppendingFormat:@"%@=%@&", key, [[paramDict objectForKey:key] componentsJoinedByString:@","]];
        }
        else if ([paramDict objectForKey:key] == nil)
        {
            retURL = [retURL stringByAppendingFormat:@"%@=&", key];
        }
    }
    
    if ([retURL hasSuffix:@"&"])
    {
        retURL = [retURL substringToIndex:[retURL length]-1];
    }
    
    return retURL;
}
+ (NSString *)encodeBase64:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    Byte *byte = (Byte *)[data bytes];
    char chKey = 0x6e;
    int i;
    for (i = 0; i < [data length]; i++) {
        byte[i] = byte[i] ^ chKey;
    }
    
    NSData *data1 = [[NSData alloc] init];
    
    data1 = [GTMBase64 encodeBytes:byte length:i];
    
    NSString *base64String = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString *)applicationServerURL
{
    return SERVER;
//    [[SettingsManager sharedSettingsManager] applicationServerURL];
    
}

@end
