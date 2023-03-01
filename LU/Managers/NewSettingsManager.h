//
//  SettingsManager.h
//  ChinaNews
//
//  Created by JinPeng on 2016/11/19.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewSettingsManager : NSObject

+ (NSDictionary *)getGeneralParameters;
+ (NSDictionary *)postParameters:(NSDictionary *)baseParameter
                          action:(NSString *)action;
+ (NSString *)URLStringWithServerInterface:(NSString *)serverInterface;
+ (NSString *)getUrlStringWithParam:(NSString *)baseURL prarm:(NSDictionary *)paramDict;
+ (NSString *)encodeBase64:(NSString *)input;
+ (NSString *)applicationServerURL;
@end
