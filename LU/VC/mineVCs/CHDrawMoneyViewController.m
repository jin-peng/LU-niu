//
//  CHDrawMoneyViewController.m
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHDrawMoneyViewController.h"

@interface CHDrawMoneyViewController () <UITextFieldDelegate>
@property (nonatomic ,strong)UILabel     *name;
@property (nonatomic ,strong)UILabel     *realName;
@property (nonatomic ,strong)UITextField *phone;
@property (nonatomic ,strong)UILabel  *member;
@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UILabel *price;
@property (nonatomic ,strong)UIButton    *loginBtn;
//@property (nonatomic ,strong)UILabel     *info;
@end

@implementation CHDrawMoneyViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) Target:self SEL:@selector(hiddenKey) Title:@"" ImageName:@"" bgImage:@"" Tag:0];
    [self.view addSubview:btn];
    for (int i = 0 ; i< 3; i++) {
        UIView * vi = [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 1 + i * 61., MAINWIDTH, 60) bgColor:[UIColor whiteColor]];
        [self.view addSubview:vi];
    }
    [self.view addSubview:self.name];
    [self.view addSubview:self.realName];
    [self.view addSubview:self.member];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.price];
    [self.view addSubview:self.password];
    //    [self.view addSubview:self.invite];
    [self.view addSubview:self.loginBtn];
//    [self.view addSubview:self.info];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_invite];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(10, StatusBarAndNavigationBarHeight + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"账户余额"]];
    }
    return _name;
}

- (UILabel *)realName{
    if (!_realName) {
        _realName = [JPMyControl createLabelWithFrame:CGRectMake(_name.x+_name.width, StatusBarAndNavigationBarHeight, MAINWIDTH - 120- 40, 60) Font:12 Text:[NSString stringWithFormat:@"%.2f",[[CNManager loadByKey:MONEY] floatValue]]];
        _realName.textColor = [UIColor redColor];
    }
    return _realName;
}

- (UILabel *)member{
    if (!_member) {
        _member = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y+_name.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"提款金额(元)"]];
    }
    return _member;
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x, _realName.y+ _realName.height +1, _realName.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入提款金额" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _phone.background = [UIColor whiteColor];
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
        _phone.delegate = self;
    }
    return _phone;
}

- (UILabel *)price{
    if (!_price) {
        _price = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _member.y+_member.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"提现密码"]];
    }
    return _price;
}

- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x    , _phone.y+_phone.height + 1, _phone.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入提现密码" sucureTextEntry:YES];
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        //        [_password addSubview:line];
        //        _password.userInteractionEnabled = YES;
        _password.delegate = self;
    }
    return _password;
}



- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(40, _password.y + _password.height + 30 , MAINWIDTH - 80., 38) Target:self SEL:@selector(loginClick) Title:@"立即提现" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

//- (UILabel *)info{zhuangzh
//    if (!_info) {
//        _info = [JPMyControl createLabelWithFrame:CGRectMake(_loginBtn.x, _loginBtn.y+_loginBtn.height + 20, _loginBtn.width, 80) Font:9 Text:@"温馨提示：\n1、转账时请仔细核对卡号、用户名及支行信息，避免操作出错\n2、zhuang zh\n\n"]
//    }
//}

- (void)loginClick{
    if ([_phone.text floatValue]>[_realName.text floatValue]||[_phone.text floatValue]<=0) {
        [CNManager showWindowAlert:@"请输入正确金额"];
        return;
    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_phone.text forKey:@"money"];
    [dataDict setObject:_password.text forKey:@"pwd"];
    //前端发送提现请求操作，请求的参数 包含【money(金额),uid(用户ID),pwd(提现密码)】后台返回成功与否信息根据code==0 证明成功 其他值为失败 来判断。
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/sendWithdraw",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:@"申请成功,请等待审核通过"];
                [weakself.navigationController popViewControllerAnimated:YES];
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

- (void)judgePassWord{
    //先去掉两端的空格
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    self.invite.text=[self.invite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    
    if (_password.text.length && _phone.text.length ) {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = [UIColor orangeColor];
    }else{
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
    }
    
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"支付宝转账";
    
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
