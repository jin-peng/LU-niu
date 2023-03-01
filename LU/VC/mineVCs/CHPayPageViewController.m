//
//  CHPayPageViewController.m
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHPayPageViewController.h"
#import "CHTradeDetailsViewController.h"
#import "CHAliPayViewController.h"
#import "CHBankPayViewController.h"
#import "CHWXpayViewController.h"

@interface CHPayPageViewController ()

@end

@implementation CHPayPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    NSArray *arr = @[@"支付宝",@"微信支付",@"银行转账"];
    NSArray *arr1 = @[@"手机支付，免手续费",@"手机支付，免手续费",@"支持大额支付，免手续费"];
    NSArray *imgArr = @[@"alipayicon",@"weixinicon",@"bankicon"];
    for (int i= 0; i<arr.count; i++) {
        UIButton *btn = [JPMyControl createButtonWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 5 + i*76, MAINWIDTH, 75) Target:self SEL:@selector(btnClick:) Title:@"" ImageName:imgArr[i] bgImage:@"" Tag:100+i];
        btn.backgroundColor = [UIColor whiteColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UILabel * name = [JPMyControl createLabelWithFrame:CGRectMake(150 , 15, 150, 15) Font:15 Text:arr[i]];
        UILabel * info = [JPMyControl createLabelWithFrame:CGRectMake(150 , name.y + name.height + 15, 150, 15) Font:12 Text:arr1[i]];
        info.textColor = UIColorFromRGB(0x999999);
        [btn addSubview:name];
        [btn addSubview:info];
//        btn.contentMode = UIViewContentModeLeft;
        [self.view addSubview:btn];
    }
    // Do any additional setup after loading the view.
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag - 100) {
        case 0:
            { //支付宝
                CHAliPayViewController *vc = [[CHAliPayViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
        {//微信
            CHAliPayViewController *vc = [[CHAliPayViewController alloc]init];
            vc.isWX = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {//银行
            CHBankPayViewController *vc = [[CHBankPayViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"账户充值";
    
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
    
    UIButton * _editBtn2=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick1) Title:@"充值记录" ImageName:@"" bgImage:@"" Tag:0];
    _editBtn2.titleLabel.font=[UIFont systemFontOfSize:12];
    [_editBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*right2=[[UIBarButtonItem alloc]initWithCustomView:_editBtn2];
    //    _editBtn2.hidden=YES;
    right2.style=UIBarButtonItemStylePlain;
//    _editBtn.alpha=.9;
    _editBtn2.alpha=.9;
    self.navigationItem.rightBarButtonItem=right2;
    
}

- (void)setClick1{
    CHTradeDetailsViewController * vc= [[CHTradeDetailsViewController alloc]init];
    vc.questNum = 2;
    [self.navigationController pushViewController:vc animated:YES];
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
