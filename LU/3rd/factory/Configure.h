//
//  Configure.h
// 
//
//  Created by lolo on 14-4-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#ifndef YiWuBao_Configure_h
#define YiWuBao_Configure_h
//#import "ServerConfigure.h"
//当前语言
#define LG [[NSUserDefaults standardUserDefaults] objectForKey:@"lg"]?:@"2"
//时间戳
#define  DATETIME (long)[[NSDate date]timeIntervalSince1970]-1404218190
#define CNAppDelegate [UIApplication sharedApplication].delegate

//width height
#define MainScreenH [UIScreen mainScreen].bounds.size.height
#define MainScreenW [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAINWIDTH  [[UIScreen mainScreen] bounds].size.width
#define MULTIPLE [[UIScreen mainScreen] bounds].size.width/320.
#define MULTIPLE375 [[UIScreen mainScreen] bounds].size.width/375.
#define MULTIPLEH [[UIScreen mainScreen] bounds].size.height/568.

// iPhone X
#define  iPhoneX (MAINWIDTH == 375.f && MAINHEIGHT == 812.f ? YES : NO)
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// Status bar & navigation bar height.
#define  StatusBarAndNavigationBarHeight ( (iPhoneX||IS_IPHONE_Xr||IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? 88.f : 64.f)

#define BatteryHeight ( (iPhoneX||IS_IPHONE_Xr||IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? 44.f : 20.f)
#define NavBarHeight  44.0
#define TabBarHeight  ( (iPhoneX||IS_IPHONE_Xr||IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? (49.f+34.f) : 49.f)
#define MENUBUTTONHIGH 40.0

//隐藏状态栏后上沿高度
#define  ZEROHEADERHIGH (iPhoneX ? 24.f : 0.f)

#define PAGETIMERWIDE MAINWIDTH/4
#define PAGETIMERHIGH 2
#define PAGEDEFINEWIDE 10
//是否4寸以上屏幕
//#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 [[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width==1.5||[[UIScreen mainScreen] currentMode].size.width/[[UIScreen mainScreen] currentMode].size.height==.75
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6B ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iOS8
#define IS_iOS_8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//判断是否是iOS7
#define IS_iOS_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断是否是iOS6
#define IS_iOS_6  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

//Notification key
#define kReplyProductAddNotification                                @"kReplyProductAddNotification"
#define kReplyProductsSubmitNotification                            @"kReplyProductsSubmitNotification"
#define kOrderExpressSubmitNotification                             @"kOrderExpressSubmitNotification"


//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/weChat4.db"]

//浏览历史路径

#define HISTORY_PATH(key) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",(key)]]

//设备屏幕大小
#define _MainScreenFrame   [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define _MainScreen_Width  _MainScreenFrame.size.width
//设备屏幕高 20,表示状态栏高度.如3.5inch 的高,得到的__MainScreenFrame.size.height是480,而去掉电量那条状态栏,我们真正用到的是460;
#define _MainScreen_Height (_MainScreenFrame.size.height)

#define Scale (_MainScreen_Width / 320.0) //用苹果5标注的编程比例

//背景颜色
#define BgColor [UIColor whiteColor];
//设置相对标准屏幕的高度差
#define _MainScreen_SubHeight (_MainScreen_Height - 480)

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBTOPCOLOR [UIColor colorWithRed:241/255.0 green:114/255.0 blue:155/255.0 alpha:1.0]
//动画效果

#define ANIMATION @"cube"

//weakSelf
#define WEAKSELF(weakSelf) __weak typeof(self) weakSelf = self

//URL ENCODE
#define URLByAddingPercentEscapes(url) [NSURL URLWithString:[(url) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]

//NSLog
#ifndef __OPTIMIZE__
#define NSLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog(...){}
#endif

#endif
