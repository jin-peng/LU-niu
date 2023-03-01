//
//  CHStockDetailViewController.h
//  LU
//
//  Created by peng jin on 2019/4/26.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHStockDetailViewController : BaseViewController
@property (nonatomic , strong)UIWebView * newsWebView;
@property (nonatomic,strong) NSString * detailID;
@property (nonatomic,strong) NSString * urlString;
@property (nonatomic,strong) NSString * stockID;
@property (nonatomic,strong) NSDictionary * stockDic;
//@property (nonatomic,strong) NSString * chTitile;
@end

NS_ASSUME_NONNULL_END
