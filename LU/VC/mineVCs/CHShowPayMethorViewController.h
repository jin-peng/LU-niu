//
//  CHShowPayMethorViewController.h
//  LU
//
//  Created by peng jin on 2019/6/28.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHShowPayMethorViewController : BaseViewController

@property (nonatomic) NSInteger type;//0 银行卡 ，1 支付宝 2 微信
@property (nonatomic,strong) NSDictionary * infoDic;

@end

NS_ASSUME_NONNULL_END
