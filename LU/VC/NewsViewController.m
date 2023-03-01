//
//  NewsViewController.m
//  LU
//
//  Created by peng jin on 2019/4/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "NewsViewController.h"
#import <MJRefresh.h>
#import "NewsTableViewCell.h"
#import "CHWebDetailViewController.h"

@interface NewsViewController (){
    NSInteger nowPage;
}
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation NewsViewController
@synthesize tableView = _tableView;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [CNManager saveObject:@"0" byKey:@"AppLoginOK"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nowPage = 1;
    self.title=@"股市信息";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.tableView];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight ) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:YES];
        _tableView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

#pragma mark delegate of tableView

//段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 8;
    return _dataArray.count;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    NewsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _dataArray[indexPath.row];
    
    CHWebDetailViewController * vc=[[CHWebDetailViewController alloc]init];
    vc.detailID = [NSString stringWithFormat:@"%@", dic[@"id"]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.chTitile= dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100.;
}

- (void)loadData{
//    WEAKSELF;
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
//    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:@"20" forKey:@"pageSize"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",nowPage] forKey:@"pageNum"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/article/getArticleList",
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
