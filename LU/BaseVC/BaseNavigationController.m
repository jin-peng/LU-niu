//
//  BaseNavigationController.m
//  ChinaNews
//
//  Created by siyuzhe on 16/11/3.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "BaseNavigationController.h"
//#import "CNMainViewController.h"
#import "AppDelegate.h"
//#import "CNSearchViewController.h"
//#import "CRMessageListViewController.h"
//#import "SearchOfRestaurantViewController.h"
//#import "LoginView.h"
@implementation BaseNavigationController
#define HomeTag    10001
#define CantingTag 10002
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title颜色
//        NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:30];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:20]}];

    UIImageView *titleView = [UIImageView new];
    titleView.frame = CGRectMake(0, 0, _MainScreen_Width, StatusBarAndNavigationBarHeight);
    titleView.contentMode= UIViewContentModeScaleAspectFill;
    titleView.clipsToBounds = YES;
//    UIImage *image = [[UIImage alloc] initWithCGImage:[UIImage imageNamed:@"背景"].CGImage scale:1 orientation:UIImageOrientationDown];
//    titleView.image = image;
//    [self.navigationBar setBackgroundImage:[self makeImageWithView:titleView] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] forSize:CGSizeMake(10, 10) radius:1 borderWidth:0 borderColor:[UIColor blackColor]]
    forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundColor:[UIColor blackColor] ];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(LoginOrLogout:) name:@"LoginOrLogout" object:nil];
}
    
- (UIImage *)makeImageWithView:(UIView *)view

{
    
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
    

- (UIView *)alphaView
{
    if (!_alphaView)
    {
        CGRect frame = self.navigationBar.frame;
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        _alphaView.tag = 100;
        _alphaView.alpha = 0;
        _alphaView.backgroundColor = ARUITintColor;
    }
    return _alphaView;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //已经开始编辑
    [searchBar endEditing:YES];
    if (searchBar.tag == HomeTag)
    {
        [self openSearchPage];
        
    }
    else if(searchBar.tag == CantingTag)
    {
        [self openSearchOfRestaurant];
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
//    self = [super initWithRootViewController:rootViewController];
    self = [super initWithRootViewController:rootViewController];
    return self;
}

- (void)openLeftVC
{
//    AppDelegate *delegate = (AppDelegate *)CNAppDelegate;
//    [delegate.sildeVC showLeftViewController:YES];
}

- (void)openSearchPage
{
//    CNSearchViewController *searchVC = [[CNSearchViewController alloc] init];
//    [self pushViewController:searchVC animated:YES];
}
- (void)openSearchOfRestaurant
{
//    SearchOfRestaurantViewController *searchVC = [[SearchOfRestaurantViewController alloc] init];
//    [self pushViewController:searchVC animated:YES];
}
- (void)openMessageVC
{
//    if (![CNManager isLogin])
//    {
//        LoginView *loginView = [LoginView loadLoginView];
//        [loginView showLoginView];
//        return;
//    }
//    CRMessageListViewController * vc = [[CRMessageListViewController alloc]init];
//    [self pushViewController:vc animated:YES];
}


//获取未读消息
@end
