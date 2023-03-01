//
//  CHFinishedTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/6/22.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHFinishedTableViewCell.h"

@implementation CHFinishedTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)makeCellUI{
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.yingkui];
    [self.contentView addSubview:self.num];
    [self.contentView addSubview:self.pay];
//    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, 0, MAINWIDTH, .5) bgColor:UIColorFromRGB(0xcfcfcf)];
//    [_name addSubview:line];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(15, 0, MAINWIDTH - 30, 45) Font:16 Text:@""];
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(_name.width - 140, 0, 140, _name.height) Font:13 Text:@"T+1       > "];
        lb.tag = 201;
        lb.textAlignment = NSTextAlignmentRight;
        lb.textColor = UIColorFromRGB(0x999999);
        [_name addSubview:lb];
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _name.height - .5, MAINWIDTH, .5) bgColor:UIColorFromRGB(0xcfcfcf)];
        [_name addSubview:line];
    }
    return _name;
}

- (UILabel *)time{
    if (!_time) {
        _time = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y + _name.height, _name.width/2.0 - 20, 35) Font:13 Text:@""];
        _time.textColor = UIColorFromRGB(0x666666);
    }
    return _time;
}

- (UILabel *)yingkui{
    if (!_yingkui) {
        _yingkui = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _name.y + _name.height, _name.width/2.0,  35) Font:13 Text:@""];
        _yingkui.textColor = UIColorFromRGB(0x666666);
    }
    return _yingkui;
}

- (UILabel *)num{
    if (!_num) {
        _num = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _time.y + _time.height, _name.width/2.0 - 20, 35) Font:13 Text:@""];
        _num.textColor = UIColorFromRGB(0x666666);
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _num.y + _num.height , MAINWIDTH, 5) bgColor:UIColorFromRGB(0xcfcfcf)];
        [_name addSubview:line];
    }
    return _num;
}

- (UILabel *)pay{
    if (!_pay) {
        _pay = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _yingkui.y + _yingkui.height, _name.width/2.0,  35) Font:13 Text:@""];
        _pay.textColor = UIColorFromRGB(0x666666);
        
    }
    return _pay;
}
     
- (void)setCellWithDic:(NSDictionary *)dic{
    /*"market_value" = "13581.00";
     "order_no" = 20190622084646925;
     "sell_code" = 1561356136229;
     "sell_price" = "11.970";
     "sell_total_price" = "10773.0";
     "stock_code" = sh600000;
     "stock_count" = 900;  */
    
    _name.text = [NSString stringWithFormat:@"%@(%@)",dic[@"stock_name"],dic[@"stock_code"]];
    _time.text = [NSString stringWithFormat:@"持仓天数    %d天",[dic[@"day"] integerValue]];
    _yingkui.text = [NSString stringWithFormat:@"策略盈亏    %.2f",[dic[@"sell_total_price"] floatValue] - [dic[@"market_value"] floatValue]];
    _num.text = [NSString stringWithFormat:@"交易数量    %d股",[dic[@"stock_count"] integerValue]];
    _pay.text = [NSString stringWithFormat:@"亏损赔付    0元"];
    
}

- (void)setWaitingCellWithDic:(NSDictionary *)dic{
    UILabel * lb = (UILabel *)[self.contentView viewWithTag:201];
//    lb.hidden = YES;
    NSInteger x = [dic[@"status"] integerValue];
    NSString * statusStr = nil;
       switch (x) {
           case 3:
               statusStr = @"买入等待中";
               break;
          case 4:
               statusStr = @"卖出等待中";
               break;
          case 5:
               statusStr = @"买入等待中";
               break;
          case 6:
               statusStr = @"卖出等待中";
               break;
          case 10:
               statusStr = @"已流单";
               break;
               
        
           default:
               break;
       }
    lb.text = statusStr;
    
    _name.text = [NSString stringWithFormat:@"%@(%@)",dic[@"stock_name"],dic[@"stock_code"]];
    _time.text = [NSString stringWithFormat:@"时间:%@",dic[@"time"] ];
    _yingkui.text = [NSString stringWithFormat:@"单号:%@",dic[@"order_no"]];
    _num.text = [NSString stringWithFormat:@"数量:%d股",[dic[@"stock_count"] integerValue]];
    _pay.text = [NSString stringWithFormat:@"保证金:%.2f元",[dic[@"dongjie"] floatValue]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
