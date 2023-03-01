//
//  CHBuy5kViewController.h
//  LU
//
//  Created by peng jin on 2019/11/15.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHBuy5kViewController : BaseViewController
@property (nonatomic,strong)NSDictionary * strckPriceDic;
@property (nonatomic,strong)NSDictionary * stockDic;
@property (nonatomic,strong)NSDictionary * userPlan;
@property (nonatomic)CGFloat       userLastMoney;
@end

NS_ASSUME_NONNULL_END
