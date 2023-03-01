//
//  CHDetailPageSZViewController.m
//  LU
//
//  Created by peng jin on 2019/6/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHDetailPageSZViewController.h"

@interface CHDetailPageSZViewController ()
@property (nonatomic ,strong) UILabel * titleLb;
@property (nonatomic ,strong) UILabel * num;

@property (nonatomic ,strong) UILabel * help;

@property (nonatomic ,strong) NSString * stockNum;
@property (nonatomic ,strong) NSString * iceNum;
@property (nonatomic ,strong) NSString * getNum;
@property (nonatomic)         BOOL       isDYF;
@property (nonatomic)         BOOL       isBK;
@end

@implementation CHDetailPageSZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.titleLb];
    [self.view addSubview:self.num];
    if ([_detailDic[@"type"] integerValue] == 8) {
        self.isBK = YES;
        self.getNum = @"0.00";
        self.iceNum = @"0.00";
        [self setUI];
    }else if ([_detailDic[@"status"] integerValue] == 11) {
        self.getNum = @"0.00";
        self.iceNum = @"0.00";
        self.isDYF = YES;
        [self setUI];
    }else{
        [self loadData];
    }
    
    self.help = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT - 120, MAINWIDTH, 60) Font:9 Text:[NSString stringWithFormat: @"如有疑问请拨打客服电话\n%@\n工作时间：周一至周五9:00-18:00",[CHConfig hotPhoneNumber]]];
    _help.numberOfLines = 0;
    _help.textAlignment = NSTextAlignmentCenter;
    _help.textColor = UIColorFromRGB(0xaaaaaa);
    [self.view addSubview:self.help];

    
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
    NSArray * titleArr = @[@"时间",@"类型",@"详情",@"保证金",_isGet?@"策略盈亏":@"管理费"];
    NSArray * infoArr;
     infoArr = @[_detailDic[@"time"],[NSString stringWithFormat:@"股票平仓卖出%@%@",_detailDic[@"stock_name"],_detailDic[@"code"]],[NSString stringWithFormat:@"股票平仓卖出%@%@%@股",_detailDic[@"code"],_detailDic[@"stock_name"],_stockNum],_iceNum,_getNum];
    if (!_isGet) {
        infoArr = @[_detailDic[@"time"],[NSString stringWithFormat:@"买入T+1股票%@%@",_detailDic[@"stock_name"],_detailDic[@"code"]],[NSString stringWithFormat:@"买入T+1股票%@%@%@股",_detailDic[@"code"],_detailDic[@"stock_name"],_stockNum],_iceNum,_getNum];
    }
    if (_isDYF) {
        infoArr = @[_detailDic[@"time"],[NSString stringWithFormat:@"%@(%@)自动递延成功",_detailDic[@"stock_name"],_detailDic[@"code"]],[NSString stringWithFormat:@"自动递延成功，递延费:%@",_detailDic[@"money"]],_iceNum,_getNum];
        titleArr =  @[@"时间",@"类型",@"详情"];
    }
    if (_isBK) {
        infoArr = @[_detailDic[@"time"],[NSString stringWithFormat:@"%@(%@)补亏成功",_detailDic[@"stock_name"],_detailDic[@"code"]],[NSString stringWithFormat:@"补亏成功，补亏金额:%@",_detailDic[@"money"]],_iceNum,_getNum];
        titleArr =  @[@"时间",@"类型",@"详情"];
    }
    for (int i = 0; i< titleArr.count; i++) {
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(15, _num.y+_num.height + 40 + i* 30., 70, 30) Font:12 Text:titleArr[i]];
        lb.textColor = UIColorFromRGB(0x999999);
        [self.view addSubview:lb];
        UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake( lb.x + lb.width + 10 , lb.y, MAINWIDTH - (lb.x + lb.width + 25), 30) Font:11 Text:infoArr[i]];
        lb2.textColor = UIColorFromRGB(0x666666);
        lb2.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:lb2];
    }
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [JPMyControl createLabelWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 40 , MAINWIDTH, 40) Font:18 Text:_isGet?@"收入":@"支出"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UILabel *)num{
    if (!_num) {//数量
        _num = [JPMyControl createLabelWithFrame:CGRectMake(0, _titleLb.y + _titleLb.height + 20 , MAINWIDTH, 40) Font:30 Text:[NSString stringWithFormat:_isGet?@"+%@" :@"-%@",_detailDic[@"money"]]];
        _num.textAlignment = NSTextAlignmentCenter;
    }
    return _num;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    self.title= @"交易明细";
    
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

- (void)loadData{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    //参数都必须放入到 data 参数里面传给后台 ，其中 必填项为：uid(用户ID)， source(资源编号) , 以上参数,都放入到 data 加密后传入后台。返回的数据结果的说明【{ "order_no": "20190624140245207", // 订单编号 "types": [ // 下面的 收支明细 { "money": "936.00", // 金额 "typeName": "策略盈亏" // 标签名 }, { "money": "1755.00", "typeName": "保证金" } ], "code": "002012", // 股票代码 "stock_name": "凯恩股份", // 股票名称 "money": 2691, // 总金额 "stock_count": 3000, // 购买股票的总个数 "time": 2019-06-26 10:47:13, // 时间 "type": 2, "stock_code": "sz002012", "status": 1 }】
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_detailDic[@"source"] forKey:@"source"];
    [dataDict setObject:_isGet?@"1":@"2" forKey:@"sta"];
//    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPageSR] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/getBudgetById",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [weakself.tableView.mj_header endRefreshing];
//        [weakself.tableView.mj_footer endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    
//                    NSArray *tmpArr= dic[@"list"];
                    if ([dic[@"status"] integerValue ] == 2) {
                        weakself.stockNum = [NSString stringWithFormat:@"%@",dic[@"stock_count"]];
                        NSArray * arr= dic[@"types"];
                        if (arr.count>1) {
                            for (int i = 0; i< arr.count; i++) {
                                NSDictionary * dicTmp = arr[i];
                                NSInteger x = [dicTmp[@"type"] integerValue];
                                if (x == 4) {
                                    weakself.getNum = [NSString stringWithFormat:@"%@",dicTmp[@"money"]];
                                }
                                if (x == 1) {
                                    weakself.iceNum = [NSString stringWithFormat:@"%@",dicTmp[@"money"]];
                                }
                            }
                            
                            
                            [weakself setUI];
                        }
                    }
                    
                    if ([dic[@"status"] integerValue ] == 1) {
                        weakself.stockNum = [NSString stringWithFormat:@"%@",dic[@"stock_count"]];
                        NSArray * arr= dic[@"types"];
                        if (arr.count>1) {
                            
                            for (int i = 0; i< arr.count; i++) {
                                NSDictionary * dicTmp = arr[i];
                                NSInteger x = [dicTmp[@"type"] integerValue];
                                if (x == 2) {
                                    weakself.getNum = [NSString stringWithFormat:@"%@",dicTmp[@"money"]];
                                }
                                if (x == 1) {
                                    weakself.iceNum = [NSString stringWithFormat:@"%@",dicTmp[@"money"]];
                                }
                            }
                            [weakself setUI];
                        }
                    }
//                    if ([dic[@"status"] integerValue ] == 11) {
//                        weakself.stockNum = [NSString stringWithFormat:@"%@",dic[@"stock_count"]];
//                        NSArray * arr= dic[@"types"];
//                        if (arr.count>1) {
//                            weakself.iceNum = [NSString stringWithFormat:@"%@",arr[1][@"money"]];
//                            weakself.getNum = [NSString stringWithFormat:@"%@",arr[0][@"money"]];
//                            [weakself setUI];
//                        }
//                    }
//                    weakself.iceNum = [NSString stringWithFormat:@""]
//                    [weakself setUI];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
