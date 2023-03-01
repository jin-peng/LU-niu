//
//  CHDetailPageCTViewController.m
//  LU
//
//  Created by peng jin on 2019/6/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHDetailPageCTViewController.h"

@interface CHDetailPageCTViewController ()
@property (nonatomic ,strong) UILabel * titleLb;
@property (nonatomic ,strong) UILabel * num;

@property (nonatomic ,strong) UILabel * help;
@end

@implementation CHDetailPageCTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.titleLb];
    [self.view addSubview:self.num];
    NSArray * titleArr = @[@"时间",@"类型",@"详情"];
    NSArray * infoArr;
    if (_isPay) {
        infoArr = @[[CNManager setShowTime:[_detailDic[@"pay_time"] doubleValue]],_isPay?@"充值":@"提现",[NSString stringWithFormat:@"充值%.2f  ",[_detailDic[@"pay_num"] floatValue]]];
        
    }else{
        NSMutableString * str = [[NSMutableString alloc]initWithString: _detailDic[@"card"]];
        if (str.length > 10) {
            [str replaceCharactersInRange:NSMakeRange(4, str.length - 8) withString:@"*********"];
        }
        infoArr = @[_detailDic[@"tx_time"],_isPay?@"充值":@"提现",[NSString stringWithFormat:@"%@  %@",_detailDic[@"bank_name"],str]];
    }
    
    for (int i = 0; i< titleArr.count; i++) {
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(15, _num.y+_num.height + 40 + i* 30., 70, 30) Font:12 Text:titleArr[i]];
        lb.textColor = UIColorFromRGB(0x999999);
        [self.view addSubview:lb];
        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake( lb.x + lb.width + 10 , lb.y, MAINWIDTH - (lb.x + lb.width + 25), 30) Font:11 Text:infoArr[i]];
        lb2.textAlignment = NSTextAlignmentRight;
        lb2.textColor = UIColorFromRGB(0x666666);
        [self.view addSubview:lb2];
    }
    self.help = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT - 100, MAINWIDTH, 60) Font:9 Text:[NSString stringWithFormat: @"如有疑问请拨打客服电话\n%@\n工作时间：周一至周五9:00-18:00",[CHConfig hotPhoneNumber]]];
    _help.numberOfLines = 0;
    _help.textAlignment = NSTextAlignmentCenter;
    _help.textColor = UIColorFromRGB(0xaaaaaa);
    [self.view addSubview:self.help];
    
    
    
    // Do any additional setup after loading the view.
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [JPMyControl createLabelWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 40 , MAINWIDTH, 40) Font:18 Text:_isPay?@"充值":@"提现"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UILabel *)num{
    if (!_num) {//数量
        _num = [JPMyControl createLabelWithFrame:CGRectMake(0, _titleLb.y + _titleLb.height + 20 , MAINWIDTH, 40) Font:30 Text:[NSString stringWithFormat:@"%@%@",_isPay?@"+":@"-",_isPay?_detailDic[@"pay_num"] :_detailDic[@"tx_money"]]];
        _num.textAlignment = NSTextAlignmentCenter;
    }
    return _num;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    self.title= @"交易明细";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = moreItem;
    
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
