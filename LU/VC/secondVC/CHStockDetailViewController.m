//
//  CHStockDetailViewController.m
//  LU
//
//  Created by peng jin on 2019/4/26.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHStockDetailViewController.h"
#import "CHBuyStockViewController.h"
#import "CHLoginViewController.h"
#import "CHTureNameViewController.h"
#import "CHBuy5kViewController.h"

@interface CHStockDetailViewController () <UIWebViewDelegate> {
    BOOL hasCollected;
    BOOL loadOFF;
    UIButton * _editBtn;
    NSInteger ss;
}
@property (nonatomic ,strong)UIButton * buyBtn;
@property (nonatomic ,strong)NSMutableArray * collectArray;

@end

@implementation CHStockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ss = 0;
    self.collectArray = [[NSMutableArray alloc]initWithArray: [CNManager loadByKey:HASBUYSTOCK]];
    for (int i = 0; i<_collectArray.count; i++) {
        if ([_stockID isEqualToString:_collectArray[i][@"code"]]) {
            hasCollected = YES;
            break;
        }
    }
    [self setupNav];
    [self.view addSubview:self.newsWebView];
//    [self.view addSubview:self.buyBtn];
    [self loadData];
    [[HudManager sharedHudManager] progressHUD:[CNManager loadLanguage:@"加载中…"] activity:YES superView:self.view];
    // Do any additional setup after loading the view.
}

- (UIWebView *)newsWebView{
    if(!_newsWebView)
    {
        _newsWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight,MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight- TabBarHeight)];
        _newsWebView.delegate=self;
        //        [_newsWebView setUserInteractionEnabled:YES];
        [_newsWebView setBackgroundColor:[UIColor whiteColor]];
        [_newsWebView setOpaque:NO];
        //        _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _newsWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
        _newsWebView.scrollView.scrollEnabled = NO;
        //        [_newsWebView.scrollView addSubview: self.backView];
        //        WEAKSELF
        //        [_newsWebView.scrollView addHeadersetHight:IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight WithCallback:^{
        //            [weakself loadData];
        //        }];
        //        _newsWebView.scalesPageToFit = YES;
        //        _newsWebView.hidden = YES;
        UIView * view = [JPMyControl createViewWithFrame:CGRectMake(0, MAINWIDTH - 2, MAINWIDTH, MAINHEIGHT - MAINWIDTH) bgColor:[UIColor whiteColor]];
        view.userInteractionEnabled = YES;
        [view addSubview:self.buyBtn];
        [_newsWebView addSubview:view];
    }
    return _newsWebView;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [JPMyControl createButtonWithFrame:CGRectMake(20, (MAINHEIGHT - MAINWIDTH - StatusBarAndNavigationBarHeight - 60)/2., MAINWIDTH- 40, 40) Target:self SEL:@selector(gotoBuy) Title:@"确  定" ImageName:@"" bgImage:@"" Tag:0];
        _buyBtn.backgroundColor = [UIColor redColor];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 5;
    }
    return _buyBtn;
}

#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (ss>1) {
        return NO;
    }
    ss++;
    return YES;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"%@",error);
    //    [[HudManager sharedHudManager] hideProgressHUD:self.view];
    [[HudManager sharedHudManager] hideProgressHUD:self.view];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[HudManager sharedHudManager] hideProgressHUD:self.view];
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"T+1交易";
    
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
    
    _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 40, 30) Target:self SEL:@selector(setClick) Title:hasCollected?@"删自选":@"加自选" ImageName:@"" bgImage:@"" Tag:100];
        _editBtn.titleLabel.font=[UIFont systemFontOfSize:10];
        [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
        //    _editBtn.hidden=YES;
        right.style=UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItems=@[right];
}

- (void)setClick{
    [self changeCollect:!hasCollected withDic:_stockDic withID:_stockDic[@"code"]];
}

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
    hasCollected = !hasCollected;
    [_editBtn setTitle:hasCollected?@"删自选":@"加自选" forState:UIControlStateNormal];
}

#pragma mark netWorking

- (void)loadData{
    if (_urlString) {
        [_newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }else if(_stockID){
        [_newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.10jqka.com.cn/stockpage/hs_%@/",_stockID]]]];
    }
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoBuy{
    if (![CNManager hasLogin]) {
        CHLoginViewController *vc = [[CHLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [CNManager showWindowAlert:@"请先登录"];
        return;
    }
    if (![CNManager hasRealName]) {
        CHTureNameViewController *vc = [[CHTureNameViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [CNManager showWindowAlert:@"请先进行实名认证"];
        return;
    }
    
    if ([CNManager loadByKey:JOIN5K]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的买入方式"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *go5k = [UIAlertAction actionWithTitle:@"活动买入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CHBuy5kViewController * vc = [[CHBuy5kViewController alloc]init];
            vc.stockDic = self.stockDic;
            [self.navigationController pushViewController:vc animated:YES];
       
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"正常买入" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
            CHBuyStockViewController * vc = [[CHBuyStockViewController alloc]init];
            vc.stockDic = self.stockDic;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:go5k];
        [self presentViewController:alertController animated:YES completion:nil];
                return;
    }
    
    CHBuyStockViewController * vc = [[CHBuyStockViewController alloc]init];
    vc.stockDic = self.stockDic;
    [self.navigationController pushViewController:vc animated:YES];
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
