//
//  CHSearchViewController.m
//  LU
//
//  Created by peng jin on 2019/4/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHSearchViewController.h"
#import "stockTableViewCell.h"
#import <MJRefresh.h>
#import "CHSearchTableViewCell.h"
#import "CHStockDetailViewController.h"
@interface CHSearchViewController ()<UISearchBarDelegate>
{
    NSInteger nowPage;
    BOOL y[1000];
}
@property (nonatomic,strong) UISearchBar* searchBar;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic ,strong)UILabel * noBuyLabel;
@property (nonatomic ,strong)NSMutableArray * collectArray;
@property (nonatomic ,strong)NSMutableArray * historyArray;
//@property (nonatomic) BOOL y[1000];
@end

@implementation CHSearchViewController
@synthesize tableView = _tableView;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length) {
        if ([searchBar isFirstResponder]) {
            [searchBar resignFirstResponder];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    nowPage = 1;
    self.collectArray = [[NSMutableArray alloc]initWithArray: [CNManager loadByKey:HASBUYSTOCK]];
    self.historyArray = [[NSMutableArray alloc]initWithArray: [CNManager loadByKey:STOCKHISTORY]];
    [self setupNav];
    [self.view addSubview:self.searchBar];
//    [self.view addSubview:self.noBuyLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    
    
    // Do any additional setup after loading the view.
}

- (UISearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,  StatusBarAndNavigationBarHeight, MAINWIDTH, 40)];
        _searchBar.placeholder = @"请输入股票名称/代码";
        _searchBar.delegate = self;
//        _searchBar.layer.borderColor = [[UIColor redColor] CGColor];
//        _searchBar.layer.borderWidth = 1;
    }
    return _searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0,  _searchBar.y+_searchBar.height, MAINWIDTH, MAINHEIGHT  - _searchBar.y - _searchBar.height) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:NO];
//        _tableView.tableHeaderView = self.searchBar;
        _tableView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"未搜索到任何股票"];
        //        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
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
    _noBuyLabel.hidden = _dataArray.count;
    return _dataArray.count;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    CHSearchTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    cell.x = y[indexPath.row];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    
    WEAKSELF
    cell.addTocollect = ^(NSString * ID ,NSDictionary * dic ,BOOL x){
        [weakself changeCollect:x withDic:dic withID:ID];
        self->y[indexPath.row]=x;
    };
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _dataArray[indexPath.row];
    NSString * selectID = dic[@"code"];
    
    if (!_historyArray.count) {
        [_historyArray addObject:dic];
    }else{
        for (int i = 0 ; i<_historyArray.count; i++) {
            if ([selectID isEqualToString:_historyArray[i][@"code"]]) {
                [_historyArray removeObjectAtIndex:i];
                [_historyArray insertObject:dic atIndex:0];
                break;
            }else if(i == _historyArray.count-1){
                [_historyArray insertObject:dic atIndex:0];
                break;
            }
        }
    }
    while (_historyArray.count>10) {
        [_historyArray removeLastObject];
    }
    
    [CNManager saveObject:_historyArray byKey:STOCKHISTORY];
            CHStockDetailViewController * vc=[[CHStockDetailViewController alloc]init];
    vc.stockID= _dataArray [indexPath.row][@"code"];
    vc.stockDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self loadData];
}

#pragma mark methods

- (void)changeCollect:(BOOL)x withDic:(NSDictionary *)dic withID:(NSString *)num{
    if (x) { //添加
        [_collectArray insertObject:dic atIndex:0];
    }else{ //删除
        for (int i = 0; i<_collectArray.count; i++) {
            if ([num isEqualToString:_collectArray[i][@"code"] ]) {
                [_collectArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    [CNManager saveObject:_collectArray byKey:HASBUYSTOCK];
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"搜索股票";
    
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
    
    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick) Title:@"关闭" ImageName:@"" bgImage:@"" Tag:0];
    _editBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    //    _editBtn.hidden=YES;
    right.style=UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItems=@[right];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData{
    nowPage = 1;
    [self loadData];
}

- (void)loadData{
    if (!_searchBar.text.length) {
        return;
    }
    WEAKSELF;
    JKEncrypt * en = [[JKEncrypt alloc]init];
    //    NSString * encryptStr = [en doEncryptStr: @"kyle_jukai"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:_searchBar.text forKey:@"code"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
//    NSString * str1 =   [en doDecEncryptStr:dataString withKey:gkey];
//    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/search/searchStock",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.tableView.header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    weakself.dataArray = dic[@"list"];
                }
                
                [weakself.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.tableView.header endRefreshing];
        NSLog(@"error");
    }];
//    [weakself.tableView.header endRefreshing];
//    NSArray * has = @[@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600142",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600143",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600144",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600145",@"price":@"13.77",@"per":@"-3.07%"}];
//    self.dataArray = [[NSMutableArray alloc]initWithArray:has];
//    for (int i = 0; i<_dataArray.count; i++) {
//        for (int j = 0; j< _collectArray.count; j++) {
//            if ([_dataArray[i][@"code"] isEqualToString:_collectArray[j][@"code"]]) {
//                y[i]=true;
//                break;
//            }
//        }
//    }
//    [_tableView reloadData];
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
