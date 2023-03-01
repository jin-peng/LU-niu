//
//  HomePageViewController.m
//  LU
//
//  Created by peng jin on 2019/4/16.
//  Copyright © 2019年 JinPeng. All rights reserved.
//

#import "HomePageViewController.h"
#import <MJRefresh.h>
#import "LSSlideView.h"
#import "MXAlbumsTableViewCell.h"
#import "marketView.h"
#import "YWAutoShowScroll.h"
#import "CHConfig.h"
#import "CHWebDetailViewController.h"
#import "CHLoginViewController.h"
#import "CHGetStockNum.h"
#import "CHStockDetailViewController.h"
#import "CHPlanViewController.h"
#import "CHFinshedPlanViewController.h"
#import "CH5KViewController.h"

#define JUMPURL @"https://emwap.eastmoney.com/Info/List/9/406"
#define JUMPJ   @"emwap.eastmoney.com"
@interface HomePageViewController () <UIScrollViewDelegate,UIWebViewDelegate>{
    CGFloat _hiFor169;
}
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)marketView * marketV;
@property (nonatomic, strong)LSSlideView *lss;
@property (nonatomic, strong)NSArray * imgArray;
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSArray * marketArray;
@property (nonatomic, strong)NSArray * newsArray;
@property (nonatomic, strong)NSArray * purchaseArray;
@property (nonatomic, strong)UIView  * classifyView;
@property (nonatomic, strong)UIView  * barView;
@property (nonatomic,strong)YWAutoShowScroll * autoScroll;
@property (nonatomic,strong) UIScrollView * homeSC;
@property (nonatomic , strong)UIWebView * newsWebView;
@property (nonatomic ,strong) NSArray * hotArray;
@property (nonatomic ,strong)UIButton * k5Btn;
@end

