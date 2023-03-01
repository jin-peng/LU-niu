//
//  CHBuyStockViewController.h
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHBuyStockViewController : BaseViewController
//@property (nonatomic,strong)NSString * stockNO;
//@property (nonatomic,strong)NSString * storkNO2;
@property (nonatomic,strong)NSDictionary * strckPriceDic;
@property (nonatomic,strong)NSDictionary * stockDic;
@property (nonatomic,strong)NSDictionary * userPlan;
@property (nonatomic)CGFloat       userLastMoney;
@end

NS_ASSUME_NONNULL_END
