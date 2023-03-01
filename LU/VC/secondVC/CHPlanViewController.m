//
//  CHPlanViewController.m
//  LU
//
//  Created by peng jin on 2019/4/29.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHPlanViewController.h"
#import "CHMyPlanDetailViewController.h"
#import <MJRefresh.h>
#import "CHMyPlanTableViewCell.h"
#import "CHPayPageViewController.h"
#import "CHGetStockNum.h"
@interface CHPlanViewController () <UIAlertViewDelegate>{
    UITextField * tfName;
    UITextField * tfCode;
    UITextField * tfSupply;
    __block CGFloat bk;
    __block CGFloat mairu;
    __block CGFloat zy;
    __block CGFloat zs;
    __block CGFloat nowzy;
    __block CGFloat nowzs;
    __block NSInteger nowPage;
    __block NSString * sellFlag;
}
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * priceArray;
@property (nonatomic ,strong)UILabel * noBuyLabel;
@property (nonatomic,strong) UILabel *chicang;
@property (nonatomic,strong) UILabel *yingkui;
@property (nonatomic)     __block   CGFloat  flowNum;
@property (nonatomic,strong) __block NSString * nowId;
@property (nonatomic,strong) NSDictionary * userPlan;
@end

@implementation CHPlanViewController
@synthesize tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    nowPage = 1;
    [self.view addSubview:self.chicang];
    [self.view addSubview:self.yingkui];
//    [self.view addSubview:self.noBuyLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    [self loadData];
    WEAKSELF
    [CHGetStockNum getUserPlan:[CNManager loadByKey:USERPHONE] Success:^(NSDictionary * _Nonnull planDic) {
        weakself.userPlan = planDic;
    }];
    // Do any additional setup after loading the view.
}

- (UILabel *)chicang{
    if (!_chicang) {
        _chicang = [JPMyControl createLabelWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH , 40) Font:20 Text:@"    持仓总盈亏"];
        _chicang.backgroundColor = [UIColor whiteColor];
        
    }
    return _chicang;
}

- (UILabel *)yingkui{
    if (!_yingkui) {
        _yingkui = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/2., _chicang.y, MAINWIDTH /2. - 20., 40) Font:20 Text:@"0元"];
        _yingkui.textAlignment = NSTextAlignmentRight;
        _yingkui.textColor = UIColorFromRGB(0x666666);
    }
    return _yingkui;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0,  _chicang.y+_chicang.height, MAINWIDTH, MAINHEIGHT  - _chicang.y - _chicang.height) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:NO];
        //        _tableView.tableHeaderView = self.searchBar;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"暂无记录"];
        //        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
}

#pragma mark delegate of tableView

//段数

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 + 40 + 120 + 120 + 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 8;
    _noBuyLabel.hidden = _dataArray.count;
    return _dataArray.count;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    CHMyPlanTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHMyPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    [cell setCellWithDic:self.dataArray[indexPath.row] :[_priceArray[indexPath.row] floatValue]];
    
    WEAKSELF
    cell.addTocollect = ^(NSString * ID ,NSInteger x,CGFloat buyPrice ,CGFloat flowValue ,CGFloat zhiying , CGFloat zhisun ,CGFloat nowZy,CGFloat nowZs){
        //平仓 //修改策略
        self->zy = zhiying;
        self->zs = zhisun;
        self->nowzy = nowZy;
        self->nowzs = nowZs;
        self->mairu = buyPrice;
        weakself.nowId = ID;
        [weakself btnClick:x :flowValue];
    };
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"已买入";
    
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
//    CHMyPlanDetailViewController * vc = [[CHMyPlanDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}



- (void)loadData{
        
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"50" forKey:@"pageSize"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPage] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/getPositionList",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
        WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                 self -> sellFlag = nil;
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSArray *tmpArr= dic[@"list"];
                    if (tmpArr.count) {
                        if (self->nowPage == 1) {
                            weakself.dataArray = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.dataArray addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 50) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        [self getStocksPrice];
                    }else if (self->nowPage >1) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
//                    NSLog(@"%@",dic);
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                 self -> sellFlag = nil;
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
         self -> sellFlag = nil;
//        NSLog(@"error slider");
    }];
}

- (void)getStocksPrice{
    WEAKSELF
    self.flowNum = 0;
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < _dataArray.count ; i++) {
        [arr addObject:[NSString stringWithFormat:@"%@", _dataArray[i][@"request_code"]]];
    }
    [CHGetStockNum getStocks:arr Success:^(NSArray * _Nonnull array) {
        if (!array.count) {
            return ;
        }
        weakself.priceArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < array.count ; i++) {
            NSDictionary * stockdic = array[i];
            NSDictionary * dic = weakself.dataArray[i];
            //这个循环加上补亏金额
            [weakself.priceArray addObject:stockdic[@"price"]];
            weakself.flowNum = weakself.flowNum + [stockdic[@"price"] floatValue] * [dic[@"stock_count"]floatValue] - [dic[ @"market_value"]floatValue]
            + [dic[ @"fl_money"]floatValue];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%.0f元",self.flowNum]];
            if (self.flowNum<0) {
                [str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x247f00) range:NSMakeRange(0, str1.length - 1)];
            }else{
                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str1.length - 1)];
            }
            self.yingkui.attributedText = str1;
            [weakself.tableView reloadData];
        });
        
        self-> sellFlag = nil;
    }];
}

