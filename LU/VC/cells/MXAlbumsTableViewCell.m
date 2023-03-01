//
//  MXAlbumsTableViewCell.m
//  mengX
//
//  Created by mengX on 15/9/26.
//  Copyright (c) 2015年 金鹏. All rights reserved.
//

#import "MXAlbumsTableViewCell.h"

@implementation MXAlbumsTableViewCell


- (void)makeCellUI{
    //托底view
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.nameLabel];
    [self.BGView addSubview:self.timeLabel];
    [self.BGView addSubview:self.buyLabel];
    [self.BGView addSubview:self.buyBtn];
    
}

- (UIView *)BGView{
    if (!_BGView) {
        _BGView = [JPMyControl createViewWithFrame:CGRectMake(10, 5, MAINWIDTH-20., 50.) bgColor:[UIColor whiteColor]];
    }
    return _BGView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[JPMyControl createLabelWithFrame:CGRectMake(5, 5, MAINWIDTH/2., 11) Font:11 Text:@"王**"];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel =[JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH - 100, 5, 50, 10) Font:10 Text:@"10:10"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

- (UILabel *)buyLabel{
    if (!_buyLabel) {
        _buyLabel = [JPMyControl createLabelWithFrame:CGRectMake(5, 22, MAINWIDTH/2., 12) Font:12 Text:@""];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"买入贵州茅台3000股"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 4)];
        _buyLabel.attributedText = str;
        
    }
    return _buyLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH - 100, 20, 50, 15) Target:self SEL:@selector(buyBtnClick) Title:@"跟买" ImageName:@"" bgImage:@"" Tag:0];
        [_buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _buyBtn.layer.cornerRadius = 7.5;
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.borderColor = [UIColor redColor].CGColor;
        _buyBtn.layer.borderWidth = .5;
    }
    return _buyBtn;
}

- (void)setCellWithDic:(NSDictionary *)dic{
    NSMutableString * str = [[NSMutableString alloc]initWithString:dic[@"nick_name"]];
    [str replaceCharactersInRange:NSMakeRange(1, str.length-1) withString:@"***"];
    _nameLabel.text = str;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[[dic[@"time"] componentsSeparatedByString:@" "]lastObject]];
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"买入%@%@股",dic[@"stock_name"],dic[@"stock_count"]]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, [dic[@"stock_name"] length])];
    
    _buyLabel.attributedText = str1;
    
}


- (void)buyBtnClick{
    WEAKSELF;
    if (weakself.pushToDetail) {
        weakself.pushToDetail(weakself.ID);
    }
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
