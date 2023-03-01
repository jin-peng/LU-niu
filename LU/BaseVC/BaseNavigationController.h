//
//  BaseNavigationController.h
//  ChinaNews
//
//  Created by siyuzhe on 16/11/3.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController <UISearchBarDelegate>
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UILabel *messageCount;
@property (nonatomic, strong) UIView *alphaView;//导航条背景
@property (nonatomic, strong) NSString *sid;

@end