- (void)setzy:(NSString *)zyNum :(NSString *)zsNum{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    //修改用户策略，参数为stop_profit(止盈),stop_loss(止损), order_no(订单编号), uid(当前用户ID)
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:zyNum forKey:@"stop_profit"];
    [dataDict setObject:zsNum forKey:@"stop_loss"];
    [dataDict setObject:_nowId forKey:@"order_no"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/rules/updateRulesByUid",
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
                [CNManager showWindowAlert:@"设置成功"];
                [weakself loadData];
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

- (void)supplyPrice :(CGFloat) supplyNum{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    //    NSString * encryptStr = [en doEncryptStr: @"kyle_jukai"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:[NSString stringWithFormat:@"%.2f",supplyNum] forKey:@"fl_money"];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_nowId forKey:@"order_no"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString * str1 =   [en doDecEncryptStr:dataString withKey:gkey];
    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/fillLoss/submit",
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
                [CNManager showWindowAlert:[NSString stringWithFormat:@"成功补亏%.2f元",supplyNum]];
                [weakself loadData];
            }
        }else{
            [CNManager showWindowAlert:responseObject[@"msg"]];
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakself.newsWebView.scrollView.mj_header endRefreshing];
        NSLog(@"error code");
    }];
    
    
    
    //成功补亏后应刷新当前页面，并刷新账户余额
}

- (void)sellOut{
    if ([_nowId isEqualToString:sellFlag]) {
        return;
    }else{
        sellFlag = _nowId;
    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    ///Api/search/sellStock
    //卖出股票信息接口, 参数 【order_no(订单编号), uid(用户ID)】
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_nowId forKey:@"order_no"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/search/sellStock",//手动卖出
//    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/xtp/sellOrder",//自动卖出
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
                [CNManager showWindowAlert:responseObject[@"msg"]];
                [weakself refreshPage];
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                self -> sellFlag = nil;
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
         self -> sellFlag = nil;
        //        [weakself.tableView.header endRefreshing];
        //        NSLog(@"error slider");
    }];
}

- (void)btnClick:(NSInteger)x :(CGFloat)y{
    if (x==1) {
        //卖出
        [self sellOut];
    }else if (x == 0) {
        //修改策略
        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"设置止盈止损" message:[NSString stringWithFormat:@"止盈价格范围%.2f～%.2f元\n止损价格范围%.2f～%.2f元\n",mairu,zy,zs,mairu] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            al.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        al.tag = 300;
            [al show];
            tfName = [al textFieldAtIndex:0];
            tfName.placeholder = [NSString stringWithFormat: @"请输入止盈价格%.2f～%.2f元",mairu,zy];
        tfName.text = [NSString stringWithFormat: @"%.2f",nowzy];
            tfCode = [al textFieldAtIndex:1];
        tfCode.secureTextEntry = NO;
            tfName.keyboardType = UIKeyboardTypeDecimalPad;
            tfCode.keyboardType = UIKeyboardTypeDecimalPad;
            tfCode.placeholder =[NSString stringWithFormat: @"请输入止损价格%.2f～%.2f元",zs,mairu];
        tfCode.text = [NSString stringWithFormat: @"%.2f",nowzs];
    }else if(x == 2){
        if (y>=0) {
            [CNManager showWindowAlert:@"该股票不需要补亏"];
        }else{
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"补亏" message:[NSString stringWithFormat:@"账户余额：%.2f \n补亏范围：%.2f～%.2f元",[[CNManager loadByKey:MONEY] doubleValue],-y*.3,-y] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            al.alertViewStyle = UIAlertViewStyleSecureTextInput;
            al.tag = 301;
            [al show];
            bk = [[NSString stringWithFormat:@"%.2f", -y] floatValue];
            tfSupply = [al textFieldAtIndex:0];
            tfSupply.secureTextEntry = NO;
            tfSupply.placeholder = @"补亏金额";
            tfSupply.text = [NSString stringWithFormat: @"%.2f",-y*.3];
            tfSupply.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 300) {
        if (buttonIndex) {
            CGFloat zy1 = [tfName.text floatValue];
            CGFloat zs1 = [tfCode.text floatValue];
            if ([alertView textFieldAtIndex:0].text.length > 0 && [alertView textFieldAtIndex:1].text.length > 0 && zy1>=mairu && zs1 >= zs && zy1 <= zy && zs1<= mairu ) {
                [self setzy:[NSString stringWithFormat:@"%.2f",zy1] :[NSString stringWithFormat:@"%.2f",zs1] ];
            }else{
                [CNManager showWindowAlert:@"请填写范围内的数字"];
            }
            
        }
    }else if (alertView.tag == 301){
        if (buttonIndex) {
            CGFloat supplyP = [[alertView textFieldAtIndex:0].text floatValue];
            if ( supplyP >= bk*.3 -.01 && supplyP <= bk) {
                if (supplyP > [[CNManager loadByKey:MONEY]floatValue]){
                    //跳转充值页
                     [CNManager showWindowAlert:@"余额不足，请充值"];
                    CHPayPageViewController * vc = [[CHPayPageViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self supplyPrice: supplyP];
                }
            }else{
                [CNManager showWindowAlert:@"请填写范围内的数字"];
            }
            
        }
    }
        
}

- (void)refreshPage{
    [_dataArray removeAllObjects];
    nowPage = 1;
    [self loadData];
}

- (void)getNextPage{
    nowPage++;
    [self loadData];
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
