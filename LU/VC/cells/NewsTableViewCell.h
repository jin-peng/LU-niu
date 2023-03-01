//
//  NewsTableViewCell.h
//  LU
//
//  Created by peng jin on 2019/4/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * newsImageView;
@property (nonatomic,strong)UIView * BGView;
@property (nonatomic,strong)UILabel * infoLabel;
@property (nonatomic,strong)NSString * ID;
@property (nonatomic,strong)UIView *view_LineView;//底线
@property (nonatomic,strong)NSDictionary * dataDic;
- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;
@end

