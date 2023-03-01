//
//  CHRegistViewController.m
//  LU
//
//  Created by peng jin on 2019/5/10.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHRegistViewController.h"
#import "CHGetStockNum.h"
#import "CHWebDetailViewController.h"

@interface CHRegistViewController () <UITextFieldDelegate>
{
    NSTimer *m_timer;
    NSInteger m_second;
    NSString * c_phone;
}
@property (nonatomic ,strong)UITextField *name;
@property (nonatomic ,strong)UITextField *phone;
@property (nonatomic ,strong)UITextField *secret;
@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UITextField *invite;
//@property (nonatomic ,strong)UIImageView *iconIV;
@property (nonatomic ,strong)UIButton    *eyeBtn;
@property (nonatomic ,strong)UIButton    *loginBtn;
@property (nonatomic ,strong)UIButton    *fogetBtn;
@property (nonatomic ,strong)NSString    *msg;
//@property (nonatomic ,strong)UIButton    *regBtn;

@end

@implementation CHRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) Target:self SEL:@selector(hiddenKey) Title:@"" ImageName:@"" bgImage:@"" Tag:0];
    [self.view addSubview:btn];
//    [self.view addSubview:self.iconIV];
    if (_isReg) {
        [self.view addSubview:self.name];
    }
    
    [self.view addSubview:self.phone];
    [self.view addSubview:self.secret];
    [self.view addSubview:self.password];
    [self.view addSubview:self.invite];
    [self.view addSubview:self.eyeBtn];
    [self.view addSubview:self.loginBtn];
    if (_isReg) {
        [self.view addSubview:self.fogetBtn];
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(_phone.x, _fogetBtn.y, 120, 30) Font:10 Text:@"点击注册即表示您同意"];
        lb.textColor  = UIColorFromRGB(0x888888);
        [self.view addSubview:lb];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_name];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_invite];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_secret];
    
    // Do any additional setup after loading the view.
}

- (UITextField *)name{
    if (!_name) {
        _name = [JPMyControl createTextFieldWithFrame:CGRectMake(30, StatusBarAndNavigationBarHeight + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入用户名" sucureTextEntry:NO];
        _name.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
        _name.delegate = self;
    }
    return _name;
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(30, StatusBarAndNavigationBarHeight + 40 + (_name?_name.height + 40:0), MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入手机号码" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
//        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
//        [_phone addSubview:line];
        _phone.delegate = self;
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
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _secret.y+_secret.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:_isReg ? @"密码由6-18位字母、数字组成":@"请输入新密码（设置6-18位字母、数字）" sucureTextEntry:NO];
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
        _eyeBtn.userInteractionEnabled = NO;
        _eyeBtn.layer.masksToBounds = YES;
        _eyeBtn.layer.cornerRadius = 3.;
        _eyeBtn.backgroundColor = UIColorFromRGB(0xababab);
//        _eyeBtn.userInteractionEnabled = YES;
        _eyeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _eyeBtn;
}

- (UIButton *)fogetBtn{
    if (!_fogetBtn) {
        _fogetBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x + 100 , _loginBtn.y + _loginBtn.height + 10, 140, 30) Target:self SEL:@selector(fogetBtnClick) Title:@"《长牛财富注册服务协议》" ImageName:@"" bgImage:@"" Tag:0];
        _fogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _fogetBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_fogetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _fogetBtn;
}


- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x, _invite.y + _invite.height + 40 , _phone.width, 38) Target:self SEL:@selector(loginClick) Title:_isReg ? @"注册":@"确认" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (UITextField *)invite{
    if (!_invite) {
        _invite = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _password.y+_password.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:_isReg? @"邀请人手机号（非必填）":@"请确认新密码（设置6-18位字母、数字）" sucureTextEntry:NO];
        _invite.clearButtonMode = UITextFieldViewModeWhileEditing;
        _invite.delegate = self;
    }
    return _invite;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= _isReg? @"注册" : @"忘记密码";
    
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
    if (!_phone.text.length) {
        return;
    }
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    m_second = 60;
    c_phone = _phone.text;
    WEAKSELF
    [CHGetStockNum getShotMessage:_phone.text type:_isReg?1:2 Success:^(NSString * _Nonnull meg) {
        weakself.msg = meg;
    }];
    
//    NSLog(@"2222");
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

- (void)fogetBtnClick{
    //跳转协议页面
    CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
    vc.chTitile = @"长牛财富注册服务协议";
    vc.urlString = [CHConfig regHelpPage];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)loginClick{
    //注册
//    c_phone = _phone.text;
//    [CHGetStockNum getUserInfobyPhone:c_phone];
//    return;
    if (_password.text.length&&_phone.text.length&&_msg.length) {
//        [CNManager saveObject:@"1" byKey:@"AppLoginOK"];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        if (![_msg isEqualToString:_secret.text]) {
            [CNManager showWindowAlert:@"验证码错误"];
            return;
        }
        if (![c_phone isEqualToString:_phone.text]){
            [CNManager showWindowAlert:@"您的手机号和验证码不符"];
            return;
        }
        
    }else{
        [CNManager showWindowAlert:@"请输入完整信息"];
        return;
    }
    
    if (!_isReg) {
        if (![_invite.text isEqualToString:_password.text]) {
            [CNManager showWindowAlert:@"两次输入密码不一致"];
            return;
        }
    }
    
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:_phone.text forKey:@"phone"];
    [dataDict setObject:_password.text forKey:_isReg? @"password":@"pwd"];
    if (_isReg) {
        [dataDict setObject:_name.text forKey:@"nick_name"];
        if (_invite.text.length) {
            [dataDict setObject:_name.text forKey:@"invite_user"];
        }
    }
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:_isReg? @"http://%@/Api/member/RegistMemeber":@"http://%@/Api/member/PwdReset",
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
                [CNManager showWindowAlert:weakself.isReg?@"注册成功,请到登录页面登录使用":@"修改成功,请到登录页面登录使用"];
//                [CHGetStockNum getUserInfobyPhone:self->c_phone];
                [self.navigationController popViewControllerAnimated:YES];
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
//    self.name.text =[self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.secret.text=[self.secret.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.invite.text = [self.invite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    if (_isReg) {
        if (_name.text.length&&_phone.text.length && _password.text.length && _secret.text.length) {
            _loginBtn.userInteractionEnabled = YES;
            _loginBtn.backgroundColor = [UIColor orangeColor];
        }else{
            _loginBtn.userInteractionEnabled = NO;
            _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        }
    }else{
        if (_phone.text.length && _password.text.length && _secret.text.length && _invite.text.length) {
            _loginBtn.userInteractionEnabled = YES;
            _loginBtn.backgroundColor = [UIColor orangeColor];
        }else{
            _loginBtn.userInteractionEnabled = NO;
            _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        }
    }
    if (_phone.text.length) {
        _eyeBtn.userInteractionEnabled = YES;
        _eyeBtn.backgroundColor = [UIColor orangeColor];
    }else{
        _eyeBtn.userInteractionEnabled = NO;
        _eyeBtn.backgroundColor = UIColorFromRGB(0xababab);
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