@implementation HomePageViewController
@synthesize tableView = _tableView;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshPage];
//    [self loadBuy];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[CNManager loadByKey:@"showLogin"] integerValue]&&![CNManager hasLogin]) {
         [CNManager saveObject:@"0" byKey:@"showLogin"];
        CHLoginViewController * vc = [[CHLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hiFor169=MAINWIDTH * 9. /16.;
    [SettingsManager getLocalIP];
    [self setupNav];
    [CNManager getConf];
//    [self.view addSubview:self.newsWebView];
    [self.view addSubview:self.homeSC];
//    [self.view addSubview:self.tableView];
//    self.title = @"首页";
    [self loadData];
//    [self loadPost];
    
//    [self loadBuy];
    // Do any additional setup after loading the view.
}

- (UIScrollView *)homeSC{
    if (!_homeSC) {
        _homeSC=[[UIScrollView alloc]initWithFrame:CGRectMake(0,  StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight - TabBarHeight)];
        _homeSC.backgroundColor = UIColorFromRGB(0x323234);
        
        _homeSC.delegate = self;
//        _homeSC.pagingEnabled = YES;
        _homeSC.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        [_homeSC addSubview:self.headerView ];
        UIView * vi = [JPMyControl createViewWithFrame:CGRectMake(0, _headerView.height , MAINWIDTH, 100) bgColor:[UIColor clearColor]];
        UILabel * lb =[JPMyControl createLabelWithFrame:CGRectMake(30, 10, MAINWIDTH, 15) Font:15 Text:@"热门股票"];
        lb.textColor = [UIColor whiteColor];
        [vi addSubview:lb];
        [_homeSC addSubview:vi];
        for (int i = 0 ; i < 3; i++) {
                    marketView * markV = [[marketView alloc]initWithFrame:CGRectMake(0, lb.y + lb.height + 10 + 90 * i , MAINWIDTH, 90)];
            [markV setLbbk];
                   markV.backgroundColor = UIColorFromRGB(0x323234);
            markV.tag = 400 + i;
            WEAKSELF
            markV.jumpStock = ^(NSDictionary * dic) {
                CHStockDetailViewController * vc=[[CHStockDetailViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.stockDic = dic;
                vc.stockID = dic[@"code"];
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            [vi addSubview:markV];
            if (i == 2) {
                vi.frame = CGRectMake(0, vi.y, MAINWIDTH, markV.y + markV.height);
                _homeSC.contentSize=CGSizeMake(0, vi.y + vi.height >= MAINHEIGHT ? vi.y+vi.height:MAINHEIGHT );
                
            }
            
               }
//        [_homeSC addSubview:self.newsWebView];
    }
    return _homeSC;
}
#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    [[request.URL absoluteString]componentsSeparatedByString:@"finance.sina.cn"].count>1
    if ([[request.URL absoluteString]isEqualToString:JUMPURL]) {
        return YES;
    }else if([[request.URL absoluteString]componentsSeparatedByString:JUMPJ].count>1){
        
        [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
//            NSLog(@"Open %@: %d",scheme,success);
        }];
        
    }
    return NO;
    
}
//- (UIWebView *)newsWebView{
//    if(!_newsWebView)
//    {
//        _newsWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight,MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight - TabBarHeight)];
//        _homeSC.contentSize=CGSizeMake(0, _newsWebView.height + _headerView.height);
//        _newsWebView.delegate=self;
//        //        [_newsWebView setUserInteractionEnabled:YES];
//        [_newsWebView setBackgroundColor:[UIColor whiteColor]];
//        [_newsWebView setOpaque:NO];
//        //        _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight, 0, 0, 0);
//        if (@available(iOS 11.0, *)) {
//            _newsWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//        }
//         _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(-265 * MULTIPLE + _hiFor169 + 90. + 100. + 15., 0, -265 * MULTIPLE + _hiFor169 + 90. + 100. + 15., 0);
//        [_newsWebView.scrollView addSubview:self.headerView];
//        _newsWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
//        [_newsWebView.scrollView.mj_header setIgnoredScrollViewContentInsetTop:-265 * MULTIPLE + _hiFor169 + 90. + 100. + 15.];
////        _newsWebView.scrollView.scrollEnabled = NO;
//        //        [_newsWebView.scrollView addSubview: self.backView];
//        //        WEAKSELF
//        //        [_newsWebView.scrollView addHeadersetHight:IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight WithCallback:^{
//        //            [weakself loadData];
//        //        }];
//        //        _newsWebView.scalesPageToFit = YES;
//        //        _newsWebView.hidden = YES;
////        UIView * view = [JPMyControl createViewWithFrame:CGRectMake(0, _newsWebView.height - 40, MAINWIDTH, 40) bgColor:[UIColor blackColor]];
////        view.userInteractionEnabled = YES;
////        [view addSubview:self.buyBtn];
////        [_newsWebView addSubview:view];
//    }
//    return _newsWebView;
//}

- (UIView *)headerView{
    if (!_headerView) {
//        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, 265 * MULTIPLE - (_hiFor169 + 90. + 100. + 15.), MAINWIDTH, _hiFor169 + 90. + 100. + 15.)];
        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, 0, MAINWIDTH, _hiFor169 + 90. + 100. + 15.)];
        [_headerView addSubview:self.lss];
        [_headerView addSubview:self.marketV];
        [_headerView addSubview:self.barView];
        [_headerView addSubview:self.k5Btn];
        _headerView.frame = CGRectMake(0, 0, MAINHEIGHT, _k5Btn.y+_k5Btn.height + 5.);
//        [_headerView addSubview:self.classifyView];
//        _headerView.backgroundColor = UIColorFromRGB(0x323234);
        _headerView.backgroundColor = UIColorFromRGB(0x000000);
//        _headerView addSubview:
    }
    return _headerView;
}

