//
//  CHTureNameViewController.m
//  LU
//
//  Created by peng jin on 2019/6/18.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHTureNameViewController.h"
#import "CHGetStockNum.h"

@interface CHTureNameViewController () <UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *phone;
//@property (nonatomic ,strong)UITextField *secret;
@property (nonatomic ,strong)UITextField *password;
//@property (nonatomic ,strong)UITextField *invite;
@property (nonatomic ,strong)UIButton    *loginBtn;

@end

@implementation CHTureNameViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.password];
//    [self.view addSubview:self.invite];
    [self.view addSubview:self.loginBtn];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_invite];
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(30, StatusBarAndNavigationBarHeight + 40 , MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入真实姓名" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
        _phone.delegate = self;
    }
    return _phone;
}


- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(30, _phone.y+_phone.height + 40, MAINWIDTH - 60, 20) Font:14 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入身份证号" sucureTextEntry:NO];
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
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(_phone.x, _password.y + _password.height + 80 , _phone.width, 38) Target:self SEL:@selector(loginClick) Title:@"确认" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)loginClick{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    [[HudManager sharedHudManager] progressHUD:[CNManager loadLanguage:@"请求中…"] activity:YES superView:self.view];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"id"];
    [dataDict setObject:_phone.text forKey:@"realname"];
    [dataDict setObject:_password.text forKey:@"idcard"];
   
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/authentication",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
            WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [[HudManager sharedHudManager] hideProgressHUD:self.view];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:@"认证成功"];
                [CHGetStockNum getUserInfobyPhone:[CNManager loadByKey:USERPHONE]];
                [CNManager saveObject:weakself.phone.text byKey:REALNAME];
                [CNManager saveObject:weakself.password.text byKey:REALCODE];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                //                [weakself getUserInfo];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [CNManager showWindowAlert:@"获取验证码失败"];
         [[HudManager sharedHudManager] hideProgressHUD:self.view];
//        NSLog(@"error slider");
    }];
    
    
}

- (void)judgePassWord{
    //先去掉两端的空格
    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    self.title= @"实名认证";
    
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
