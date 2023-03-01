//
//  LogoutView.h
//  ZhongYi
//
//  Created by WinterChen on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoutView : UIView

@property (nonatomic, strong) void(^logoutBlock)(BOOL success);
+ (instancetype)loadLogoutView;
- (void)showLogoutView;

@end