- (UIView*)classifyView{
    if (!_classifyView) {
        _classifyView=[JPMyControl createViewWithFrame:CGRectMake(10, _marketV.frame.origin.y + _marketV.frame.size.height + 15, MAINWIDTH - 20, 40)];
        _classifyView.backgroundColor=[UIColor whiteColor];
        _classifyView.layer.masksToBounds = YES;
        _classifyView.layer.cornerRadius = 6.;
        //        UILabel*label=[JPMyControl createLabelWithFrame:CGRectMake(10, 10, 200, 20) Font:15 Text:@"易物快报"];
        
        UIImageView*title=[JPMyControl createImageViewWithFrame:CGRectMake(0, 0, 90, 40) ImageName:@"平台公告"];
        [_classifyView addSubview:title];
        self.autoScroll=[[YWAutoShowScroll alloc]initWithFrame:CGRectMake(90, 5, MAINWIDTH - 90 - 60, 30)];
        //        scroll.delegate=self;
        [_classifyView addSubview:self.autoScroll];
        self.autoScroll.scrollEnabled=NO;
        //假数据请移动到请求后
//                NSArray* arr=@[@"王小明和王晓乐交换了:0",@"王小明和王晓乐交换了:1",@"王小明和王晓乐交换了:2",@"王小明和王晓乐交换了:3",@"王小明和王晓乐交换了:4",@"王小明和王晓乐交换了:5",@"王小明和王晓乐交换了:6",@"王小明和王晓乐交换了:7",@"王小明和王晓乐交换了:8",@"王小明和王晓乐交换了:9",@"王小明和王晓乐交换了:0",@"王小明和王晓乐交换了:1"];
//        NSArray* arr=@[@{@"qname":@"交易提示:（2019-4-17）",@"qgoods":@"1块金砖",@"qtime":@"1414218190"},@{@"qname":@"交易提示:（2019-4-18）",@"qgoods":@"2块金砖",@"qtime":@"1418218190"},@{@"qname":@"交易提示:（2019-4-19）",@"qgoods":@"3块金砖",@"qtime":@"1420118190"},@{@"qname":@"交易提示:（2019-4-27）",@"qgoods":@"4块金砖",@"qtime":@"1420018190"},@{@"qname":@"交易提示:（2019-5-17）",@"qgoods":@"5块金砖",@"qtime":@"1420108190"},@{@"qname":@"交易提示:（2019-6-17）",@"qgoods":@"6块金砖",@"qtime":@"1419218190"}];
//                [self.autoScroll createUI:arr];
        WEAKSELF
        _autoScroll.jumpBlock = ^(NSInteger i) {
            [weakself scrollClick:i];
        };
    }
    return _classifyView;
}

-(UIView *)barView{
    if (!_barView) {
        _barView = [JPMyControl createViewWithFrame:CGRectMake(0,_marketV.y + _marketV.height + 5 , MAINWIDTH , 80)];
        _barView.backgroundColor=UIColorFromRGB(0x323234);
        
        CGFloat x = (_barView.width - 40 - 180)/4.;
        NSArray * arr = @[@"创建策略",@"已买入",@"已卖出", @"新手指南"];
        NSArray * imageArr = @[@"股票", @"买入",@"卖出",@"说明"];
        for (int i = 0; i<4; i++) {
            UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(35. + i*(50.+x), 15, x, 50) Target:self SEL:@selector(buyClick:) Title:arr[i] ImageName:imageArr[i] bgImage:@"" Tag:200+i];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(+20, -x, -20, -10)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, +5, +10, -5)];
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.];
            [_barView addSubview:btn];
        }
//        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _barView.height - .5, MAINWIDTH, .5) bgColor:[UIColor whiteColor]];
//        [_barView addSubview:line];
    }
    return _barView;
}

- (UIButton *)k5Btn{
    if (!_k5Btn) {
        _k5Btn = [JPMyControl createButtonWithFrame:CGRectMake(0, _barView.y+_barView.height + 5, MAINWIDTH, 225./734. * MAINWIDTH) Target:self SEL:@selector(k5BtnClick) Title:@"" ImageName:@"" bgImage:@"5kBannar" Tag:500];
    }
    return _k5Btn;
}

