//
//  CHSearchTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/4/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHSearchTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIButton * selectBtn;
@property (nonatomic ,strong)UILabel * nameLb;
@property (nonatomic ,strong)UILabel * numLb;
@property (nonatomic ,strong)UIButton * addBtn;
@property (nonatomic ,strong)NSString * stockID;
@property (nonatomic ,strong)NSDictionary * dic;
@property (nonatomic)BOOL x;
@property (nonatomic,strong)void (^addTocollect)(NSString * ,NSDictionary *,BOOL);
- (void)makeCellUIWithSelect;
- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
