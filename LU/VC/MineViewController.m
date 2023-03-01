//
//  MineViewController.m
//  LU
//
//  Created by peng jin on 2019/4/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "MineViewController.h"
#import "CHLoginViewController.h"
#import "AppDelegate.h"
#import "MXUserSuggestionViewController.h"
#import "CHSettingViewController.h"
#import "CHTradeDetailsViewController.h"
#import "CHPlanViewController.h"
#import "CHFinshedPlanViewController.h"
#import "CHStopPlanViewController.h"
#import "CHWebDetailViewController.h"
#import "CHInfoViewController.h"
#import "CHGetStockNum.h"
#import "CHTureNameViewController.h"
#import "CHPayPageViewController.h"
#import "CHDrawMoneyViewController.h"
#import "CHBankCardViewController.h"
#import "CHEditMoneyCodeViewController.h"
#import "CHYaoQingViewController.h"
#import "CHWaitingPlanViewController.h"

#define HEADERHIGH 80.f
#define MONEYHIGH  140.f
#define PAYHIGH    100.f
#define LISTHIGH   340.f

#define COSTOMRED  [UIColor redColor]
#define COSTOMWHITE  [UIColor whiteColor]
@interface MineViewController (){
    UILabel *lb;
    NSString * moneyNum;
}
@property (nonatomic ,strong)UIButton    * iconIV;
@property (nonatomic ,strong)UILabel     * nameLb;
@property (nonatomic ,strong)UIView      * headerView;
@property (nonatomic ,strong)UIButton    * eyeBtn;
@property (nonatomic ,strong)UILabel     * moneyLb;
@property (nonatomic ,strong)UIButton    * detailBtn;
@property (nonatomic ,strong)UIButton    * investBtn;
@property (nonatomic ,strong)UIButton    * cashOutBtn;
@property (nonatomic ,strong)UIView      * moneyView;
@property (nonatomic ,strong)UIView      * payView;
@property (nonatomic ,strong)UIView      * listView;
@property (nonatomic )BOOL                 showMoney;
@property (nonatomic ,strong)UILabel     * footLabel;
@property (nonatomic ,strong)NSString    * moneyNum;
@property (nonatomic ,strong)UILabel     * infoNum;

@end

@implementation MineViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self comeWhite];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
    if ([CNManager hasLogin]) {
         WEAKSELF
        [self loadMsg];
        NSMutableString * tmpstr = [[NSMutableString alloc]initWithString: [CNManager loadByKey:USERPHONE]];
        [tmpstr replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        self.nameLb.text = tmpstr;
        [CHGetStockNum getUserInfobyPhone:[CNManager loadByKey:USERPHONE] Success:^(NSDictionary * _Nonnull userDic) {
            weakself.moneyNum =[NSString stringWithFormat:@"%@", userDic[@"money"]];
            weakself.moneyLb.text = [NSString stringWithFormat:@"%.2f",[weakself.moneyNum floatValue]];
        }];
//        if ([CNManager loadByKey:LOGINUSERPHOTO]) {
////            [_iconIV setImage:[UIImage imageWithData:[CNManager loadByKey:LOGINUSERPHOTO]] forState:UIControlStateNormal];
//        }
    }
    
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self comeClear];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self comeClear];;
    if (![CNManager hasLogin]) {
        [CNManager saveObject:@"1" byKey:@"showLogin"];
        [self.navigationController.tabBarController setSelectedIndex:0];
    }
}

- (void)comeClear{
    UIColor *color =[UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, _MainScreen_Width, StatusBarAndNavigationBarHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    [self.view insertSubview:self.alphaView belowSubview:self.navigationController.navigationBar];
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.moneyView];
    [self.view addSubview:self.payView];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.footLabel];
    // Do any additional setup after loading the view.
}
- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, _listView.y+_listView.height - 20, MAINWIDTH, 40) Font:10 Text:[NSString stringWithFormat: @"如有疑问请拨打客服电话\n%@\n工作时间：周一至周五9:00-18:00",[CHConfig hotPhoneNumber]]];
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.numberOfLines = 3;
        _footLabel.textColor = UIColorFromRGB(0xa0a0a0);
    }
    return _footLabel;
}
- (UIView *)payView{
    if (!_payView) {
        _payView = [JPMyControl createViewWithFrame:CGRectMake(20, _moneyView.y + _moneyView.height - PAYHIGH/2., MAINWIDTH - 40., PAYHIGH) bgColor:COSTOMWHITE];
        _payView.layer.cornerRadius = 6.;
        _payView.layer.masksToBounds = YES;
        CGFloat x = (_payView.width- 40 - 80)/3.;
        NSArray * arr = @[@"明细",@"充值", @"提现"];
        NSArray * imageArr = @[@"明细",@"充值", @"提现"];
        for (int i = 0; i<3; i++) {
            UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(20. + i*(40.+x), 20, x, 60) Target:self SEL:@selector(buyClick:) Title:arr[i] ImageName:imageArr[i] bgImage:@"" Tag:200+i];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(+30, -x, -30, -20)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, +5, +10, -5)];            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.];
            [_payView addSubview:btn];
        }
    }
    return _payView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, BatteryHeight, MAINWIDTH, HEADERHIGH) bgColor:COSTOMRED];
        [_headerView addSubview:self.iconIV];
        [_headerView addSubview:self.nameLb];
    }
    return _headerView;
}
- (UIButton *)iconIV{
    if (!_iconIV) {
        _iconIV = [JPMyControl createButtonWithFrame:CGRectMake(20, 15, 50, 50) Target:self SEL:@selector(iconIVClick) Title:@"" ImageName:@"new_log_head_bg" bgImage:@"" Tag:0];
        _iconIV.layer.cornerRadius = _iconIV.height/2.;
        _iconIV.layer.masksToBounds = YES;
        
    }
    return _iconIV;
}

- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [JPMyControl createLabelWithFrame:CGRectMake(_iconIV.x + _iconIV.width + 20, _iconIV.y, MAINWIDTH/2., _iconIV.height) Font:20 Text:@""];
        _nameLb.textColor = COSTOMWHITE;
    }
    return _nameLb;
}

- (UIView *)moneyView{
    if (!_moneyView) {
        _moneyView = [JPMyControl createViewWithFrame:CGRectMake(0, _headerView.height+_headerView.y, MAINWIDTH, MONEYHIGH) bgColor:COSTOMRED];
        lb= [JPMyControl createLabelWithFrame:CGRectMake((MAINWIDTH - 120) /2., 10, 120, 16) Font:16 Text:@"可用余额（元）"];
        lb.textColor = COSTOMWHITE;
        lb.textAlignment = NSTextAlignmentCenter;
        [_moneyView addSubview:lb];
        [_moneyView addSubview:self.eyeBtn];
        [_moneyView addSubview:self.moneyLb];
        [_moneyView addSubview:self.detailBtn];
        [_moneyView addSubview:self.investBtn];
        [_moneyView addSubview:self.cashOutBtn];
    }
    return _moneyView;
}

- (UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [JPMyControl createButtonWithFrame:CGRectMake(lb.x + lb.width , 8, 30, 20) Target:self SEL:@selector(eyeBtnClick) Title:@"" ImageName:@"" bgImage:@"隐藏密码" Tag:0];
    }
    return _eyeBtn;
}

- (UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [JPMyControl createLabelWithFrame:CGRectMake(20, _eyeBtn.y+ _eyeBtn.height + 10, MAINWIDTH- 40, 30) Font:30 Text:@"0.00"];
        _moneyLb.textColor = COSTOMWHITE;
        _moneyLb.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLb;
}

- (UIView *)listView{
    if (!_listView) {
        _listView = [JPMyControl createViewWithFrame:CGRectMake(0, _payView.y+_payView.height+10, MAINWIDTH, LISTHIGH + 100.) bgColor:[UIColor clearColor]];
        CGFloat x = (LISTHIGH - 40)/4.;
//        NSArray * arr = @[@"我的策略",@"停牌策略", @"已完成策略",@"邀请有礼",@"风险提示",@"帮助中心",@"意见反馈",@"账号设置"];
//        NSArray * imageArr = @[@"我的策略",@"停牌策略", @"已完成策略",@"邀请有礼",@"风险提示",@"帮助",@"客服中心",@"设置"];
        NSArray * arr = @[@"持仓中", @"已卖出",@"交易等待中",@"风险提示",@"帮助中心",@"意见反馈",@"账号设置"];
        NSArray * imageArr = @[@"我的策略", @"已完成策略",@"waiting",@"风险提示",@"帮助",@"客服中心",@"设置"];
        for (int i = 0; i<arr.count; i++) {
            UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(20 + (i%2)*MAINWIDTH/2., 20 + x * (i/2), (MAINWIDTH-40)/2., 60) Target:self SEL:@selector(listClick:) Title:arr[i] ImageName:imageArr[i] bgImage:@"" Tag:100+i];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18.];
            [_listView addSubview:btn];
        }
    }
    return _listView;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xf3f3f3);
//    self.title=@"个人中心";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    //    [backButton setImage:[UIImage imageNamed:@"photo_title_btn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed: @"消息图标"] forState:UIControlStateNormal];
    self.infoNum = [JPMyControl createLabelWithFrame:CGRectMake(backButton.width-7,  +5, 15, 15) Font:8 Text:@""];
    _infoNum.hidden = YES;
    _infoNum.backgroundColor = [UIColor orangeColor];
    _infoNum.textColor = [UIColor whiteColor];
    _infoNum.textAlignment = NSTextAlignmentCenter;
    _infoNum.layer.masksToBounds = YES;
    _infoNum.layer.cornerRadius = _infoNum.height/2.;
    _infoNum.layer.borderColor = [UIColor whiteColor].CGColor;
    _infoNum.layer.borderWidth  = 1.;
    [backButton addSubview:self.infoNum];
