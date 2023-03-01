//
//  BaseTabBarViewController.m
//  ChinaNews
//
//  Created by GG_pc on 2018/9/28.
//  Copyright © 2018年 JinPeng. All rights reserved.
//

#import "BaseTabBarViewController.h"
//#import "ARVCUtils.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "HomePageViewController.h"
#import "BuyViewController.h"
#import "NewsViewController.h"
#import "MineViewController.h"
//#import "SelectedViewController.h"
//#import "CISecondStepViewController.h"
//#import "CISecondSelectViewController.h"
//#import "CNSettingViewController.h"
//#import "CNMainViewController.h"
#import "ARTabBar.h"

@interface BaseTabBarViewController () <UITabBarDelegate>

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [UITabBar appearance].translucent = NO;
     HomePageViewController *firstVC = [[HomePageViewController alloc] init];//首页
    firstVC.sid = @"home";
    BuyViewController *newsVC = [[BuyViewController alloc]init]; //餐厅
    newsVC.sid = @"delicious";
    NewsViewController * community = [[NewsViewController alloc]init];//留学
    community.sid = @"overseas_study";
    NewsViewController * encyclopedia = [[NewsViewController alloc]init];//翻译
//    [encyclopedia layoutViews];
    MineViewController *mineVC = [[MineViewController alloc]init];//个人中心
    
    firstVC.tabBarItem.image = [[UIImage imageNamed:@"首页-w"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstVC.tabBarItem.title = [CNManager loadLanguage:@"首页"];
    [firstVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(200, 40, 32)} forState:UIControlStateSelected];
    newsVC.tabBarItem.image = [[UIImage imageNamed:@"A股点买-w"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"A股点买"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newsVC.tabBarItem.title = [CNManager loadLanguage:@"交易"];
    [newsVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(200, 40, 32)} forState:UIControlStateSelected];
//    community.tabBarItem.image = [[UIImage imageNamed:@"翻译默认"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    community.tabBarItem.selectedImage = [[UIImage imageNamed:@"翻译选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    community.tabBarItem.title = [CNManager loadLanguage:@"资讯"];
//    [community.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 19.2)];
//    [community.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(200, 40, 32)} forState:UIControlStateSelected];
    
    encyclopedia.tabBarItem.image = [[UIImage imageNamed:@"资讯-w"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    encyclopedia.tabBarItem.selectedImage = [[UIImage imageNamed:@"股市信息"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    encyclopedia.tabBarItem.title = [CNManager loadLanguage:@"股市信息"];
    [encyclopedia.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(200, 40, 32)} forState:UIControlStateSelected];
    
    
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"我的-w"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"个人中心"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.title = [CNManager loadLanguage:@"个人中心"];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(200, 40, 32)} forState:UIControlStateSelected];
    //BaseNavigationController
    BaseNavigationController *nav1 = [[BaseNavigationController alloc]initWithRootViewController:firstVC];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc]initWithRootViewController:newsVC];
//    BaseNavigationController *nav3 = [[BaseNavigationController alloc]initWithRootViewController:community];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc]initWithRootViewController:encyclopedia];
    BaseNavigationController *nav5 = [[BaseNavigationController alloc]initWithRootViewController:mineVC];
    
    
    //        self.viewControllers = @[nav1,  nav2,nav3 ,nav4,nav5];
    self.viewControllers = @[nav1,nav2,nav4,nav5];
    // Do any additional setup after loading the view.
    ARTabBar *tabBar = [[ARTabBar alloc] init];
    tabBar.delegate = self;
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    self.selectedIndex = 2;
    self.selectedIndex = 0;
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
