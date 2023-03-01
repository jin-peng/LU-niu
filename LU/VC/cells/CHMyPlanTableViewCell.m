//
//  CHMyPlanTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/6/22.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHMyPlanTableViewCell.h"

@implementation CHMyPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)makeCellUI{
    
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.dayNum];
    
    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _name.y + _name.height - .5, MAINWIDTH, .5) bgColor:UIColorFromRGB(0x999999)];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.priceLb];
    
    [self.contentView addSubview:self.zyLb];
//    [self.contentView addSubview:self.zsLb];
    
    [self.contentView addSubview:self.stockNum];
    
    [self.contentView addSubview:self.fenhong];
//    [self.contentView addSubview:self.bukui];
    
    [self.contentView addSubview:self.chengjiaoTime];
    [self.contentView addSubview:self.timeLb];
    
    [self.contentView addSubview:self.celueNo];
    [self.contentView addSubview:self.NOLb];
    
    [self.contentView addSubview:self.dytj];
    [self.contentView addSubview:self.dyNum];
    
    [self.contentView addSubview:self.fudong];
    [self.contentView addSubview:self.fudongNum];
    
    [self.contentView addSubview:self.setPlanBtn];
    [self.contentView addSubview:self.sellBtn];
    [self.contentView addSubview:self.supplyBtn];
    
    UIView * line2 = [JPMyControl createViewWithFrame:CGRectMake(0, _sellBtn.y + _sellBtn.height + 10, MAINWIDTH , 6) bgColor:UIColorFromRGB(0xdfdfdf)];
    [self.contentView addSubview:line2];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(20, 0, MAINWIDTH/2-20., 40) Font:14 Text:@""];
    }
    return _name;
}

- (UILabel *)dayNum{
    if (!_dayNum) {
        _dayNum = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2. , _name.y + 1  , MAINWIDTH/2-20., 40) Font:13 Text:@""];
        _dayNum.textAlignment = NSTextAlignmentRight;
    }
    return _dayNum;
}

- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y+_name.height + 1, MAINWIDTH, 35) Font:12 Text:@""];
        _priceLb.textColor = UIColorFromRGB(0x999999);
    }
    return _priceLb;
}

- (UILabel *)zyLb{
    if (!_zyLb) {
        _zyLb = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _priceLb.y + _priceLb.height , MAINWIDTH , 30) Font:12 Text:@""];
        _zyLb.textColor = UIColorFromRGB(0x999999);
    }
    return _zyLb;
}

- (UILabel *)stockNum{
    if (!_stockNum) {
        _stockNum = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _zyLb.y+ _zyLb.height, MAINWIDTH, 30) Font:12 Text:@"" ];
        _stockNum.textColor = UIColorFromRGB(0x999999);
    }
    return _stockNum;
}

- (UILabel *)fenhong{
    if (!_fenhong) {
        _fenhong = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _stockNum.y+_stockNum.height, MAINWIDTH/2., 30) Font:12 Text:@""];
        _fenhong.textColor = UIColorFromRGB(0x999999);
    }
    return _fenhong;
}

//- (UILabel *)bukui{
//    if (!_bukui) {
//        _bukui = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _stockNum.y+_stockNum.height, MAINWIDTH/2., 30) Font:12 Text:@""];
//        _bukui.textColor = UIColorFromRGB(0x999999);
//    }
//    return _bukui;
//}

- (UILabel *)chengjiaoTime{
    if (!_chengjiaoTime) {
        _chengjiaoTime = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _fenhong.y + _fenhong.height + 20, MAINWIDTH/2.- 20, 30) Font:11 Text:@"成交时间："];
        _chengjiaoTime.textColor = UIColorFromRGB(0x999999);
    }
    return _chengjiaoTime;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2. , _chengjiaoTime.y  , MAINWIDTH/2-20., 30) Font:11 Text:@""];
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.textColor = UIColorFromRGB(0x999999);
    }
    return _timeLb;
}

- (UILabel *)celueNo{
    if (!_celueNo) {
        _celueNo = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _chengjiaoTime.y + _chengjiaoTime.height, MAINWIDTH/2.-20, 30) Font:11 Text:@"策略编号"];
        _celueNo.textColor = UIColorFromRGB(0x999999);
    }
    return _celueNo;
}

- (UILabel *)NOLb{
    if (!_NOLb) {
        _NOLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _celueNo.y, MAINWIDTH/2.-20, 30) Font:11 Text:@""];
        _NOLb.textColor = UIColorFromRGB(0x999999);
        _NOLb.textAlignment = NSTextAlignmentRight;
    }
    return _NOLb;
}

- (UILabel *)dytj{
    if (!_dytj) {
        _dytj = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _celueNo.y + _celueNo.height, MAINWIDTH/2.-20, 30) Font:11 Text:@"递延条件"];
        _dytj.textColor = UIColorFromRGB(0x999999);
    }
    return _dytj;
}

- (UILabel *)dyNum{
    if (!_dyNum) {
        _dyNum = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _dytj.y, MAINWIDTH/2.-20, 30) Font:11 Text:@""];
        _dyNum.textColor = [UIColor orangeColor];
        _dyNum.textAlignment = NSTextAlignmentRight;
    }
    return _dyNum;
}

- (UILabel *)fudong{
    if (!_fudong) {
        _fudong = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _dytj.y + _dytj.height, MAINWIDTH/2.-20, 30) Font:11 Text:@"浮动盈亏"];
        _fudong.textColor = UIColorFromRGB(0x999999);
    }
    return _fudong;
}

