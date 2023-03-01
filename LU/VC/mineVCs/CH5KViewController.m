//
//  CH5KViewController.m
//  LU
//
//  Created by peng jin on 2019/11/14.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CH5KViewController.h"
#import "CHLoginViewController.h"
#import "CHTureNameViewController.h"
#import "CHPayPageViewController.h"
#import "CHSearchViewController.h"

@interface CH5KViewController ()
@property (nonatomic , strong) UIScrollView * homeSC;
@property (nonatomic , strong) UIImageView  * IV;
@property (nonatomic , strong) UIButton     * buyBtn;
@property (nonatomic)          NSInteger    activeType;
@end

@implementation CH5KViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.homeSC];
    
    // Do any additional setup after loading the view.
}

- (UIScrollView *)homeSC{
    if (!_homeSC) {
        _homeSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        [_homeSC addSubview:self.IV];
        _homeSC.userInteractionEnabled = YES;
    }
    return _homeSC;
}

- (UIImageView *)IV{
    if (!_IV) {
        UIImage * im = [UIImage imageNamed:@"5k"];
        CGFloat h = im.size.height/im.size.width * MAINWIDTH;
        
        _IV = [JPMyControl createImageViewWithFrame:CGRectMake(0, 0, MAINWIDTH, h) ImageName:@""];
        _IV.image = im;
        _IV.userInteractionEnabled = YES;
        _homeSC.contentSize = _IV.size;
       
        [_IV addSubview:self.buyBtn];
        
//        UIImage * img =[MXManager convertViewToImage:vii];
    }
    return _IV;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        CGFloat h = 1265. * MULTIPLE375;
        _buyBtn = [JPMyControl createButtonWithFrame:CGRectMake(20, 0, MAINWIDTH - 40, 35) Target:self SEL:@selector(buyClick) Title:@"点击参与" ImageName:@"" bgImage:@"" Tag:0];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _buyBtn.center = CGPointMake(MAINWIDTH/2., h);
        _buyBtn.backgroundColor = [UIColor orangeColor];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 4.;
        //@"立即充值" @"立即登陆" @"立即申请"
    }
    return _buyBtn;
}


- (void)buyClick{
    if (![CNManager hasLogin]) {
            CHLoginViewController *vc = [[CHLoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [CNManager showWindowAlert:@"请先登录"];
            return;
        }
    if (![CNManager hasRealName]) {
            CHTureNameViewController *vc = [[CHTureNameViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [CNManager showWindowAlert:@"请先进行实名认证"];
            return;
        }
    if ([[CNManager loadByKey:MONEY]floatValue]<1.) {
        CHPayPageViewController *vc = [[CHPayPageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [CNManager showWindowAlert:@"您的账户余额不足，请充值"];
        return;
        
    }
    
    switch (_activeType) {
        case 1:
            {
                CHPayPageViewController *vc = [[CHPayPageViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [CNManager showWindowAlert:@"您的账户余额不足，请充值"];
                return;
            }
            break;
        case 2:
            {
                [CNManager showWindowAlert:@"您尚未获得资格，请拨打客服电话获取资格"];
                 NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[CHConfig hotPhoneNumber]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                return;
            }
        case 3:
            {
                [CNManager showWindowAlert:@"本活动每个用户只能参加一次"];
                return;
            }
        default:
            break;
    }
    
    [CNManager saveObject:@"1" byKey:JOIN5K];
    CHSearchViewController * vc = [[CHSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"5000元体验金";
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
}

- (void)backClick{
    [CNManager saveObject:nil byKey:JOIN5K];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    if (![CNManager hasLogin]) {
//        CHLoginViewController * vc = [[CHLoginViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
//    self.buyBtn.userInteractionEnabled = NO;
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    //其中 必填项为：uid(用户ID)， phone(用户手机号),code(请求第三方接口的 股票代码前面带字母的那个 股票代码), name(股票名称), price(股票单价), count(股票数量), rid(执行默认策略ID)，, 以上参数,都放入到 data 加密后传入后台。
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/activity/activityQuota",
                          [NewSettingsManager applicationServerURL]];//手动交易
//    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/xtp/submit",
//                          [NewSettingsManager applicationServerURL]];//自动交易

    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
        WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:responseObject[@"msg"]];
//                [self.navigationController popViewControllerAnimated:YES];
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    weakself.activeType = [dic[@"type"] integerValue];
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
//                 weakself.buyBtn.userInteractionEnabled = YES;
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
//        weakself.buyBtn.userInteractionEnabled = YES;
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
