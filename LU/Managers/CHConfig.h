//
//  CHConfig.h
//  LU
//
//  Created by peng jin on 2019/4/19.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HOTPHONE @"hotPhone"
#define ATTENTIONPAGE @"attentionPage"
#define HELPPAGE    @"helpPage"
#define REGHELPPAGE @"regHelpPage"
#define PLANAGREEMENT        @"planAgreement"
NS_ASSUME_NONNULL_BEGIN

@interface CHConfig : NSObject
+ (NSString *)hotPhoneNumber;//热线电话
+ (NSString *)helpPage;//帮助
+ (NSString *)regHelpPage;//注册协议

+ (NSString *)attentionPage;//风险提示
+ (NSString *)planAgreement;//策略合作协议
@end

NS_ASSUME_NONNULL_END
