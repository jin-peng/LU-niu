//
//  CHInfoViewController.m
//  LU
//
//  Created by peng jin on 2019/5/21.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHInfoViewController.h"
#import "CHMsgTableViewCell.h"
#import <MJRefresh.h>

@interface CHInfoViewController (){
    NSInteger nowPage;
}
@property (nonatomic,strong) NSMutableArray * dataArray;
//@property (nonatomic,strong) NSMutableArray * priceArray;
@property (nonatomic ,strong)UILabel * noBuyLabel;
@end

@implementation CHInfoViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    nowPage =1 ;
//    [self.view addSubview:self.noBuyLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0,  StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT  - StatusBarAndNavigationBarHeight) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:YES];
        _tableView.backgroundColor = UIColorFromRGB(0xefefef);
        //        _tableView.tableHeaderView = self.searchBar;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"暂无消息记录"];
        //        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
}

#pragma mark delegate of tableView

//段数

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = [NSString stringWithFormat:@"%@", _dataArray[indexPath.row][@"reply_content"]];
    CGFloat h = [JPMyControl autoFitLabelByWidth:MAINWIDTH - 50 bystr:str font:[UIFont systemFontOfSize:14.]];
    return 15 + 10 + 15 + 10 + 12 + 10 + h;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary * dic = _dataArray[indexPath.row];
    if ([dic[@"state"] integerValue]== 1) {
        [self setHasRead:[NSString stringWithFormat:@"%@",dic[@"id"]]];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    CHMsgTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    return cell;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"消息";
    
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

- (void)setHasRead:(NSString *)infoID{
    
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:infoID forKey:@"id"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/feedback/setIsRead",
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
                ;
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

- (void)loadData{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPage] forKey:@"pageNum"];
    
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
                        if (self->nowPage == 1) {
                            weakself.dataArray = [[NSMutableArray alloc]initWithArray: tmpArr];
                        }else{
                            [weakself.dataArray addObjectsFromArray:tmpArr];
                        }
                        if (tmpArr.count < 20) {
                            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            weakself.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];;
                        }
                        [weakself.tableView reloadData];
                    }else if (self->nowPage >1) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
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

- (void)refreshPage{
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
