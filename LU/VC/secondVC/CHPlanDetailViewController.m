//
//  CHPlanDetailViewController.m
//  LU
//
//  Created by peng jin on 2019/6/6.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHPlanDetailViewController.h"
#import "CHWebDetailViewController.h"
@interface CHPlanDetailViewController ()
@property (nonatomic, strong)UIScrollView * homeSc;
@property (nonatomic, strong)UILabel * planNum;
@property (nonatomic, strong)UILabel * touzi;
@property (nonatomic, strong)UILabel * dianmai;
@property (nonatomic, strong)NSDictionary * planDic;

@end

@implementation CHPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (UIScrollView *)homeSc{
    if (!_homeSc) {
        _homeSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        _homeSc.contentSize = CGSizeMake(MAINWIDTH, MAINWIDTH);
        NSArray * titles = @[@"策略交易号",@"交易合作",@"交易明细",@"利益分配",@"资金结算"];
        NSArray * hezuo = @[@"投资人",@"点买人"];
        NSArray * hezuoInfo = @[_planDic[@"name"],_planDic[@"realname"]];
        NSArray * mingxi = @[@"股票名称",@"交易本金",@"买入价格",@"卖出价格",@"买入时间",@"卖出时间",@"持仓天数",@"交易数量",@"综合费",@"递延费",@"委托价格",@"委托卖出价格"];
        NSArray * mingxiInfo = @[_planDic[@"stock_name"],[NSString stringWithFormat:@"%.2f",[_planDic[@"market_value"] floatValue]],[NSString stringWithFormat:@"%.2f",[_planDic[@"stock_price"] floatValue]],[NSString stringWithFormat:@"%.2f",[_planDic[@"sell_price"] floatValue]],_planDic[@"time"],_planDic[@"sell_time"],[NSString stringWithFormat:@"%@天",_planDic[@"day"]],[NSString stringWithFormat:@"%@股",_planDic[@"stock_count"]],[NSString stringWithFormat:@"%.2f",[_planDic[@"manager_price"] floatValue]],[NSString stringWithFormat:@"%.2f(%@次)",[_planDic[@"dyf"] floatValue],_planDic[@"dyf_day"]],[NSString stringWithFormat:@"%.2f",[_planDic[@"stock_price"] floatValue]],[NSString stringWithFormat:@"%.2f",[_planDic[@"sell_price"] floatValue]]];
        
        NSArray * liyi = @[@"策略盈亏",@"亏损赔付",@"利益分配",@"补亏总额"];
        NSArray * liyiInfo = @[[NSString stringWithFormat:@"%.2f",[_planDic[@"ying"] floatValue]+[_planDic[@"kui"] floatValue]],[NSString stringWithFormat:@"%.2f",0.],[NSString stringWithFormat:@"%.2f",[_planDic[@"ylfc_money"] floatValue]],[NSString stringWithFormat:@"-%.2f",[_planDic[ @"fl_money"]floatValue]]];//0.改为补亏金额
        NSArray * jiesuan = @[@"冻结",@"退回"];
        NSArray * jiesuanInfo = @[[NSString stringWithFormat:@"%.2f",[_planDic[@"dongjie"] floatValue]],[NSString stringWithFormat:@"%.2f",[_planDic[@"fanhui"] floatValue]]];
        
        CGFloat h = 0;
        for (int i = 0 ; i< titles.count; i++) {
            UILabel * lb= [JPMyControl createLabelWithFrame:CGRectMake(10, h, MAINWIDTH-20, 40) Font:14 Text:titles[i]];
            CGFloat h2 = lb.y+lb.height;
            UIView * vi = [JPMyControl createViewWithFrame:CGRectMake(0, h, MAINWIDTH, lb.height) bgColor:UIColorFromRGB(0xefefef)];
            [_homeSc addSubview:vi];
            [_homeSc addSubview:lb];
            switch (i) {
                case 0:
                {
                    UILabel * num= [JPMyControl createLabelWithFrame:CGRectMake(lb.x, h2, lb.width, lb.height) Font:14 Text:[NSString stringWithFormat: @"%@   T+1",_planDic[@"sell_code"]]];
                    num.userInteractionEnabled = YES;
                    UIButton * xieyi = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH - 100, 0, 80, num.height) Target:self SEL:@selector(xieyiClick) Title:@"合作协议" ImageName:@"" bgImage:@"" Tag:0];
                    [xieyi setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    xieyi.titleLabel.font = [UIFont systemFontOfSize:12];
                    [_homeSc addSubview:num];
                    [num addSubview:xieyi];
                    
                    h = num.height + num.y;
                }
                    break;
                case 1:
                {
                    for (int j = 0; j < hezuo.count; j++) {
                        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(lb.x, h2 + (lb.height-4.) * j, lb.width, lb.height-4.) Font:13 Text:hezuo[j]];
                        lb2.textColor = UIColorFromRGB(0x999999);
                        [self formatLb:lb2 byText:hezuo[j] andInfo:hezuoInfo[j]];
                        [_homeSc addSubview:lb2];
                        if (j == hezuo.count-1) {
                            h = lb2.height + lb2.y;
                        }
                    }
                }
                    break;
                case 2:
                {
                    for (int j = 0; j < mingxi.count; j++) {
                        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(lb.x + j%2 *(MAINWIDTH-20)/2., h2 + j/2*(lb.height-4.), lb.width, lb.height-4.) Font:10 Text:mingxi[j]];
                        lb2.textColor = UIColorFromRGB(0x999999);
                        [self formatLb:lb2 byText:mingxi[j] andInfo:mingxiInfo[j]];
                        [_homeSc addSubview:lb2];
                        if (j == mingxi.count-1) {
                            h = lb2.height + lb2.y;
                        }
                    }
                }
                    break;
                case 3:
                {
                    for (int j = 0; j < liyi.count; j++) {
                        int m = j;
                        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(lb.x + m%2 *(MAINWIDTH-20)/2., h2 + m/2*(lb.height-4.), lb.width, lb.height-4.) Font:13 Text:liyi[j]];
                        lb2.textColor = UIColorFromRGB(0x999999);
                        [self formatLb:lb2 byText:liyi[j] andInfo:liyiInfo[j]];
                        if (j == 0 || j==2) {
                            lb2.textColor = [UIColor redColor];
                            [self formatLb:lb2 byText:liyi[j] andInfo:liyiInfo[j]];
                        }
                        [_homeSc addSubview:lb2];
                        if (j == liyi.count-1) {
                            h = lb2.height + lb2.y;
                        }
                    }
                }
                    break;
                case 4:
                {
                    for (int j = 0; j < jiesuan.count; j++) {
                        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(lb.x, h2 + (lb.height-4.) * j, lb.width, lb.height -4.) Font:13 Text:jiesuan[j]];
                        lb2.textColor = UIColorFromRGB(0x999999);
                        [self formatLb:lb2 byText:jiesuan[j] andInfo:jiesuanInfo[j]];
                        [_homeSc addSubview:lb2];
                        if (j == jiesuan.count-1) {
                            h = lb2.height + lb2.y;
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        }
        _homeSc.contentSize = CGSizeMake(0, h);
    }
    
    return _homeSc;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"已完成订单";
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xieyiClick{
    //跳转协议页
    CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
    vc.chTitile = @"长牛财富策略合作协议";
    vc.urlString = [NSString stringWithFormat: @"http://39.100.77.204/zwtp/xianguan.html?order=%@",_planID];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)formatLb:(UILabel *)lb byText:(NSString *)title andInfo:(NSString *)info{
//    lb.textColor = UIColorFromRGB(0x999999);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@  %@",title,info]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    lb.attributedText = str;
}

- (void)loadData{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_planID forKey:@"order_no"];
//    [dataDict setObject:@"1" forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/rules/getUserRulesDetail",
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
                    
                    weakself.planDic = [CNManager dictionaryWithJsonString:str1];
                    
//                    [weakself refreshPage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view addSubview:self.homeSc];
                    });
                    //                    NSLog(@"%@",dic);
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
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
