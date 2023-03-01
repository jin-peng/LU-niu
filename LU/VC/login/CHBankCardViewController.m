//
//  CHBankCardViewController.m
//  LU
//
//  Created by peng jin on 2019/6/18.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHBankCardViewController.h"

@interface CHBankCardViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UILabel     *name;
@property (nonatomic ,strong)UILabel     *realName;
@property (nonatomic ,strong)UITextField *phone;
@property (nonatomic ,strong)UILabel  *member;

@property (nonatomic ,strong)UILabel  *bankName;
@property (nonatomic ,strong)UITextField *inputbank;

@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UILabel *price;
@property (nonatomic ,strong)UIButton    *loginBtn;

@end

@implementation CHBankCardViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    for (int i = 0 ; i< 4; i++) {
        UIView * vi = [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 1 + i * 61., MAINWIDTH, 60) bgColor:[UIColor whiteColor]];
        [self.view addSubview:vi];
    }
    [self.view addSubview:self.name];
    [self.view addSubview:self.realName];
    [self.view addSubview:self.member];
    [self.view addSubview:self.phone];
    
    [self.view addSubview:self.bankName];
    [self.view addSubview:self.inputbank];
    
    [self.view addSubview:self.price];
    [self.view addSubview:self.password];
    //    [self.view addSubview:self.invite];
    [self.view addSubview:self.loginBtn];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_inputbank];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(10, StatusBarAndNavigationBarHeight + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"持卡人"]];
    }
    return _name;
}

- (UILabel *)realName{
    if (!_realName) {
        _realName = [JPMyControl createLabelWithFrame:CGRectMake(_name.x+_name.width, StatusBarAndNavigationBarHeight, MAINWIDTH - 120- 40, 60) Font:15 Text:[NSString stringWithFormat:@"%@",[CNManager loadByKey:REALNAME]]];
    }
    return _realName;
}



- (UILabel *)member{
    if (!_member) {
        _member = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y+_name.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"银行卡号"]];
    }
    return _member;
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x, _realName.y+ _realName.height +1, _realName.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"仅支持储蓄卡卡号" sucureTextEntry:NO];
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _phone.background = [UIColor whiteColor];
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _phone.height - .5, _phone.width, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        //        [_phone addSubview:line];
        _phone.delegate = self;
    }
    return _phone;
}

- (UILabel *)bankName{
    if (!_bankName) {
        _bankName = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _member.y+_member.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"银行名称"]];
    }
    return _bankName;
}

- (UITextField *)inputbank{
    if (!_inputbank) {
        _inputbank = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x    , _phone.y+_phone.height + 1, _phone.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入所属银行名称" sucureTextEntry:NO];
        _inputbank.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        //        [_password addSubview:line];
        //        _password.userInteractionEnabled = YES;
        _inputbank.delegate = self;
    }
    return _inputbank;
}


- (UILabel *)price{
    if (!_price) {
        _price = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _bankName.y+_bankName.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"开户行"]];
    }
    return _price;
}

- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x    , _inputbank.y+_inputbank.height + 1, _phone.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入开户支行全名" sucureTextEntry:NO];
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
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(40, _password.y + _password.height + 80 , MAINWIDTH - 80., 38) Target:self SEL:@selector(loginClick) Title:@"确认绑定" ImageName:@"" bgImage:@"" Tag:0];
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
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:[CNManager loadByKey:REALNAME] forKey:@"name"];
    [dataDict setObject:_inputbank.text forKey:@"bank_name"];
    [dataDict setObject:_password.text forKey:@"open_bank"];
    [dataDict setObject:_phone.text forKey:@"card"];
    //【name(持卡人姓名),uid(用户ID), bank_name(所属银行名称), open_bank(开户行), card(银行卡账号)】后台返回成功与否信息根据code==0 证明成功 其他值为失败 来判断。
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/saveUserBankInfo",
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
                [CNManager showWindowAlert:@"绑定成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                //                [weakself getUserInfo];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [CNManager showWindowAlert:@"网络请求失败"];
        [[HudManager sharedHudManager] hideProgressHUD:self.view];
//        NSLog(@"error slider");
    }];
    
    
}

- (void)judgePassWord{
    //先去掉两端的空格
//    self.password.text=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.phone.text=[self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    self.inputbank.text=[self.inputbank.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if ([Utility validatePassaword:self.oldPassWord.text]&&[Utility validatePassword:self.passWord.text]) {
    //    NSInteger ol= self.oldPassWord.text.length;
    //    NSInteger nl= self.passWord.text.length;
    
    if (_password.text.length && _phone.text.length && _inputbank.text.length) {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = [UIColor orangeColor];
    }else{
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
    }
    
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"绑定银行卡";
    
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

@end