- (marketView *)marketV{
    if (!_marketV) {
        _marketV = [[marketView alloc]initWithFrame:CGRectMake(0, _lss.height + 5 , MAINWIDTH, 90)];
        _marketV.backgroundColor = UIColorFromRGB(0x323234);
       
//        self.marketArray = @[@{@"rise":@"1",@"point":@"3253.6",@"change":@"+75.82",@"per":@"+2.39%"},@{@"rise":@"0",@"point":@"3103.6",@"change":@"-75.82",@"per":@"-2.39%"},@{@"rise":@"1",@"point":@"3253.6",@"change":@"+75.82",@"per":@"+2.39%"}];
        
    }
    return _marketV;
}

- (LSSlideView *)lss{
    if (!_lss) {
        _lss=[[LSSlideView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, _hiFor169)];
        _lss.backgroundColor = [UIColor blackColor];
        //是否是网络图片
        _lss.isNetworkImage = YES;
        //如果是网络图片-我们设置缺省页
        _lss.str_DefaultPageImageName = @"缺省页图片名";
        
        //轮播图的滚动时间(秒)
        _lss.shufflingTimer = 5.;
        //        [_lss startSlide];
        WEAKSELF
        _lss.clickedWithIndex = ^(int x) {
            NSDictionary * dic =  weakself.imgArray[x];
            if ([dic[@""] integerValue]) {   //判断跳转方式
                
            }
        };
        
        //底下view的颜色
//        _lss.backgroundColor=[UIColor clearColor];
    }
    return _lss;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(10, _headerView.height + _headerView.y + 10, MAINWIDTH- 20, MAINHEIGHT - _headerView.y - _headerView.height - TabBarHeight ) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:YES];
//        _tableView.tableHeaderView = self.headerView;
        _tableView.header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//        _tableView.backgroundColor = UIColorFromRGB(0xefefef);
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
    return _dataArray.count>8?8:_dataArray.count;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    MXAlbumsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[MXAlbumsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUI];
    }
    
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    
    WEAKSELF
    cell.pushToDetail = ^(NSString * ID ){
        NSDictionary * sdic = weakself.dataArray[indexPath.row];
        CHStockDetailViewController * vc=[[CHStockDetailViewController alloc]init];
        NSDictionary * dic = @{@"name":[NSString stringWithFormat:@"%@(%@)",sdic[@"stock_name"],sdic[@"code"]],@"code":sdic[@"code"],@"request_code":sdic[@"stock_code"]};
        vc.stockDic = dic;
        vc.stockID = dic[@"code"];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray * arr;
//    if (tableView==_tableView) {
//        arr=self.dataArray;
//    }else arr=self.dataArray0;
//    MXAlbumDetailViewController * vc=[[MXAlbumDetailViewController alloc]init];
//    vc.ID= arr [indexPath.row][@"albumid"];
//    vc.title= arr [indexPath.row][@"albumname"];
//    //    vc.address = [arr [indexPath.row][@"address"] integerValue];
//    vc.step=arr[indexPath.row][@"stepandpage"];
//    vc.isRight=YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  55.;
}



#pragma mark methods

- (void)k5BtnClick{
//    if (![CNManager hasLogin]) {
//        CHLoginViewController * vc = [[CHLoginViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    CH5KViewController * vc = [[CH5KViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshPage{
    [self loadData];
//    [self loadBuy];
    [self refreshMark];
    [self loadHot];
//    [self loadPost ];
    [_newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:JUMPURL]]];
}

- (void)loadPost{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    //    NSString * encryptStr = [en doEncryptStr: @"kyle_jukai"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString * str1 =   [en doDecEncryptStr:dataString withKey:gkey];
    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/notice/getNotice",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.homeSC.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    weakself.newsArray = dic[@"notice"];
                    [weakself.autoScroll createUI:weakself.newsArray];
                }
                
                
                
                
                [weakself.tableView reloadData];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.homeSC.mj_header endRefreshing];
        NSLog(@"error slider");
    }];
}

