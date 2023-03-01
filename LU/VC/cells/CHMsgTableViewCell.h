//
//  CHMsgTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/7/8.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHMsgTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UILabel * msg;
@property (nonatomic,strong) UIView  * backView;
//@property (nonatomic,strong) UILabel * num;

- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
