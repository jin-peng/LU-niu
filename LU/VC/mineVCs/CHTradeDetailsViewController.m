//
//  CHTradeDetailsViewController.m
//  LU
//
//  Created by peng jin on 2019/5/21.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHTradeDetailsViewController.h"
#import "CHDetailPageSZViewController.h"
#import "CHDetailPageCTViewController.h"
#import <MJRefresh.h>
#import "CHDetailPageSZViewController.h"
#import "CHDetailPageCTViewController.h"
#import "CHMingXiTableViewCell.h"

@interface CHTradeDetailsViewController ()
{
    UIView * redLine;
    NSInteger nowPageSR;
    NSInteger nowPageZC;
    NSInteger nowPageCZ;
    NSInteger nowPageTX;
    BOOL      showFlag;
//    NSInteger nowPage;
}
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * arrSR;
@property (nonatomic, strong)NSMutableArray * arrZC;
@property (nonatomic, strong)NSMutableArray * arrCZ;
@property (nonatomic, strong)NSMutableArray * arrTX;
@property (nonatomic, strong)UILabel *noBuyLabel;
@end

@implementation CHTradeDetailsViewController
@synthesize tableView = _tableView;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton * btn = [[UIButton alloc]init];
    btn.tag = 100 + _questNum;
    [self headerClick:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    nowPageSR = 1;
    nowPageZC = 1;
    nowPageCZ = 1;
    nowPageTX = 1;
    self.arrSR = [[NSMutableArray alloc]init];
    self.arrZC = [[NSMutableArray alloc]init];
    self.arrCZ = [[NSMutableArray alloc]init];
    self.arrTX = [[NSMutableArray alloc]init];
    [self.view addSubview:self.headerView];
//    [self.view addSubview:self.noBuyLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    [self loadData];
    // Do any additional setup after loading the view.
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0,  _headerView.y + _headerView.height , MAINWIDTH, MAINHEIGHT  - _headerView.y - _headerView.height) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:NO];
        //        _tableView.tableHeaderView = self.searchBar;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (void)refreshPage{
    switch (_questNum) {
        case 0:
            nowPageSR = 1;
            
            break;
        case 1:
            nowPageZC = 1;
            
            break;
        case 2:
            nowPageCZ = 1;
            
            break;
        case 3:
            nowPageTX = 1;
            
            break;
        default:
            break;
    }
    [self loadData];
}

- (void)getNextPage{
    switch (_questNum) {
        case 0:
            nowPageSR++;
            
            break;
        case 1:
            nowPageZC++;
            
            break;
        case 2:
            nowPageCZ++;
            
            break;
        case 3:
            nowPageTX++;
            
            break;
        default:
            break;
    }
    [self loadData];
}

- (void)loadData{
    switch (_questNum) {
        case 0:
            _dataArray = _arrSR;
            [self getSR];
            break;
        case 1:
            _dataArray = _arrZC;
            [self getZC];
            break;
        case 2:
            _dataArray = _arrCZ;
            [self getCZ];
            break;
        case 3:
            _dataArray = _arrTX;
            [self getTX];
            break;
        default:
            break;
    }
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+5, MAINWIDTH, 40) bgColor:[UIColor whiteColor]];
        NSArray * arr = @[@"收入",@"支出",@"充值",@"提现"];
        for (int i = 0 ; i<4; i++) {
            UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake( i * MAINWIDTH/4., 0, MAINWIDTH/4., _headerView.height - 8) Target:self SEL:@selector(headerClick:) Title:arr[i] ImageName:@"" bgImage:@"" Tag:100+i];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            if (i == 0) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [_headerView addSubview:btn];
        }
        redLine = [JPMyControl createViewWithFrame:CGRectMake(MAINWIDTH/16., _headerView.height - 3.-5., MAINWIDTH/8., 3.) bgColor:[UIColor redColor]];
        [_headerView addSubview:redLine];
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _headerView.height - 5., MAINWIDTH, 5) bgColor:UIColorFromRGB(0xdfdfdf)];
        [_headerView addSubview:line];
        
    }
    return _headerView;
}

- (void)reloadTableview{
    [self refreshPage];
//    switch (_questNum) {
//        case 0:
//            _dataArray = _arrSR;
//            if (!_dataArray.count) {
//                [self getSR];
//            }else{
//                [_tableView reloadData];
//            }
//
//            break;
//        case 1:
//            _dataArray = _arrZC;
//            if (!_dataArray.count) {
//                [self getZC];
//            }else{
//                [_tableView reloadData];
//            }
//
//            break;
//        case 2:
//            _dataArray = _arrCZ;
//            if (!_dataArray.count) {
//                [self getCZ];
//            }else{
//                [_tableView reloadData];
//            }
//
//            break;
//        case 3:
//            _dataArray = _arrTX;
//            if (!_dataArray.count) {
//                [self getTX];
//            }else{
//                [_tableView reloadData];
//            }
//
//            break;
//        default:
//            break;
//    }
}

