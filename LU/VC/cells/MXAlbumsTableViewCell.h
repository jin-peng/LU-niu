//
//  MXAlbumsTableViewCell.h
//  mengX
//
//  Created by mengX on 15/9/26.
//  Copyright (c) 2015年 金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXAlbumsTableViewCell : UITableViewCell
{
    CGFloat  h;
}

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * buyLabel;
@property (nonatomic,strong)UIView * BGView;
@property (nonatomic,strong)UIButton * buyBtn;
@property (nonatomic,strong)NSString * ID;
@property (nonatomic,strong)UIView *view_LineView;//底线
@property (nonatomic,strong)NSDictionary * dataDic;
@property (nonatomic,strong)void (^pushToDetail)(NSString * );
- (void)makeCellUI;
- (void)setCellWithDic:(NSDictionary *)dic;
@end