- (UILabel *)fudongNum{
    if (!_fudongNum) {
        _fudongNum = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _fudong.y, MAINWIDTH/2.-20, 30) Font:11 Text:@""];
        
        _fudongNum.textAlignment = NSTextAlignmentRight;
    }
    return _fudongNum;
}

- (UIButton *)setPlanBtn{
    if (!_setPlanBtn) {
        _setPlanBtn = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH/3. + _name.x, _fudong.y + _fudong.height + 20, MAINWIDTH/3. - 30, 30) Target:self SEL:@selector(setClick:) Title:@"设置止盈止损" ImageName:@"" bgImage:@"" Tag:100];
        _setPlanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _setPlanBtn.layer.masksToBounds = YES;
        _setPlanBtn.layer.cornerRadius = 4.;
        _setPlanBtn.backgroundColor = [UIColor redColor];
    }
    return _setPlanBtn;
}

- (UIButton *)supplyBtn{
    if (!_supplyBtn) {
        _supplyBtn = [JPMyControl createButtonWithFrame:CGRectMake(_name.x, _setPlanBtn.y, _setPlanBtn.width, _setPlanBtn.height) Target:self SEL:@selector(setClick:) Title:@"补亏" ImageName:@"" bgImage:@"" Tag:102];
        _supplyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _supplyBtn.layer.masksToBounds = YES;
        _supplyBtn.layer.cornerRadius = 4.;
        _supplyBtn.backgroundColor = [UIColor redColor];
//        _supplyBtn.hidden = YES;
    }
    return _supplyBtn;
}

- (UIButton *)sellBtn{
    if (!_sellBtn) {
        _sellBtn = [JPMyControl createButtonWithFrame:CGRectMake(_name.x + MAINWIDTH/3. *2., _fudong.y + _fudong.height + 20, MAINWIDTH/3. - 30, 30) Target:self SEL:@selector(setClick:) Title:@"平仓" ImageName:@"" bgImage:@"" Tag:101];
        _sellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sellBtn.layer.masksToBounds = YES;
        _sellBtn.layer.cornerRadius = 4.;
        _sellBtn.backgroundColor = [UIColor redColor];
    }
    
    return _sellBtn;
}

- (void)setClick:(UIButton *)btn{
    WEAKSELF
    if (self.addTocollect) {
        weakself.addTocollect(weakself.planID, btn.tag - 100, _buyPrice,_flowValue , _stopProfit, _stopLoss,_nowStopProfit,_nowStopLoss);
    }
}

- (void)setCellWithDic:(NSDictionary *)dic :(CGFloat)price{
    _buyPrice =  [dic[@"make_price"] floatValue];
//    _zs =  [dic[@"stop_loss"] floatValue];
    _planID = [NSString stringWithFormat:@"%@",dic[@"order_no"]];
    _name.text = [NSString stringWithFormat:@"%@(%@)",dic[@"stock_name"],dic[@"stock_code"]];
    _dayNum.text = [NSString stringWithFormat:@"已持仓%@天    >>",dic[@"day"]];
    _nowPrice = price;
    _priceLb.text = [NSString stringWithFormat:@"委托价：%@         当前价：%.2f         成交价：%@",dic[@"stock_price"],price,dic[@"make_price"]];
    _zyLb.text = [NSString stringWithFormat:@"止盈：%@(%.2f)    止损：%@(%.2f)",dic[@"stop_profit"],[dic[@"stop_profit_price"] floatValue],dic[@"stop_loss"],[dic[@"stop_loss_price"]floatValue]];
    _nowStopProfit = [dic[@"stop_profit_price"] floatValue];
    _nowStopLoss = [dic[@"stop_loss_price"] floatValue];
    _stopProfit = [dic[@"max_stop_profit_price"] floatValue];
    _stopLoss =  [dic[@"max_stop_loss_price"] floatValue];
    _stockNum.text = [NSString stringWithFormat:@"数量：买入%@股（含分红%@股）",dic[@"stock_count"],dic[@"rx_count"]];
    _fenhong.text = [NSString stringWithFormat:@"分红：%.2f",[dic[@"red_money"] floatValue]];
//    _bukui.text = [NSString stringWithFormat:@"补亏：%.2f",[dic[@"fl_money"] floatValue]];
    _timeLb.text =  [NSString stringWithFormat:@"%@",dic[@"make_time"]];
    _NOLb.text = [NSString stringWithFormat:@"%@",dic[@"order_no"]];
    CGFloat x = price * [dic[@"stock_count"]floatValue] - [dic[ @"market_value"]floatValue] + [dic[ @"fl_money"]floatValue];//这里加上补亏总金额
    _flowValue = x;
    CGFloat y = [dic[@"market_value"]floatValue] * ([dic[@"dy_cond"] floatValue]/100.);
    _dyNum.text = [NSString stringWithFormat:@"浮动盈亏 ≥ -%.2f",y];
    _fudongNum.text = [NSString stringWithFormat:@"%.2f(含补亏%.2f)",x,[dic[@"fl_money"] floatValue]];
    if (x>0) {
        _fudongNum.textColor = [UIColor redColor];
//        _supplyBtn.hidden = YES;
    }else{
        _fudongNum.textColor = UIColorFromRGB(0x247f00);
//        _supplyBtn.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