- (void)headerClick:(UIButton *)btn{
    if (_questNum == btn.tag - 100 && showFlag) {
        return;
    }
    showFlag = YES;
    _questNum = btn.tag - 100;
    [self reloadTableview];
    for (int i = 0; i < 4; i++) {
        UIButton * newBtn = (UIButton *)[_headerView viewWithTag:100+i];
        if (i == btn.tag - 100) {
            [newBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:.3 animations:^{
                self->redLine.frame=CGRectMake(MAINWIDTH/16.+ MAINWIDTH/4.* i, self->redLine.y  ,self->redLine.width, self->redLine.height);
            }];
        }else{
            [newBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61.;
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
    
    CHMingXiTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHMingXiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    [cell setCellWithDic:self.dataArray[indexPath.row] showTag:_questNum];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转详情页
    switch (_questNum) {
        case 0:{
            CHDetailPageSZViewController * vc = [[CHDetailPageSZViewController alloc]init];
            vc.detailDic = _dataArray[indexPath.row];
            vc.isGet = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            CHDetailPageSZViewController * vc = [[CHDetailPageSZViewController alloc]init];
            vc.detailDic = _dataArray[indexPath.row];
            vc.isGet = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            CHDetailPageCTViewController * vc = [[CHDetailPageCTViewController alloc]init];
            vc.detailDic = _dataArray[indexPath.row];
            vc.isPay = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            CHDetailPageCTViewController * vc = [[CHDetailPageCTViewController alloc]init];
            vc.detailDic = _dataArray[indexPath.row];
            vc.isPay = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"交易明细";
    
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

- (void)getSR{
    //其中 必填项为：uid(用户ID)， state(1收入 2支出),pageNum，pageSize , 以上参数,都放入到 data 加密后传入后台。返回的数据列表里面的说明不是返回结果的说明【{ "total": "35 ",// 总条数 "list": "[{ "order_no ": "20190623183208510, //交易订单号 "note ": "浦发银行(sh600000)自动递延成功, //交易名称 "stock_name ": "浦发银行, //股票名称 "money ": "23.2, //金额 "time ": "2019-06-25 14:30:01, //时间 "id ": 97, "stock_code": "sh600000, //股票代码 "status": 11}] }】
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:@"1" forKey:@"state"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPageSR] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/selectUserBudgetList",
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
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSArray *tmpArr= dic[@"list"];
                    if (tmpArr.count) {
                        if (self->nowPageSR == 1) {
                            weakself.arrSR = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.arrSR addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 20) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        weakself.dataArray = weakself.arrSR;
                        [weakself.tableView reloadData];
                    }else{
                        if (self->nowPageSR >1) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else if (self->nowPageSR == 1) {
                            [weakself.tableView reloadData];
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
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
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        //        NSLog(@"error slider");
    }];
    
}
- (void)getZC{
    //其中 必填项为：uid(用户ID)， state(1收入 2支出),pageNum，pageSize , 以上参数,都放入到 data 加密后传入后台。返回的数据列表里面的说明不是返回结果的说明【{ "total": "35 ",// 总条数 "list": "[{ "order_no ": "20190623183208510, //交易订单号 "note ": "浦发银行(sh600000)自动递延成功, //交易名称 "stock_name ": "浦发银行, //股票名称 "money ": "23.2, //金额 "time ": "2019-06-25 14:30:01, //时间 "id ": 97, "stock_code": "sh600000, //股票代码 "status": 11}] }】
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:@"2" forKey:@"state"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPageZC] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/selectUserBudgetList",
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
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSArray *tmpArr= dic[@"list"];
                    if (tmpArr.count) {
                        if (self->nowPageZC == 1) {
                            weakself.arrZC = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.arrZC addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 20) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        weakself.dataArray = weakself.arrZC;
                        [weakself.tableView reloadData];
                    }else{
                        if (self->nowPageZC >1) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else if (self->nowPageZC == 1) {
                            [weakself.tableView reloadData];
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
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
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        //        NSLog(@"error slider");
    }];
}
- (void)getCZ{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:@"1" forKey:@"state"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPageCZ] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/selectPayList",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
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
                        if (self->nowPageCZ == 1) {
                            weakself.arrCZ = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.arrCZ addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 20) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        weakself.dataArray = weakself.arrCZ;
                        [weakself.tableView reloadData];
                    }else{
                        if (self->nowPageCZ >1) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else if (self->nowPageCZ == 1) {
                            [weakself.tableView reloadData];
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
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
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        //        NSLog(@"error slider");
    }];
}
- (void)getTX{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:@"1" forKey:@"state"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPageTX] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/withdraw/getWithdrawList",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
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
                        if (self->nowPageTX == 1) {
                            weakself.arrTX = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.arrTX addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 20) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        weakself.dataArray = weakself.arrTX;
                        [weakself.tableView reloadData];
                    }{
                        if (self->nowPageTX >1) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else if (self->nowPageTX == 1) {
                            [weakself.tableView reloadData];
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
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
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
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
