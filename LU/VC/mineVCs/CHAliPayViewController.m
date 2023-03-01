//
//  CHAliPayViewController.m
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHAliPayViewController.h"
#import "CHAlipayHelpViewController.h"

@interface CHAliPayViewController () <UITextFieldDelegate>
@property (nonatomic ,strong)UILabel     *name;
@property (nonatomic ,strong)UILabel     *realName;
@property (nonatomic ,strong)UITextField *phone;
@property (nonatomic ,strong)UILabel  *member;
@property (nonatomic ,strong)UITextField *password;
@property (nonatomic ,strong)UILabel *price;
@property (nonatomic ,strong)UIButton    *loginBtn;
@property (nonatomic ,strong)NSDictionary * infoDic;

@end

@implementation CHAliPayViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadBankInfo];
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
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_phone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_password];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_invite];
}

- (UILabel *)name{
    if (!_name) {
        _name = [JPMyControl createLabelWithFrame:CGRectMake(10, StatusBarAndNavigationBarHeight + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:_isWX?@"微信实名":@"支付宝实名"]];
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
        _member = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _name.y+_name.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:_isWX?@"微信账号":@"支付宝账号"]];
    }
    return _member;
}

- (UITextField *)phone{
    if (!_phone) {
        _phone = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x, _realName.y+ _realName.height +1, _realName.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入支付宝账号" sucureTextEntry:NO];
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
        _price = [JPMyControl createLabelWithFrame:CGRectMake(_name.x, _member.y+_member.height + 1, 120, 60) Font:15 Text:[NSString stringWithFormat:@"充值金额(元)"]];
    }
    return _price;
}

- (UITextField *)password{
    if (!_password) {
        _password = [JPMyControl createTextFieldWithFrame:CGRectMake(_realName.x    , _phone.y+_phone.height + 1, _phone.width, 60) Font:15 TextColor:UIColorFromRGB(0x333333) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"请输入充值金额" sucureTextEntry:NO];
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        _password.keyboardType = UIKeyboardTypeNumberPad;

        //        UIView *line = [JPMyControl createViewWithFrame:CGRectMake(0, _password.height - .5, _password.width + 40, .5) bgColor:UIColorFromRGB(0x999999)];
        //        [_password addSubview:line];
        //        _password.userInteractionEnabled = YES;
        _password.delegate = self;
    }
    return _password;
}



- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(40, _password.y + _password.height + 80 , MAINWIDTH - 80., 38) Target:self SEL:@selector(loginClick) Title:@"转账" ImageName:@"" bgImage:@"" Tag:0];
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(0xababab);
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
        
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(_loginBtn.x, _loginBtn.y+_loginBtn.height + 10, _loginBtn.width, 40) Font:9 Text:[NSString stringWithFormat:@"关于%@:\n工作日09：00-18:00充值5分钟内处理，非交易工作日充值会在下一个交易日09:30前处理",_isWX?@"微信扫码支付":@"支付宝转账"]];
        lb.numberOfLines = 0;
        lb.textColor = UIColorFromRGB(0x999999);
        [self.view addSubview:lb];
    }
    return _loginBtn;
}

- (void)loginClick{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    //前端发送请求操作，请求的参数 包含【name(支付宝 账号姓名),uid(用户ID), account(支付宝账号), money(充值金额)，type(充值类型 1支付宝3微信)】后台返回成功与否信息根据code==0 证明成功 其他值为失败 来判断。
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_isWX?@"3":@"1" forKey:@"type"];
    [dataDict setObject:_realName.text forKey:@"name"];
    [dataDict setObject:_phone.text forKey:@"account"];
    [dataDict setObject:_password.text forKey:@"money"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/toPay",
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
                [CNManager showWindowAlert:@"申请成功"];
                //跳转说明页；
                CHAlipayHelpViewController * vc= [[CHAlipayHelpViewController alloc]init];
                vc.isWX = weakself.isWX;
                vc.infoDic = weakself.infoDic;
                [weakself.navigationController pushViewController:vc animated:YES];
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
    self.title= _isWX?@"微信扫码支付":@"支付宝转账";
    
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

- (void)loadBankInfo{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:_isWX?@"2":@"0" forKey:@"type"];
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
//                    NSArray *tmpArr= dic[@"list"];
//                   NSLog(@"");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
