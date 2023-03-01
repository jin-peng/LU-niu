//
//  CHGetStockNum.h
//  LU
//
//  Created by peng jin on 2019/6/4.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CHGetStockNum : NSObject

+ (void)getDetailStocks:(NSArray *)stocksNums Success:(void (^)(NSArray *array))success;

+ (void)getStocks:(NSArray *)stocksNums Success:(void (^)(NSArray *array))success;

+ (void)getMarketIndexesSuccess:(void (^)(NSArray *array))success;

+ (void)getShotMessage:(NSString *)phone type:(NSInteger)type Success: (void (^)(NSString * meg))success;

+ (void)getUserInfobyPhone:(NSString *)phone;
+ (void)getUserInfobyPhone:(NSString *)phone Success:(void (^)(NSDictionary * userDic))success;

+ (void)getStock:(NSString *)stocksNum Success:(void (^)(NSDictionary *stockDic))success;

+ (void)getUserPlan:(NSString *)phone Success:(void (^)(NSDictionary *planDic))success;

+ (void)getUserPlanSuccess:(void (^)(NSDictionary *planDic))success;
@end

NS_ASSUME_NONNULL_END
