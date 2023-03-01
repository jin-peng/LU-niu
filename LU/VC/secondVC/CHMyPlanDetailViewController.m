//
//  CHMyPlanDetailViewController.m
//  LU
//
//  Created by peng jin on 2019/6/6.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHMyPlanDetailViewController.h"

@interface CHMyPlanDetailViewController ()
@property (nonatomic, strong)UIScrollView * homeSc;
@property (nonatomic, strong)UIView * bottomView;
//@property (nonatomic, strong)UILabel * gainLb;

@end

@implementation CHMyPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.homeSc];
    [self.view addSubview:self.bottomView];
    // Do any additional setup after loading the view.
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [JPMyControl createViewWithFrame:CGRectMake(0, MAINHEIGHT - 50, MAINWIDTH, 50) bgColor:[UIColor whiteColor]];
        NSArray * arr = @[@"持仓中",@"委托中"];
        for (int i = 0 ; i<2; i++) {
//            ；
        }
    }
    return _bottomView;
}



- (UIScrollView *)homeSc{
    if (!_homeSc) {
        _homeSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight - 50.)];
        _homeSc.contentSize = CGSizeMake(MAINWIDTH, MAINWIDTH);
        CGFloat h = 0;
        UILabel * gainLb= [JPMyControl createLabelWithFrame:CGRectMake(20, h, MAINWIDTH-40, 50) Font:16 Text:@"持仓总盈亏"];
        UILabel * gainNubLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH - 40 - 100, 0, 100, gainLb.height) Font:16 Text:@""];
        gainNubLb.textAlignment = NSTextAlignmentRight;
       NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"3000.10元"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length-1)];
        gainNubLb.attributedText = str;
        
        [_homeSc addSubview:gainLb];
        [gainLb addSubview:gainNubLb];
        
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, gainLb.y + gainLb.height, MAINWIDTH , 8) bgColor:UIColorFromRGB(0xbcbcbc)];
        [_homeSc addSubview:line];
        h = h+ line.y+ line.height;
        UILabel * nameLb= [JPMyControl createLabelWithFrame:CGRectMake(20, h, MAINWIDTH-40, 50) Font:16 Text:@"中远海控（601919）"];
        UILabel * timeLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH - 40 - 100, 0, 100, gainLb.height) Font:14 Text:@"已持仓一天"];
        timeLb.textColor = UIColorFromRGB(0x999999);
        timeLb.textAlignment = NSTextAlignmentRight;
        
        [_homeSc addSubview:nameLb];
        [nameLb addSubview:timeLb];
        
        UIView * line1 = [JPMyControl createViewWithFrame:CGRectMake(0, nameLb.y + nameLb.height, MAINWIDTH , .5) bgColor:UIColorFromRGB(0xbcbcbc)];
        [_homeSc addSubview:line1];
        
        h = line1.y + line1.height;
        NSArray * arr = @[@[@"委托价",@"当前价",@"成交价"],@[@"止盈",@"止损"],@[@"数量"],@[@"分红"],@[@"成交时间",@"策略编号",@"递延条件",@"浮动盈亏"]];
        
        for (int i = 0; i< arr.count; i++) {
            ;
        }
        
        
    }
    return _homeSc;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"我的策略";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
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
