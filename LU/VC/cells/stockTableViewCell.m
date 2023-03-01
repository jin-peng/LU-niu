//
//  stockTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/4/18.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "stockTableViewCell.h"

@implementation stockTableViewCell

- (void)makeCellUI{
    //托底view
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.numLb];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.perLb];
}

- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [JPMyControl createLabelWithFrame:CGRectMake(0, 7, MAINWIDTH/3., 28) Font:14 Text:@""];
        _nameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLb;
}

- (UILabel *)numLb{
    if (!_numLb) {
        _numLb = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _nameLb.y+_nameLb.height, _nameLb.width, _nameLb.height) Font:11 Text:@""];
        _numLb.textAlignment = NSTextAlignmentCenter;
        _numLb.textColor = UIColorFromRGB(0x666666);
    }
    return _numLb;
}

- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/3., 0, MAINWIDTH/3., 70) Font:14 Text:@""];
        _priceLb.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLb;
}

- (UILabel *)perLb{
    if (!_perLb) {
        _perLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/3.*2., 0, MAINWIDTH/3., _priceLb.height) Font:12 Text:@""];
        _perLb.textAlignment = NSTextAlignmentCenter;
    }
    return _perLb;
}

- (void)setCellWithDic:(NSDictionary *)dic price:(nonnull NSDictionary *)priceDic{
    _nameLb.text = [[dic[@"name"] componentsSeparatedByString:@"("] firstObject];
    _numLb.text = dic[@"code"];
    _priceLb.text = [NSString stringWithFormat:@"%.2f", [priceDic[@"price"] floatValue]];
    _perLb.textColor = [priceDic[@"per"] floatValue]>0?[UIColor redColor]:UIColorFromRGB(0x247f00);
    _perLb.text = priceDic[@"per"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
