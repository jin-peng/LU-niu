//
//  CHPlanTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/6/12.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHPlanTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UILabel * yingkui;
@property (nonatomic,strong) UILabel * num;
@property (nonatomic,strong) UILabel * pay;

- (void)creatUI;
//- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
