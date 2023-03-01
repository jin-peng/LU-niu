//
//  CHYaoQingListViewController.m
//  LU
//
//  Created by peng jin on 2019/7/22.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHYaoQingListViewController.h"
#import "CHFinishedTableViewCell.h"
#import <MJRefresh.h>

@interface CHYaoQingListViewController (){
    __block  NSInteger nowPage;
}
@property (nonatomic,strong) NSMutableArray * dataArray;
//@property (nonatomic,strong) NSMutableArray * priceArray;
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic ,strong)UILabel * noBuyLabel;

@end

@implementation CHYaoQingListViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    nowPage = 1;
    [self setupNav];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0,  StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT  - StatusBarAndNavigationBarHeight) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:NO];
        //        _tableView.tableHeaderView = self.searchBar;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, 0, MAINWIDTH, 40)];
        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(20, 0, MAINWIDTH/4., 40) Font:14 Text:@"邀请用户"];
        UILabel * lb2= [JPMyControl createLabelWithFrame:CGRectMake(20, 0, MAINWIDTH/4., 40) Font:14 Text:@"注册时间"];
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.center = CGPointMake(MAINWIDTH/2., _headerView.height/2.);
        UILabel * lb3 = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH - MAINWIDTH/4. - 20, 0, MAINWIDTH/4., 40) Font:14 Text:@"总佣金"];
        lb3.textAlignment = NSTextAlignmentRight;
        [_headerView addSubview:lb];
        [_headerView addSubview:lb2];
        [_headerView addSubview:lb3];
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _headerView.height- .5, MAINWIDTH, .5) bgColor:UIColorFromRGB(0xaaaaaa)];
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"暂无邀请记录"];
        //        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
}

#pragma mark delegate of tableView

//段数

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.;
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
    
    CHFinishedTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHFinishedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    return cell;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"邀请有礼";
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

- (void)loadData{
    
}

@end
