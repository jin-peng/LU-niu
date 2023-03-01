//
//  BaseViewController.m
//  ChinaNews
//
//  Created by siyuzhe on 16/11/3.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
//#import <UMMobClick/MobClick.h>

@implementation BaseViewController
@synthesize tableView = _tableView;

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSString * className = [NSString stringWithFormat:@"%@", self.class];
//    [MobClick endLogPageView:className];
    
//    NSString *nowVC = [NSString stringWithFormat:@"%@", self.class];
//    if ([nowVC isEqualToString:@"CNSettingViewController"]) {
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationItem.title = @"";
//        [self.navigationItem setHidesBackButton:YES];
//
//        self.navigationController.navigationBar.hidden = NO;
//        [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
//    }else{
//        //        self.navigationController.navigationBar.hidden = NO;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.view.backgroundColor = UIColorFromRGB(0xdfdfdf);
//    NSString * className = [NSString stringWithFormat:@"%@", self.class];
//    [MobClick beginLogPageView:className];
/*    BaseNavigationController *nv;
    if (self.viewController) {
        nv = (BaseNavigationController *)self.viewController.navigationController;
    }else{
        nv = (BaseNavigationController *)self.navigationController;
    }
    if (nv) {
        self.alphaView = nv.alphaView;
        CGFloat y = _tableView.contentOffset.y;
        _alphaView.alpha = y / (_MainScreen_Width * 0.6);
    }
    
*/
 //   CGFloat y = _tableView.contentOffset.y;
 //   _alphaView.alpha = y / (_MainScreen_Width * 0.6);
    //还原导航条的样子
    
//    NSString *nowVC = [NSString stringWithFormat:@"%@", self.class];
//    if ([nowVC isEqualToString:@"CNSettingViewController"]) {
//        [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
//    }else{
//    }

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = BgColor;
//    NSNotificationCenter *noticeCenter = [NSNotificationCenter defaultCenter];
//    [noticeCenter addObserver:self selector:@selector(changedLanguage) name:@"ChangedLanguage" object:nil];
//    [self layoutViews];
}


- (void)layoutViews
{

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
