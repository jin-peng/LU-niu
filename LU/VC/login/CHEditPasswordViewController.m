//
//  CHEditPasswordViewController.m
//  LU
//
//  Created by peng jin on 2019/5/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHEditPasswordViewController.h"

@interface CHEditPasswordViewController () <UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *phone;
//@property (nonatomic ,strong)UITextField *secret;
@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UITextField *invite;
@property (nonatomic ,strong)UIButton    *loginBtn;


@end

@implementation CHEditPasswordViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.password];
    [self.view addSubview:self.invite];
    [self.view addSubview:self.loginBtn];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_invite];
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(30, StatusBarAndNavigationBarHeight + 40 , MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入旧密码" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
        _phone.delegate = self;
    }
    return _phone;
}


- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _phone.y+_phone.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入新密码（设置6-18位字母、数字）" sucureTextEntry:NO];
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        //        [_password addSubview:line];
        //        _password.userInteractionEnabled = YES;
        _password.delegate = self;
    }
    return _password;
}

- (UITextField *)invite{
    if (!_invite) {
        _invite = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _password.y+_password.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请确认新密码（设置6-18位字母、数字）" sucureTextEntry:NO];
        _invite.clearButtonMode = UITextFieldViewModeWhileEditing;
        _invite.delegate = self;
    }
    return _invite;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x, _invite.y + _invite.height + 40 , _phone.width, 38) Target:self SEL:@selector(loginClick) Title:@"确认" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)loginClick{
    if ([_password.text length]<6 || [_invite.text length]<6) {
        [CNManager showWindowAlert:@"密码长度不能小于6位"];
        return;
    }
    if ([_password.text length]>18 || [_invite.text length]>18) {
        [CNManager showWindowAlert:@"密码长度不能大于18位"];
        return;
    }
    if (![_password.text isEqualToString:_invite.text]) {
        [CNManager showWindowAlert:@"两次密码输入不一致"];
        return;
    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERPHONE] forKey:@"phone"];
    [dataDict setObject:_password.text forKey:@"newpwd"];
    [dataDict setObject:_phone.text forKey:@"oldpwd"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/UpdatePwd",
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
                [CNManager showWindowAlert:@"修改成功"];
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
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.invite.text=[self.invite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    
    if (_password.text.length && _phone.text.length && [_invite.text isEqualToString:_password.text] ) {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = [UIColor orangeColor];
    }else{
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
    }
    
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"修改密码";
    
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
