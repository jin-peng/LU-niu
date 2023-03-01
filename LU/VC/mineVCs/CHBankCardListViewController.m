//
//  CHBankCardListViewController.m
//  LU
//
//  Created by peng jin on 2019/6/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHBankCardListViewController.h"
#import "CHGetStockNum.h"
@interface CHBankCardListViewController () <UIAlertViewDelegate>
@property (nonatomic,strong)NSString * msg;
@end

@implementation CHBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    UIView * bankView = [JPMyControl createViewWithFrame:CGRectMake(15, 10 + StatusBarAndNavigationBarHeight, MAINWIDTH - 30, MAINWIDTH/2.) bgColor:[UIColor whiteColor]];
    bankView.layer.masksToBounds = YES;
    bankView.layer.cornerRadius = 6.;
    UILabel * name = [JPMyControl createLabelWithFrame:CGRectMake(60, 10, MAINWIDTH - 160, 40) Font:22 Text:[CNManager loadByKey:BANKNAME]];
    [bankView addSubview:name];
    UILabel * type = [JPMyControl createLabelWithFrame:CGRectMake(name.x, bankView.height*.4-15 , name.width,30 ) Font:13 Text:@"储蓄卡"];
    type.textColor = UIColorFromRGB(0x999999);
    [bankView addSubview:type];
    UILabel * card = [JPMyControl createLabelWithFrame:CGRectMake(name.x, type.y +type.height + 10, MAINWIDTH - 160, 40) Font:22 Text:[CNManager loadByKey:BANKCARD]];
    [bankView addSubview:card];
    
    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, bankView.height/5.*4., MAINWIDTH, 8) bgColor:UIColorFromRGB(0xefefef)];
    [bankView addSubview:line];
    [self.view addSubview:bankView];

    // Do any additional setup after loading the view.
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"银行卡";
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
    
    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick) Title:@"解绑" ImageName:@"" bgImage:@"" Tag:0];
    _editBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    //    _editBtn.hidden=YES;
    right.style=UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItems=@[right];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setClick{
    [self getPhoneCode];
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"请输入六位短信验证码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle = UIAlertViewStylePlainTextInput;
    al.tag = 200;
    [al show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:self.msg]) {
            [self disCard];
        }else{
            [CNManager showWindowAlert:@"验证码错误"];
        }
    }
}

- (void)getPhoneCode{
    //发送验证码
    WEAKSELF
    [CHGetStockNum getShotMessage:[CNManager loadByKey:USERPHONE] type:4 Success:^(NSString * _Nonnull meg) {
        weakself.msg = meg;
    }];
}

- (void)disCard{
    //    解绑
    
//    if (_password.text.length&&_secret.text.length) {
//        if (![_msg isEqualToString:_secret.text]) {
//            [CNManager showWindowAlert:@"验证码错误"];
//            return;
//        }
//    }else{
//        [CNManager showWindowAlert:@"验证码错误"];
//        return;
//    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/updateUserBankInfo",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //        WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:@"解绑成功"];
                //                [CHGetStockNum getUserInfobyPhone:self->c_phone];
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                //                [weakself getUserInfo];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [CNManager showWindowAlert:@"获取验证码失败"];
        NSLog(@"error slider");
    }];
    
    
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
