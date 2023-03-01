//
//  stockTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/4/18.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface stockTableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel * nameLb;
@property (nonatomic ,strong)UILabel * numLb;
@property (nonatomic ,strong)UILabel * priceLb;
@property (nonatomic ,strong)UILabel * perLb;

@property (nonatomic ,strong)void (^addTocollect)(NSString * ,NSDictionary *,BOOL);
- (void)makeCellUI;

- (void)setCellWithDic:(NSDictionary *)dic price:(NSDictionary *)priceDic;


@end

NS_ASSUME_NONNULL_END
