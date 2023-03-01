//
//  BuyViewController.m
//  LU
//
//  Created by peng jin on 2019/4/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "BuyViewController.h"
#import <MJRefresh.h>
//#import "MXAlbumsTableViewCell.h"
#import "marketView.h"
#import "stockTableViewCell.h"
#import "CHSearchViewController.h"
#import "CHStockEditViewController.h"
#import "CHStockDetailViewController.h"
#import "CHPlanViewController.h"
#import "CHFinshedPlanViewController.h"
#import "CHGetStockNum.h"

@interface BuyViewController () <UIScrollViewDelegate>
@property (nonatomic , strong)UIScrollView * homeSC;
@property (nonatomic , strong)UIView * headerView;
@property (nonatomic , strong)UIButton * hasBuyBtn;
@property (nonatomic , strong)UIButton * historyBtn;
@property (nonatomic , strong)UIView * historyHeader;
@property (nonatomic , strong)UIView * hasBuyHeader;
@property (nonatomic , strong)UITableView * hasBuyTableView;
@property (nonatomic , strong)UITableView * historyTableView;
@property (nonatomic , strong)UIView * bottomView;
@property (nonatomic , strong)UIButton * planBtn;
@property (nonatomic , strong)UIButton * endBtn;
@property (nonatomic , strong)UILabel * noBuyLabel;
@property (nonatomic , strong)UILabel * noHistoryLabel;
@property (nonatomic , strong)UIView  * redLine;
@property (nonatomic , strong)NSMutableArray * hasBuyDataArray;
@property (nonatomic , strong)NSArray * hasBuyPriceArray;
@property (nonatomic , strong)NSMutableArray * historyDataArray;
@property (nonatomic , strong)NSArray * historyPriceArray;
@property (nonatomic, strong)marketView * marketV;
//@property (nonatomic ,strong)NSMutableArray * historyDataArray;
@end

@implementation BuyViewController

- (void)viewWillAppear:(BOOL)animated{
    [self loadHasBuyData];
    [self loadHistoryData];
    [self refreshMark];
}

- (void)refreshMark{
    WEAKSELF;
    [CHGetStockNum getMarketIndexesSuccess:^(NSArray * _Nonnull array) {
        if (array.count) {
            [weakself.marketV refreshViewByArray:array jumpArr:nil];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
//    [CNManager saveObject:nil byKey:STOCKHISTORY];
//    [CNManager saveObject:nil byKey:HASBUYSTOCK];
//    self.historyDataArray = [[NSMutableArray alloc]initWithArray: [CNManager loadByKey:STOCKHISTORY]];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.homeSC];
//    [self.view addSubview:self.bottomView];
//    NSArray * has = @[@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"-3.07%"}];
//    NSArray * his = @[@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"-3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"+3.07%"},@{@"name":@"兴发集团",@"code":@"600141",@"price":@"13.77",@"per":@"-3.07%"}];
//    [CNManager saveObject:has byKey:HASBUYSTOCK];
//    [CNManager saveObject:his byKey:STOCKHISTORY];
    // Do any additional setup after loading the view.
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [JPMyControl createViewWithFrame:CGRectMake(MAINWIDTH/6., MAINHEIGHT - TabBarHeight - 45, MAINWIDTH/3.*2., 36) bgColor:[UIColor whiteColor]];
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.borderColor = [UIColor grayColor].CGColor;
        _bottomView.layer.borderWidth = .5;
        [_bottomView addSubview:self.planBtn];
        [_bottomView addSubview:self.endBtn];
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(_bottomView.width/2., 5, .5, _bottomView.height - 10.) bgColor:[UIColor grayColor]];
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (UIButton *)planBtn{
    if (!_planBtn) {
        _planBtn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, _bottomView.width/2., _bottomView.height) Target:self SEL:@selector(planBtnClick) Title:@"持仓中" ImageName:@"" bgImage:@"" Tag:0];
        [_planBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _planBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _planBtn;
}

- (UIButton *)endBtn{
    if (!_endBtn) {
        _endBtn = [ JPMyControl createButtonWithFrame:CGRectMake(_bottomView.width/2., 0, _bottomView.width/2., _bottomView.height) Target:self SEL:@selector(endBtnClick) Title:@"已结算" ImageName:@"" bgImage:@"" Tag:0];
        [_endBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _endBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _endBtn;
}

- (UIScrollView *)homeSC{
    if (!_homeSC) {
        _homeSC=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 90+40 + 10 + StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT -40 -90 - StatusBarAndNavigationBarHeight - 10 - TabBarHeight)];
        _homeSC.backgroundColor = UIColorFromRGB(0xefefef);
        _homeSC.contentSize=CGSizeMake(MAINWIDTH*2, 0);
        _homeSC.delegate = self;
        [_homeSC addSubview:self.noBuyLabel];
        [_homeSC addSubview:self.noHistoryLabel];
        [_homeSC addSubview:self.hasBuyTableView];
        [_homeSC addSubview:self.historyTableView];
        _homeSC.pagingEnabled = YES;
    }
    return _homeSC;
}

-(UITableView *)hasBuyTableView{
    if (!_hasBuyTableView) {
        _hasBuyTableView = [JPMyControl createTableViewWithFrame:CGRectMake(0, 2, MAINWIDTH, _homeSC.height ) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:YES];
        _hasBuyTableView.tableHeaderView = self.hasBuyHeader;
        _hasBuyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _hasBuyTableView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHasBuyData)];
        _hasBuyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _hasBuyTableView;
}

-(UITableView *)historyTableView{
    if (!_historyTableView) {
        _historyTableView = [JPMyControl createTableViewWithFrame:CGRectMake(MAINWIDTH, 3, MAINWIDTH, _homeSC.height ) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:YES];
        _historyTableView.tableHeaderView = self.historyHeader;
        _historyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _historyTableView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHistoryData)];
        _historyTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _historyTableView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"你尚未收藏任何股票"];
//        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
}

