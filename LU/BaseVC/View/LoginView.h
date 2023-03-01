//
//  LoginView.h
//  ZhongYi
//
//  Created by WinterChen on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

/**  登录结果回调 */

+ (instancetype)loadLoginView;
- (void)showLoginView;
- (IBAction)closeLoginView;

@end