- (void)loadData{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
//    NSString * encryptStr = [en doEncryptStr: @"kyle_jukai"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString * str1 =   [en doDecEncryptStr:dataString withKey:gkey];
    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/slide/getSlide",
                           [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.homeSC.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    weakself.imgArray = dic[@"slide"];
                    
                }
                
                if (!weakself.imgArray.count) {
                    return;
                }
                NSMutableArray * tmp=[[NSMutableArray alloc]init];
                for (int i=0 ; i< weakself.imgArray.count ; i++) {
                    [tmp addObject:weakself.imgArray[i][@"pic"]];
                }
                if (weakself.lss) {
                    [weakself.lss removeFromSuperview];
                    weakself.lss = nil;
                }
                [weakself.headerView addSubview:weakself.lss];
                weakself.lss.scrollView.delegate = weakself;
                weakself.lss.slideImages=tmp;
                
                //放置图片的位置
                [weakself.lss initScrollViewAndPageController:weakself.lss.frame PageControllerFrame:CGRectMake(0, MAINWIDTH/16.*9.-30, MAINWIDTH, 30)];
                [weakself.lss startSlide];
                //点击图片的回调
                //    WEAKSELF
                weakself.lss.clickedWithIndex= ^(int index){//index第几张图
                    [weakself pushPage:0 page:index];
                };
                
                
                [weakself.tableView reloadData];
            }
        }
//        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.homeSC.mj_header endRefreshing];
        NSLog(@"error slider");
    }];
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0x323234);
    self.title=@"长牛财富";
    self.tabBarItem.title = @"首页";
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
//    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [backButton setImage:[UIImage imageNamed:@"photo_title_btn_back"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
//    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    moreItem.style = UIBarButtonItemStylePlain;
//    self.navigationItem.leftBarButtonItem = moreItem;
    
//    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick) Title:@"指南" ImageName:@"" bgImage:@"" Tag:0];
//        _editBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
////    _editBtn.hidden=YES;
//    right.style=UIBarButtonItemStylePlain;
    
    UIButton * _editBtn2=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 31, 30) Target:self SEL:@selector(setClick1) Title:@"" ImageName:@"help_img" bgImage:@"" Tag:0];
    _editBtn2.titleLabel.font=[UIFont systemFontOfSize:12];
    [_editBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*right2=[[UIBarButtonItem alloc]initWithCustomView:_editBtn2];
//    _editBtn2.hidden=YES;
    right2.style=UIBarButtonItemStylePlain;
//    _editBtn.alpha=.9;
    _editBtn2.alpha=.9;
    self.navigationItem.rightBarButtonItems=@[right2];
}

- (void)buyClick:(UIButton *)btn{
    NSInteger x = btn.tag - 200;
    switch (x) {
        case 0:
            {
                [self.navigationController.tabBarController setSelectedIndex:1];
            }
            break;
        case 1:
        {
            [self planBtnClick];
        }
            break;
        case 2:
            [self endBtnClick];
            
            break;
        case 3:
            [self setClick];
            break;
        default:
            break;
    }
}