- (UILabel *)noHistoryLabel{
    if (!_noHistoryLabel) {
        _noHistoryLabel = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"你尚未浏览任何股票"];
//        _noHistoryLabel.center = _homeSC.center;
        _noHistoryLabel.textColor = UIColorFromRGB(0x666666);
        _noHistoryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noHistoryLabel;
}

- (UIView *)redLine{
    if (!_redLine) {
        _redLine = [JPMyControl createViewWithFrame:CGRectMake(_headerView.width/8., _headerView.height - 2., _headerView.width/4., 2) bgColor:[UIColor redColor]];
    }
    return _redLine;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView= [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, 40 + 90) bgColor:[UIColor whiteColor]];
        [_headerView addSubview:self.marketV];
        [_headerView addSubview:self.hasBuyBtn];
        [_headerView addSubview:self.historyBtn];
        [_headerView addSubview:self.redLine];
    }
    return _headerView;
}

- (marketView *)marketV{
    if (!_marketV) {
        _marketV = [[marketView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 90)];
        _marketV .backgroundColor = UIColorFromRGB(0x323234);
//        _marketV.backgroundColor = [UIColor blackColor];
        
    }
    return _marketV;
}

- (UIButton *)hasBuyBtn{
    if (!_hasBuyBtn) {
        _hasBuyBtn = [JPMyControl createButtonWithFrame:CGRectMake(0, 90, _headerView.width/2., 40) Target:self SEL:@selector(hasBuyBtnClick) Title:@"我的自选" ImageName:@"" bgImage:@"" Tag:0];
        [_hasBuyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _hasBuyBtn;
}

- (UIButton *)historyBtn{
    if (!_historyBtn) {
        _historyBtn = [JPMyControl createButtonWithFrame:CGRectMake(_headerView.width/2., 90, _headerView.width/2., 40) Target:self SEL:@selector(historyBtnClick) Title:@"浏览记录" ImageName:@"" bgImage:@"" Tag:0];
        [_historyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _historyBtn;
}

#pragma mark delegate of tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [JPMyControl createViewWithFrame:CGRectMake(0, 0, MAINWIDTH, 40) bgColor:UIColorFromRGB(0xffffff)];
    UILabel * nameLb = [JPMyControl createLabelWithFrame:CGRectMake(0, 0, MAINWIDTH/3., 40) Font:12 Text:@"股票名称"];
    nameLb.textAlignment = NSTextAlignmentCenter;
    UILabel * _priceLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/3., 0, MAINWIDTH/3., 40) Font:12 Text:@"当前价"];
    _priceLb.textAlignment = NSTextAlignmentCenter;
    UILabel * _perLb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH/3.*2., 0, MAINWIDTH/3., _priceLb.height) Font:12 Text:@"跌涨幅"];
    _perLb.textAlignment = NSTextAlignmentCenter;
    [view addSubview:nameLb];
    [view addSubview:_priceLb];
    [view addSubview:_perLb];
    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, view.height- 2, MAINWIDTH, 2) bgColor:UIColorFromRGB(0xefefef)];
    [view addSubview:line];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.;
}

