//
//  CHWebDetailViewController.m
//  LU
//
//  Created by peng jin on 2019/4/23.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHWebDetailViewController.h"

@interface CHWebDetailViewController () <UIWebViewDelegate> {
    BOOL didLoad;
}

@end

@implementation CHWebDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.newsWebView];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (UIWebView *)newsWebView{
    if(!_newsWebView)
    {
        _newsWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight,MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        _newsWebView.delegate=self;
        //        [_newsWebView setUserInteractionEnabled:YES];
        [_newsWebView setBackgroundColor:[UIColor whiteColor]];
        [_newsWebView setOpaque:NO];
        //        _newsWebView.scrollView.contentInset = UIEdgeInsetsMake(IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _newsWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        //        [_newsWebView.scrollView addSubview: self.backView];
//        WEAKSELF
        //        [_newsWebView.scrollView addHeadersetHight:IMGHIGH * MULTIPLE + 70 - StatusBarAndNavigationBarHeight WithCallback:^{
        //            [weakself loadData];
        //        }];
        //        _newsWebView.scalesPageToFit = YES;
        //        _newsWebView.hidden = YES;
        
    }
    return _newsWebView;
}

#pragma mark webViewDelegate

- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
    if (!didLoad) { //Do not jump to URL when view first loads
        didLoad = YES;
        return YES;
    }
    return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    //    [[HudManager sharedHudManager] hideProgressHUD:self.view];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= _chTitile?:@"";
    
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
    
//    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick) Title:@"搜索" ImageName:@"" bgImage:@"" Tag:0];
//    _editBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
//    //    _editBtn.hidden=YES;
//    right.style=UIBarButtonItemStylePlain;
//    self.navigationItem.rightBarButtonItems=@[right];
}

#pragma mark netWorking

- (void)loadData{
    if (_contentString) {
        [self.newsWebView loadHTMLString:_contentString baseURL:nil];
    }else if (_urlString) {
        [_newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }else if(_detailID){
        JKEncrypt * en = [[JKEncrypt alloc]init];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
        
        //    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
        [dataDict setObject:_detailID forKey:@"id"];
        
        NSString *dataString = [CNManager convertToJsonData:dataDict];
        [dataString URLEncodedString];
        NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
        NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/article/getArticleInfo",
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
                    NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                    NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                    if ([data length]&&[ref length]&&(data)&&(ref)) {
                        JKEncrypt * en1 = [[JKEncrypt alloc]init];
                        NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                        
                        NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                        [self.newsWebView loadHTMLString:dic[@"content"] baseURL:nil];
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
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