//    [backButton setTitleColor:COSTOMWHITE forState:UIControlStateNormal];
    //    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton setTitleColor:COSTOMWHITE forState:UIControlStateNormal];
    
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)iconIVClick{
    
    
}

- (void)buyClick:(UIButton *)button{
    [self comeWhite];
    switch (button.tag -200) {
            
        case 0:{ //明细
            CHTradeDetailsViewController * vc = [[CHTradeDetailsViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            //    vc.questNum = button.tag - 199;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{ //充值
            if ([CNManager loadByKey:REALCODE]) {
                CHPayPageViewController * vc = [[CHPayPageViewController alloc]init];
                //    vc.questNum = button.tag - 199;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                CHTureNameViewController * vc = [[CHTureNameViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:{ //提现
            if (![CNManager loadByKey:REALCODE]){
                CHTureNameViewController * vc = [[CHTureNameViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            if([CNManager loadByKey:BANKCARD]) {
                if (![CNManager hasMoneyCode]) {
                    [CNManager showWindowAlert:@"请先设置提现密码"];
                    CHEditMoneyCodeViewController * vc = [[CHEditMoneyCodeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    CHDrawMoneyViewController * vc = [[CHDrawMoneyViewController alloc]init];
                    //    vc.questNum = button.tag - 199;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else {
                CHBankCardViewController * vc = [[CHBankCardViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        
        default:
            break;
    }
    
    //充值
    
    //提现
}

- (void)listClick:(UIButton *)button{
    NSInteger x = button.tag -100;
    switch (x) {
            
        case 0:{//我的策略
            CHPlanViewController * vc = [[CHPlanViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
//        case 1:{//停牌策略
//            CHStopPlanViewController * vc = [[CHStopPlanViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
            
//            break;
        case 1://已完成策略
        {
            CHFinshedPlanViewController * vc = [[CHFinshedPlanViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 3://邀请有礼
//        {
//            CHYaoQingViewController * vc =[[CHYaoQingViewController alloc]init];
////            vc.chTitile = @"邀请有礼";
////            UIImage *selectedImage = [UIImage imageNamed:@"体验金"];
////            NSString *stringImage = [self htmlForJPGImage:selectedImage];
////            NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
////            NSString *content =[NSString stringWithFormat:
////                                @"<html>"
////                                "<style type=\"text/css\">"
////                                "<!--"
////                                "body{font-size:40pt;line-height:60pt;}"
////                                "-->"
////                                "</style>"
////                                "<body>"
////                                "%@"
////                                "</body>"
////                                "</html>"
////                                , contentImg];
////            [vc.newsWebView loadHTMLString:content baseURL:nil];
//
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 3://风险提示
        {
            CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
            vc.chTitile = @"风险提示";
            vc.urlString = @"http://39.100.77.204/zwtp/index1.html";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://帮助中心
        {
            CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
            vc.chTitile = @"帮助中心";
            vc.urlString = [CHConfig helpPage];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            MXUserSuggestionViewController * vc = [[MXUserSuggestionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 6:{
            CHSettingViewController *vc = [[CHSettingViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
           
            break;
        case 2:{
            CHWaitingPlanViewController *vc = [[CHWaitingPlanViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        default:
            break;
    }
}

- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    
    return [NSString stringWithFormat:@"<img src=\"%@\"  style=\" width:%f; position: absolute; top: 0; left:0; right:0;\">", imageSource,MAINWIDTH];
}
- (void)eyeBtnClick{
    _showMoney = !_showMoney;
    if (!_showMoney) {
        [_eyeBtn setBackgroundImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateNormal];
        _moneyLb.text = [NSString stringWithFormat:@"%.2f",[moneyNum floatValue]];
    }else{
        [_eyeBtn setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
        _moneyLb.text = @"****";
    }
    
    
}

- (void)comeWhite{
    UIColor *color = [UIColor blackColor];
    CGRect rect = CGRectMake(0, 0, _MainScreen_Width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)backClick{
//    [self.navigationController popViewControllerAnimated:YES];
    CHInfoViewController * vc = [[CHInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)loadMsg{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/feedback/getFeedBackListForUser",
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
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSArray *tmpArr= dic[@"list"];
                    
                    if (tmpArr.count) {
                        NSInteger x = 0;
                        for (int i = 0 ; i < tmpArr.count; i++) {
                            if ([tmpArr[i][@"state"] integerValue] == 1) {
                                x++;
                            }
                        }
                        if (x>0) {
                            NSString *strTmp= [NSString stringWithFormat:@"%ld",(long)x];
                            if (x> 9) {
                                strTmp = @"9+";
                            }
                            weakself.infoNum.hidden = NO;
                            weakself.infoNum.text = [NSString stringWithFormat:@"%@",strTmp];
                        }else{
                            weakself.infoNum.hidden = YES;
                        }
                    }
                    //                    NSLog(@"%@",dic);
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        //        NSLog(@"error slider");
    }];
}

@end
