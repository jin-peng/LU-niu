//
//  CHMyPlanTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/6/22.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHMyPlanTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel * name;
@property (nonatomic , strong) UILabel * dayNum;

@property (nonatomic , strong) UILabel * priceLb;

@property (nonatomic , strong) UILabel * zyLb;
//@property (nonatomic , strong) UILabel * zsLb;

@property (nonatomic , strong) UILabel * stockNum;

@property (nonatomic , strong) UILabel * fenhong;
//@property (nonatomic , strong) UILabel * bukui;

@property (nonatomic , strong) UILabel * chengjiaoTime;
@property (nonatomic , strong) UILabel * timeLb;

@property (nonatomic , strong) UILabel * celueNo;
@property (nonatomic , strong) UILabel * NOLb;

@property (nonatomic , strong) UILabel * dytj;
@property (nonatomic , strong) UILabel * dyNum;

@property (nonatomic , strong) UILabel * fudong;
@property (nonatomic , strong) UILabel * fudongNum;

@property (nonatomic , strong) UIButton * setPlanBtn;
@property (nonatomic , strong) UIButton * sellBtn;
@property (nonatomic , strong) UIButton * supplyBtn;

@property (nonatomic) CGFloat nowPrice;
@property (nonatomic) CGFloat buyPrice;
@property (nonatomic) CGFloat flowValue;
@property (nonatomic) CGFloat stopLoss;
@property (nonatomic) CGFloat stopProfit;

@property (nonatomic) CGFloat nowStopProfit;
@property (nonatomic) CGFloat nowStopLoss;

@property (nonatomic , strong) NSString * planID;

@property (nonatomic,strong)void (^addTocollect)(NSString * , NSInteger , CGFloat ,CGFloat,CGFloat,CGFloat,CGFloat,CGFloat);
//- (void)makeCellUIWithSelect;
- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic :(CGFloat)price;

@end

NS_ASSUME_NONNULL_END
