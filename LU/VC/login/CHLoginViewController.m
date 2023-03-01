//
//  CHLoginViewController.m
//  LU
//
//  Created by peng jin on 2019/5/10.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHLoginViewController.h"
#import "CHRegistViewController.h"
#import "CHGetStockNum.h"
@interface CHLoginViewController () <UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *phone;
@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UIImageView *iconIV;
@property (nonatomic ,strong)UIButton    *eyeBtn;
@property (nonatomic ,strong)UIButton    *loginBtn;
@property (nonatomic ,strong)UIButton    *fogetBtn;
@property (nonatomic ,strong)UIButton    *regBtn;
//@property (nonatomic ,strong)UIButton    *eyeBtn;
@property (nonatomic)        BOOL         showMoney;
@end

@implementation CHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SettingsManager getLocalIP];
    [self setupNav];
    UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) Target:self SEL:@selector(hiddenKey) Title:@"" ImageName:@"" bgImage:@"" Tag:0];
    [self.view addSubview:btn];
    [self.view addSubview:self.iconIV];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.password];
    [self.view addSubview:self.eyeBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.fogetBtn];
    [self.view addSubview:self.regBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    // Do any additional setup after loading the view.
}
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [JPMyControl createImageViewWithFrame:CGRectMake((MAINWIDTH - 100)/2., StatusBarAndNavigationBarHeight + 40 , 100, 100) ImageName:@"使馆留学选中"];
    }
    
    return _iconIV;
}
- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _iconIV.y+_iconIV.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"手机号码" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        [_phone addSubview:line];
        _phone.delegate = self;
    }
    return _phone;
}

- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _phone.y+_phone.height + 40, MAINWIDTH - 100, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"登录密码" sucureTextEntry:NO];
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        [_password addSubview:line];
        _password.userInteractionEnabled = YES;
        _password.delegate = self;
    }
    return _password;
}

- (UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [JPMyControl createButtonWithFrame:CGRectMake(_password.width + _password.x + 5 , _password.y- 5, 30, 20) Target:self SEL:@selector(eyeBtnClick) Title:@"" ImageName:@"" bgImage:@"隐藏密码" Tag:0];
        _eyeBtn.userInteractionEnabled = YES;
    }
    return _eyeBtn;
}

- (UIButton *)fogetBtn{
    if (!_fogetBtn) {
        _fogetBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x , _loginBtn.y + _loginBtn.height + 10, 80, 30) Target:self SEL:@selector(fogetBtnClick) Title:@"忘记密码" ImageName:@"" bgImage:@"" Tag:0];
        _fogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _fogetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fogetBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    return _fogetBtn;
}

- (UIButton *)regBtn{
    if (!_regBtn) {
        _regBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x + _phone.width - 80, _loginBtn.y + _loginBtn.height + 10, 80, 30) Target:self SEL:@selector(regBtnClick) Title:@"注册" ImageName:@"" bgImage:@"" Tag:0];
        _regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _regBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_regBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    return _regBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x, _password.y + _password.height + 40 , _phone.width, 38) Target:self SEL:@selector(loginClick) Title:@"登录" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"登录";
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)eyeBtnClick{
    _showMoney = !_showMoney;
    if (!_showMoney) {
        [_eyeBtn setBackgroundImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateNormal];
        _password.secureTextEntry = NO;
    }else{
        [_eyeBtn setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
        _password.secureTextEntry = YES;
    }
}

- (void)fogetBtnClick{
    CHRegistViewController * vc = [[CHRegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)regBtnClick{
    CHRegistViewController * vc = [[CHRegistViewController alloc]init];
    vc.isReg = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loginClick{
    if (_password.text.length&&_phone.text.length) {
        
    }else{
        return;
    }
    
    
        JKEncrypt * en = [[JKEncrypt alloc]init];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
        [dataDict setObject:_phone.text forKey:@"phone"];
        [dataDict setObject:_password.text forKey:@"password"];
        //    [dataDict setObject:_name.text forKey:@"nick_name"];
        NSString *dataString = [CNManager convertToJsonData:dataDict];
        [dataString URLEncodedString];
        NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
        NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/LoginMember",
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
//                    NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
//                    NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
//                    if ([data length]&&[ref length]&&(data)&&(ref)) {
//                        JKEncrypt * en1 = [[JKEncrypt alloc]init];
//                        NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
//
//                        NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
//                    }
                    [CHGetStockNum getUserInfobyPhone:weakself.phone.text Success:^(NSDictionary * _Nonnull userDic) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{

                                 [CNManager saveObject:@"1" byKey:@"AppLoginOK"];
                                 [CNManager showWindowAlert:@"登录成功"];
                                 [CNManager getConf];
                             });
                        
                        
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                    
                    
                    //                NSString * str = dic[@"code"];
                    
                    
                }else{
                    [CNManager showWindowAlert:responseObject[@"msg"]];
                }
            }
            //        NSLog(@"");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CNManager showWindowAlert:@"操作失败"];
            NSLog(@"error slider");
        }];
    
    
    
}

- (void)judgePassWord{
    //先去掉两端的空格
    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    if (_phone.text.length && _password.text.length) {
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