- (void)planBtnClick{
    if (![CNManager hasLogin]) {
        CHLoginViewController * vc = [[CHLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    CHPlanViewController * vc = [[CHPlanViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endBtnClick{
    if (![CNManager hasLogin]) {
        CHLoginViewController * vc = [[CHLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    CHFinshedPlanViewController * vc = [[CHFinshedPlanViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loadBuy{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/toBuyList",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.homeSC.mj_header endRefreshing];
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
                        weakself.dataArray = [[NSMutableArray alloc]initWithArray: tmpArr];
                        [weakself.tableView reloadData];
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
        [weakself.homeSC.mj_header endRefreshing];
        //        NSLog(@"error slider");
    }];
}

- (void)loadHot{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/notice/getHotStock",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakself.homeSC.mj_header endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSArray *tmpArr= dic[@"data"];
                    if (tmpArr.count) {
                        weakself.hotArray = tmpArr;
                        [weakself refreshHot];
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
        [weakself.homeSC.mj_header endRefreshing];
        //        NSLog(@"error slider");
    }];
}


- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    
    return [NSString stringWithFormat:@"<img src=\"%@\"  style=\" width:%f; position: absolute; top: 0; left:0; right:0;\">", imageSource,MAINWIDTH];
}
- (void)setClick{
    //跳转文档页
    CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
    vc.chTitile = @"新手指南";
    UIImage *selectedImage = [UIImage imageNamed:@"help"];
    NSString *stringImage = [self htmlForJPGImage:selectedImage];
    NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
    NSString *content =[NSString stringWithFormat:
                        @"<html>"
                        "<style type=\"text/css\">"
                        "<!--"
                        "body{font-size:40pt;line-height:60pt;}"
                        "-->"
                        "</style>"
                        "<body>"
                        "%@"
                        "</body>"
                        "</html>"
                        , contentImg];
    [vc.newsWebView loadHTMLString:content baseURL:nil];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setClick1{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[CHConfig hotPhoneNumber]];
//     NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)pushPage:(BOOL)isPet page:(int)i{
    NSDictionary * dic =  _imgArray[i];
    switch ( [dic[@"action"] integerValue]) {
        case 1:
        {
            if (dic[@"url"]) {
                
                CHWebDetailViewController * vc = [[CHWebDetailViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.chTitile = dic[@"title"];
                vc.urlString = dic[@"url"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        case 2:
        {
            [self k5BtnClick];
            
        }
            break;
            
        default:
            break;
    }
    NSLog(@"%@",dic);
    
}

- (void)scrollClick:(NSInteger)i{
    NSMutableArray * arr=[NSMutableArray arrayWithArray:_newsArray];
    [arr addObject:_newsArray[0]];
    if (_newsArray.count > 1) {
        [arr addObject:_newsArray[1]];
    }else{
        [arr addObject:_newsArray[0]];
    }
    NSDictionary * dic = arr[i];
    CHWebDetailViewController * vc=[[CHWebDetailViewController alloc]init];
    vc.detailID = dic[@"article_id"];
    vc.chTitile= dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshMark{
    WEAKSELF;
    [CHGetStockNum getMarketIndexesSuccess:^(NSArray * _Nonnull array) {
        if (array.count) {
            [weakself.marketV refreshViewByArray:array jumpArr:@[@""]];
        }
    }];
}

- (void)refreshHot{
//    WEAKSELF
    [CHGetStockNum getDetailStocks:_hotArray Success:^(NSArray * _Nonnull array) {
        WEAKSELF
        if (array.count > 8) {
            for (int i = 0; i < 3; i++) {
                NSArray * arr = [array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(i * 3, 3)]];
                marketView * markV = (marketView *)[self.view viewWithTag:400+i];
                NSMutableArray * tmpArr = [[NSMutableArray alloc]initWithCapacity:3];
                for (int j= 0 ; j<3; j++) {
                    NSDictionary * dic = @{@"name":[NSString stringWithFormat:@"%@",arr[0][0]],@"code":[weakself.hotArray[i*3+j] substringFromIndex:2] ,@"request_code":weakself.hotArray[i*3+j]};
                    [tmpArr addObject:dic];
                }
                [markV refreshViewByArray:arr jumpArr:tmpArr];
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView !=_lss.scrollView) {
        return;
    }
    CGFloat x =  (scrollView.contentOffset.x + 1) / (MAINWIDTH - 30.);
    NSInteger y = (NSInteger )x ;
    y++;
    
    for (int i = 0; _lss.imgArr.count; i++) {
        UIImageView * vi = (UIImageView *) _lss.imgArr[i];
        vi.transform = CGAffineTransformMakeScale(1.0 - 0.1 * ((CGFloat)y- x), 1.0- 0.1 * ((CGFloat)y)- x);
    }
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
