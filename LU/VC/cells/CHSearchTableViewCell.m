//
//  CHSearchTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/4/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHSearchTableViewCell.h"

@implementation CHSearchTableViewCell

- (void)makeCellUIWithSelect{
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.numLb];
}

- (void)makeCellUI{
    //托底view
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.numLb];
    [self.contentView addSubview:self.addBtn];
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _selectBtn.userInteractionEnabled = NO;
        _selectBtn.contentEdgeInsets = UIEdgeInsetsMake(16, 15, 14, 15);
    }
    return _selectBtn;
}

- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [JPMyControl createLabelWithFrame:CGRectMake(_selectBtn.width, 7, MAINWIDTH/3., 38) Font:14 Text:@""];
        _nameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLb;
}

- (UILabel *)numLb{
    if (!_numLb) {
        _numLb = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.width, _nameLb.y, _nameLb.width, _nameLb.height) Font:11 Text:@""];
        _numLb.textAlignment = NSTextAlignmentCenter;
        _numLb.textColor = UIColorFromRGB(0x666666);
    }
    return _numLb;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH - 40, _nameLb.y+8, 24, 24) Target:self SEL:@selector(addBtnClick) Title:@"" ImageName:@"" bgImage:@"加号按钮" Tag:0];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius = _addBtn.height/2.;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.borderColor = [[UIColor redColor] CGColor];
        _addBtn.layer.borderWidth = .5;
    }
    return _addBtn;
}

- (void)addBtnClick{
    WEAKSELF
    self.x = !_x;
//    [_addBtn setTitle:_x?@"-":@"+" forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageNamed:_x?@"减号按钮":@"加号按钮"] forState:UIControlStateNormal];
    if (weakself.addTocollect) {
        weakself.addTocollect(_stockID,_dic,_x);
    }
}

- (void)setCellWithDic:(NSDictionary *)dic{
    _nameLb.text = [[dic[@"name"] componentsSeparatedByString:@"("]firstObject];
    _numLb.text = dic[@"code"];
    self.stockID = dic[@"code"];
    self.dic = dic;
//    [_addBtn setTitle:_x?@"-":@"+" forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageNamed:_x?@"减号按钮":@"加号按钮"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:_x?@"cirle-select":@"cirle-unselect"] forState:UIControlStateNormal];
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
