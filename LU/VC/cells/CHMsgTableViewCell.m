//
//  CHMsgTableViewCell.m
//  LU
//
//  Created by peng jin on 2019/7/8.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHMsgTableViewCell.h"

@implementation CHMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)makeCellUI{
//    self.backgroundColor = [UIColor clearColor];
    self.backView = [JPMyControl createViewWithFrame:CGRectMake(10, 0, MAINWIDTH - 20, 60) bgColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.backView];
    [_backView addSubview:self.title];
    [_backView addSubview:self.msg];
    [_backView addSubview:self.time];
}

- (UILabel *)title{
    if (!_title) {
        _title = [JPMyControl createLabelWithFrame:CGRectMake(10, 15, MAINWIDTH - 50, 15) Font:15 Text:@"消息"];
    }
    return _title;
}

- (UILabel *)msg{
    if (!_msg) {
        _msg = [JPMyControl createLabelWithFrame:CGRectMake(_title.x, _title.y + _title.height + 10 , _title.width, 14 ) Font:14 Text:@""];
        _msg.textColor = UIColorFromRGB(0x666666);
        _msg.numberOfLines = 0;
    }
    
    return _msg;
}

- (UILabel *)time{
    if (!_time) {
        _time = [JPMyControl createLabelWithFrame:CGRectMake(_title.x, _msg.y + _msg.height + 10 , _title.width, 12 ) Font:10 Text:@""];
        _time.textColor = UIColorFromRGB(0x999999);
    }
    
    return _time;
}

- (void)setCellWithDic:(NSDictionary *)dic{
    _time.text = [NSString stringWithFormat:@"%@",dic[@"reply_time"]];
    _msg.text = [NSString stringWithFormat:@"%@",dic[@"reply_content"]];
    [JPMyControl resetLabelFrame:_msg];
    _time.frame = CGRectMake(_time.x, _msg.y + _msg.height + 10, _time.width, _time.height);
    _backView.frame = CGRectMake(_backView.x, _backView.y, _backView.width, _time.y+ _time.height + 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
