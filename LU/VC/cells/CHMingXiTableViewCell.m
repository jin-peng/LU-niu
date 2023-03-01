//
//  CHMingXiTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/6/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHMingXiTableViewCell.h"

@implementation CHMingXiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)makeCellUI{
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.zhuangtai];
    [self.contentView addSubview:self.num];
    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _time.y + _time.height + 5, MAINWIDTH, .5) bgColor:UIColorFromRGB(0xcfcfcf)];
    [self.contentView addSubview:line];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(10, 10, 200., 20) Font:12 Text:@""];
        _name.textColor = UIColorFromRGB(0x666666);
    }
    return _name;
}

- (UILabel *)time{
    if (!_time) {
        _time = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y+_name.height+ 5, 120, 20) Font:10 Text:@""];
        _time.textColor = UIColorFromRGB(0x999999);
    }
    return _time;
}

- (UILabel *)zhuangtai{
    if (!_zhuangtai) {
        _zhuangtai = [JPMyControl createLabelWithFrame:CGRectMake(_time.x + _time.height + 38 , _name.y + 1, 50, 16) Font:12 Text:@"充值成功"];
        _zhuangtai.backgroundColor = [UIColor redColor];
        _zhuangtai.textColor = [UIColor whiteColor];
        _zhuangtai.textAlignment = NSTextAlignmentCenter;
    }
    return _zhuangtai;
}

- (UILabel *)num{
    if (!_num) {
        _num = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _zhuangtai.y, MAINWIDTH/2 - 15, 14) Font:14 Text:@"2000.00"];
        _num.textAlignment = NSTextAlignmentRight;
        _num.textColor = [UIColor redColor];
    }
    return _num;
}

- (void)setCellWithDic:(NSDictionary *)dic showTag:(NSInteger)x{
    NSString * str = @"";
    _zhuangtai.hidden = x!=2;
    NSString * time = @"";
    switch (x) {
        case 0://收入
            str = [NSString stringWithFormat:@"股票平仓卖出%@%@",dic[@"stock_name"],dic[@"code"]];
//            _name.text = str;
            time = dic[@"time"];
//            _time.text = dic[@"sell_time"];
            _num.text = [NSString stringWithFormat:@"%@", dic[@"money"]];
            break;
        case 1://支出
            {
                NSInteger n = [dic[@"status"] integerValue];
                switch (n) {
                    case 2:
                    {
                        NSInteger m = [dic[@"type"] integerValue];
                        if (m == 4) {
                            str = [NSString stringWithFormat:@"买入T+1股票%@管理费",dic[@"code"]];
                        }else if (m == 1){
                            str = [NSString stringWithFormat:@"买入T+1股票%@%@",dic[@"code"],dic[@"stock_name"]];
                        }else if (m == 8){
                            str = [NSString stringWithFormat:@"股票%@%@补亏",dic[@"code"],dic[@"stock_name"]];
                        }
                        
                    }
                        break;
                    case 11:
                        str = [NSString stringWithFormat:@"股票%@%@递延费",dic[@"code"],dic[@"stock_name"]];
                        break;
                    default:
                        break;
                }
            }
//            str = [NSString stringWithFormat:@"买入T+1股票%@%@",dic[@"code"],dic[@"stock_name"]];
            time = dic[@"time"];
//            _name.text = str;
//            _time.text = dic[@"sell_time"];
            _num.text = [NSString stringWithFormat:@"-%.2f", [dic[@"money"] doubleValue]];
            break;
        case 2://充值
        {
            NSInteger y = [dic[@"pay_type"] integerValue];
            str = y ==1?@"支付宝":(y==2?@"银行转账":@"微信支付");
            NSInteger z = [dic[@"status"] integerValue];
            if (!z) {
                _zhuangtai.text = @"审核中";
                _zhuangtai.backgroundColor = [UIColor orangeColor];
            }else if(z == 1){
                _zhuangtai.text = @"充值成功";
            }else if(z == 2)
                _zhuangtai.text = @"充值失败";
                
            time = [CNManager setShowTime:[dic[@"pay_time"] doubleValue]];
            _num.text = [NSString stringWithFormat:@"+%@", dic[@"pay_num"]];
        }
            break;
        case 3://提现
        {
            time = dic[@"tx_time"];
            NSInteger z = [dic[@"status"] integerValue];
            if (!z) {
                str = @"审核中";
                
            }else if(z == 1){
                str = @"提现成功";
            }else if(z == 2)
                str = @"提现失败";
            _num.text = [NSString stringWithFormat:@"-%@", dic[@"tx_money"]];
        }
            break;
        default:
            break;
            
    }
    _name.text = str;
    _time.text = time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
