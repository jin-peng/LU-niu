//
//  CHBankPayViewController.m
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHBankPayViewController.h"

@interface CHBankPayViewController ()

@end

@implementation CHBankPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadBankInfo];
    // Do any additional setup after loading the view.
}

- (void)btnClick:(UIButton *)btn{
    NSInteger x = btn.tag - 100;
    NSArray * arrName = @[_infoDic[@"bank_name"],_infoDic[@"account_no"],_infoDic[@"bank"]];
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = arrName[x];
    [CNManager showWindowAlert:@"复制成功"];
}

- (void)makeUI{
    UIImageView * vi = [JPMyControl createImageViewWithFrame:CGRectMake(15, StatusBarAndNavigationBarHeight + 20, MAINWIDTH - 30, 150) ImageName:@"bankBack"];
    vi.backgroundColor = [UIColor orangeColor];
    vi.layer.masksToBounds = YES;
    vi.layer.cornerRadius = 8.;
    [self.view addSubview:vi];
    
    UILabel * lbb = [JPMyControl createLabelWithFrame:CGRectMake(vi.x, vi.y + vi.height + 10, vi.width, 80) Font:12 Text:@"温馨提示：\n1、转账时请仔细核对卡号、户名及支行信息，避免操作出错\n2、转账时请备注您在平台注册的用户名和手机号，以便财务核对及时入账\n3、转账成功后请保存好交易回执单并及时致电平台客服"];
    lbb.textColor = UIColorFromRGB(0x999999);
    lbb.numberOfLines = 0;
    [self.view addSubview:lbb];
    
    NSArray * arr = @[@"复制户名",@"复制账号",@"复制开户行"];
    NSArray * arrName = @[_infoDic[@"bank_name"],_infoDic[@"account_no"],_infoDic[@"bank"]];
    for (int i = 0; i< arr.count; i++) {
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(10, 10 + 40 * i, vi.width - 20, 40 + (i==2?20:0)) Font:11 Text:arrName[i]];
        lb.textColor = [UIColor whiteColor];
        UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(vi.width - 80, lb.y + 10 + (i==2?10:0), 70, 20) Target:self SEL:@selector(btnClick:) Title:arr[i] ImageName:@"" bgImage:@"" Tag:100+ i];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.height/2.;
        btn.layer.borderWidth = 1.;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        if (i == 1) {
            lb.font = [UIFont systemFontOfSize:14];
            UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, lb.y + lb.height , vi.width, .5) bgColor:[UIColor whiteColor]];
            [vi addSubview:line];
        }
        [vi addSubview:lb];
        [vi addSubview:btn];
    }
}

- (void)loadBankInfo{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:@"1" forKey:@"type"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/sysBankAccount/list",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [weakself.tableView.header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    weakself.infoDic = [CNManager dictionaryWithJsonString:str1];
                    [weakself makeUI];
                    //                    NSArray *tmpArr= dic[@"list"];
                    
                    //                    NSLog(@"%@",dic);
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [CNManager showWindowAlert:@"操作失败"];
        //        [weakself.tableView.header endRefreshing];
        //        NSLog(@"error slider");
    }];
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"银行转账";
    
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
