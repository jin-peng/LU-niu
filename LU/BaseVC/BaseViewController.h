//
//  BaseViewController.h
//  ChinaNews
//
//  Created by siyuzhe on 16/11/3.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak)UIViewController *viewController;
@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong) void (^moveToPage)(NSInteger);
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong)UIView *alphaView;//导航条背景

- (void)layoutViews;
@end
