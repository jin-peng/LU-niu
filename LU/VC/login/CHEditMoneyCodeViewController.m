//
//  CHEditMoneyCodeViewController.m
//  LU
//
//  Created by peng jin on 2019/5/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHEditMoneyCodeViewController.h"
#import "CHGetStockNum.h"
@interface CHEditMoneyCodeViewController () <UITextFieldDelegate> {
    NSTimer *m_timer;
    NSInteger m_second;
}
@property (nonatomic ,strong)UILabel     *phone;
@property (nonatomic ,strong)UITextField *secret;
@property (nonatomic ,strong)UITextField *password;
//@property (nonatomic ,strong)UITextField *invite;
//@property (nonatomic ,strong)UIImageView *iconIV;
@property (nonatomic ,strong)UIButton    *eyeBtn;
@property (nonatomic ,strong)UIButton    *loginBtn;
@property (nonatomic ,strong)UIButton    *fogetBtn;
@property (nonatomic ,strong)NSString    *msg;
@end

@implementation CHEditMoneyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) Target:self SEL:@selector(hiddenKey) Title:@"" ImageName:@"" bgImage:@"" Tag:0];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.phone];
    [self.view addSubview:self.secret];
    [self.view addSubview:self.password];
//    [self.view addSubview:self.invite];
    [self.view addSubview:self.eyeBtn];
    [self.view addSubview:self.loginBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_secret];
    // Do any additional setup after loading the view.
}

- (UILabel *)phone{
    if (!_phone) {
        _phone = [JPMyControl createLabelWithFrame:CGRectMake(30, StatusBarAndNavigationBarHeight + 30, MAINWIDTH - 60, 20) Font:14 Text:[NSString stringWithFormat:@"当前手机号  %@",[CNManager loadByKey:USERPHONE]]];
//        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
//        _phone.delegate = self;
    }
    return _phone;
}

- (UITextField *)secret{
    if (!_secret) {
        _secret = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _phone.y + _phone.height + 40, MAINWIDTH - 140, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入验证码" sucureTextEntry:NO];
        _secret.clearButtonMode = UITextFieldViewModeWhileEditing;
        _secret.delegate = self;
    }
    return _secret;
}

- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _secret.y+_secret.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder: @"密码由6-18位字母、数字组成" sucureTextEntry:NO];
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        //        [_password addSubview:line];
        //        _password.userInteractionEnabled = YES;
        _password.delegate = self;
    }
    return _password;
}

- (UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [JPMyControl createButtonWithFrame:CGRectMake(_secret.width + _secret.x + 5 , _secret.y, 80, 20) Target:self SEL:@selector(eyeBtnClick) Title:@"获取验证码" ImageName:@"" bgImage:@"" Tag:0];
//        _eyeBtn.userInteractionEnabled = NO;
        _eyeBtn.layer.masksToBounds = YES;
        _eyeBtn.layer.cornerRadius = 3.;
        _eyeBtn.backgroundColor = [UIColor orangeColor];
        //        _eyeBtn.userInteractionEnabled = YES;
        _eyeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _eyeBtn;
}


- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x, _password.y + _password.height + 40 , _phone.width, 38) Target:self SEL:@selector(loginClick) Title:@"确认" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"修改提现密码";
    
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

- (void)eyeBtnClick{
    //发送验证码
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    m_second = 60;
    WEAKSELF
    [CHGetStockNum getShotMessage:[CNManager loadByKey:USERPHONE] type:3 Success:^(NSString * _Nonnull meg) {
        weakself.msg = meg;
    }];
}

-(void)countTime{
    if (m_second == 1) {
        [m_timer invalidate];
        m_second = 60;
        [_eyeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_eyeBtn setUserInteractionEnabled:YES];
        [_eyeBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        m_second--;
        NSString *title = [NSString stringWithFormat:@"重新获取(%d)",m_second];
        [_eyeBtn setUserInteractionEnabled:NO];
        [_eyeBtn setTitle:title forState:UIControlStateNormal];
        [_eyeBtn setBackgroundColor:UIColorFromRGB(0xababab)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)loginClick{
//    设置提现密码
    
    if (_password.text.length&&_secret.text.length) {
        if (![_msg isEqualToString:_secret.text]) {
            [CNManager showWindowAlert:@"验证码错误"];
            return;
        }
    }else{
        [CNManager showWindowAlert:@"验证码错误"];
        return;
    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"id"];
    [dataDict setObject:_password.text forKey:@"pwd"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/resetTxPwd",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
            WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:@"设置成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
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

- (void)judgePassWord{
    //先去掉两端的空格
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.secret.text=[self.secret.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    
        if (_password.text.length && _secret.text.length) {
            _loginBtn.userInteractionEnabled = YES;
            _loginBtn.backgroundColor = [UIColor orangeColor];
        }else{
            _loginBtn.userInteractionEnabled = NO;
            _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        }
    
}
- (void)hiddenKey{
    [self.view endEditing:YES];
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
