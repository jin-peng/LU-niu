//
//  NewsTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/4/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)makeCellUI{
    //托底view
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.nameLabel];
    [self.BGView addSubview:self.infoLabel];
    [self.BGView addSubview:self.timeLabel];
    [self.BGView addSubview:self.newsImageView];
    [self.BGView addSubview:self.view_LineView];
}

- (UIView *)BGView{
    if (!_BGView) {
        _BGView = [JPMyControl createViewWithFrame:CGRectMake(10, 5, MAINWIDTH-20., 90.) bgColor:[UIColor whiteColor]];
    }
    return _BGView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[JPMyControl createLabelWithFrame:CGRectMake(5, 9, MAINWIDTH - 20 - 20 - 128, 12) Font:12 Text:@"王**"];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [JPMyControl createLabelWithFrame:CGRectMake(5, _nameLabel.y+_nameLabel.height+7., _nameLabel.width, 30) Font:10 Text:@""];
        _infoLabel.numberOfLines = 2;
        _infoLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _infoLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel =[JPMyControl createLabelWithFrame:CGRectMake(5, _infoLabel.y+_infoLabel.height+9., _infoLabel.width, 10) Font:10 Text:@""];
//        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _timeLabel;
}

- (UIImageView *)newsImageView{
    if (!_newsImageView) {
        _newsImageView = [JPMyControl createImageViewWithFrame:CGRectMake(_BGView.width - 10 - 128, _nameLabel.y, 128, 72) ImageName:@"平台公告"];
    }
    return _newsImageView;
}


- (void)setCellWithDic:(NSDictionary *)dic{
    _nameLabel.text = dic[@"title"];
    _infoLabel.text = dic[@"abstract"];
    _timeLabel.text = dic[@"time"];
    [_newsImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"平台公告"]];
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

