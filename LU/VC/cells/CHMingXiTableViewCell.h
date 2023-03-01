//
//  CHMingXiTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/6/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHMingXiTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UILabel * zhuangtai;
@property (nonatomic,strong) UILabel * num;

- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic showTag:(NSInteger)x;

@end

NS_ASSUME_NONNULL_END
