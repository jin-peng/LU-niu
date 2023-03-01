//
//  CHConfig.m
//  LU
//
//  Created by peng jin on 2019/4/19.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHConfig.h"

@implementation CHConfig

+ (NSString *)hotPhoneNumber{
    return [CNManager loadByKey:HOTPHONE]?:@"";
}

+ (NSString *)helpPage{
   return [CNManager loadByKey:HELPPAGE]?:@"";
}

+ (NSString *)attentionPage{
    return [CNManager loadByKey:ATTENTIONPAGE]?:@"";
}

+ (NSString *)regHelpPage{
    return [CNManager loadByKey:REGHELPPAGE]?:@"";
}

+ (NSString *)planAgreement{
    return [CNManager loadByKey:PLANAGREEMENT]?:@"";
}

@end
