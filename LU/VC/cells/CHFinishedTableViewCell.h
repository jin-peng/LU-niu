//
//  CHFinishedTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/6/22.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHFinishedTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UILabel * yingkui;
@property (nonatomic,strong) UILabel * num;
@property (nonatomic,strong) UILabel * pay;

- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;
- (void)setWaitingCellWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