//段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _historyTableView) {
        _historyTableView.hidden = !_historyDataArray.count;
        _noHistoryLabel.hidden = _historyDataArray.count;
        
        return _historyDataArray.count;
    }else{
        _hasBuyTableView.hidden = !_hasBuyDataArray.count;
        _noBuyLabel.hidden = _hasBuyDataArray.count;
        
        return _hasBuyDataArray.count;
    }
    
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    if (tableView == _hasBuyTableView) {
        stockTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (cell==nil) {
            cell=[[stockTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
            cell.selectionStyle=NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell makeCellUI];
        }
        
        [cell setCellWithDic:self.hasBuyDataArray[indexPath.row] price:self.hasBuyPriceArray[indexPath.row]];
        return cell;
    }else{
        stockTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID1"];
        if (cell==nil) {
            cell=[[stockTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID1"];
            cell.selectionStyle=NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell makeCellUI];
        }
        
        [cell setCellWithDic:self.historyDataArray[indexPath.row] price:self.historyPriceArray[indexPath.row]];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr;
    if (tableView==_hasBuyTableView) {
        arr=self.hasBuyDataArray;
    }else arr=[self.historyDataArray copy];
    
    
    
    NSDictionary * dic = arr[indexPath.row];
    NSString * selectID = dic[@"code"];
    if (!_historyDataArray.count) {
        [_historyDataArray addObject:dic];
    }else{
        for (int i = 0 ; i<_historyDataArray.count; i++) {
            if ([selectID isEqualToString:_historyDataArray[i][@"code"]]) {
                [_historyDataArray removeObjectAtIndex:i];
                [_historyDataArray insertObject:dic atIndex:0];
                break;
            }else if(i == _historyDataArray.count-1){
                [_historyDataArray insertObject:dic atIndex:0];
                break;
            }
        }
    }
    
    while (_historyDataArray.count>10) {
        [_historyDataArray removeLastObject];
    }
    
    [CNManager saveObject:_historyDataArray byKey:STOCKHISTORY];
    CHStockDetailViewController * vc=[[CHStockDetailViewController alloc]init];
    vc.stockID= arr [indexPath.row][@"code"];
    vc.stockDic = arr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70.;
}

#pragma mark methods
- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"选择股票";
    self.tabBarItem.title = @"交易";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 50, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [backButton setImage:[UIImage imageNamed:@"photo_title_btn_back"] forState:UIControlStateNormal];
    [backButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:16];
//    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = moreItem;
    
    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 50, 40) Target:self SEL:@selector(setClick) Title:@"搜索" ImageName:@"" bgImage:@"" Tag:0];
    _editBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_editBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    //    _editBtn.hidden=YES;
    right.style=UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItems=@[right];
}

- (void)backClick{
    CHStockEditViewController * vc = [[CHStockEditViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setClick{
    CHSearchViewController * vc = [[CHSearchViewController alloc]init];
    vc.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)historyBtnClick{
    [_homeSC setContentOffset:CGPointMake(MAINWIDTH, 0) animated:YES];
    [self loadHistoryData];
    [self refreshHeader:1];
}

- (void)hasBuyBtnClick{
    [_homeSC setContentOffset:CGPointMake(0, 0) animated:YES];
    [self loadHasBuyData];
    [self refreshHeader:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = _homeSC.contentOffset.x / scrollView.width;
    [self refreshHeader:index];
    
}

- (void)refreshHeader:(NSInteger)x{
    [_hasBuyBtn setTitleColor:x?[UIColor grayColor]:[UIColor redColor] forState:UIControlStateNormal];
    [_historyBtn setTitleColor:!x?[UIColor grayColor]:[UIColor redColor] forState:UIControlStateNormal];
    CGFloat w = _headerView.width/4.;
    WEAKSELF
    [UIView animateWithDuration:.5 animations:^{
        weakself.redLine.center= CGPointMake(x? w * 3 : w, weakself.redLine.centerY);
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

#pragma mark netWorking

- (void)planBtnClick{
    if (![CNManager hasLogin]) {
        
        return;
    }
    CHPlanViewController * vc = [[CHPlanViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endBtnClick{
    CHFinshedPlanViewController * vc = [[CHFinshedPlanViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadHasBuyData{
    WEAKSELF;
    self.hasBuyDataArray = [[NSMutableArray alloc]initWithArray:[CNManager loadByKey:HASBUYSTOCK]];
    [weakself.hasBuyTableView.header endRefreshing];
//    NSArray * tmpArr = ;
    NSMutableArray * codeArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _hasBuyDataArray.count; i++) {
        [codeArray addObject:_hasBuyDataArray[i][@"request_code"]];
    }
    [CHGetStockNum getStocks:codeArray Success:^(NSArray * _Nonnull array) {
        weakself.hasBuyPriceArray = array;
        [weakself.hasBuyTableView reloadData];
    }];
//    [_hasBuyTableView reloadData];
    
}
- (void)loadHistoryData{
    WEAKSELF;
    [self.historyTableView.header endRefreshing];
    
    self.historyDataArray = [[NSMutableArray alloc]initWithArray:[CNManager loadByKey:STOCKHISTORY]];
    NSMutableArray * codeArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _historyDataArray.count; i++) {
        [codeArray addObject:_historyDataArray[i][@"request_code"]];
    }
    [CHGetStockNum getStocks:codeArray Success:^(NSArray * _Nonnull array) {
        weakself.historyPriceArray = array;
        [weakself.historyTableView reloadData];
    }];
//    [_historyTableView reloadData];
}
@end
