//
//  ARCommonMacro.h
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#ifndef ARCommonMacro.h
#define ARCommonMacro.h
//#import "CRLanguageManager.h"
// 添加返回按钮
#define AddBackBarButton \
UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-btn"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked)]; \
backBarButton.imageInsets = UIEdgeInsetsMake(0.0, -10.0, 0.0, 10.0); \
self.navigationItem.leftBarButtonItem = backBarButton; \
self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; \

// 判断字符串是否为空
#define StringIsBlank(string)       [NSString isBlank:string]
#define StringIsNotBlank(string)    [NSString isNotBlank:string]

// 字符串比较
#define StringsIsEquals(a, b) [a isEqualToString:(b)]
// 格式化字符串
#define StringWithFormat(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]
// String -> URL
#define URLWithString(string)       [NSURL URLWithString:string]
// Number->String
#define StringWithInt(num) [NSString stringWithFormat:@"%d", num]
#define StringWithNSInteger(num) [NSString stringWithFormat:@"%ld", num]
#define StringWithNSUInteger(num) [NSString stringWithFormat:@"%lu", num]
#define StringWithFloat(num) [NSString stringWithFormat:@"%f", num]
#define StringWithDouble(num) [NSString stringWithFormat:@"%lf", num]
#define StringWithCGFloat(num) [NSString stringWithFormat:@"%lf", num]

// 颜色(RGB)
#define RGBColor(r, g, b)       [UIColor colorWithRed:(r)/255.0f    \
                                                green:(g)/255.0f    \
                                                 blue:(b)/255.0f alpha:1.0]
#define RGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f    \
                                                green:(g)/255.0f    \
                                                 blue:(b)/255.0f alpha:a]
// RGB颜色转换（16进制->10进制）
#define UIColorFromHexRGB(rgbValue)    \
                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0    \
                                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0   \
                                 blue:((float)(rgbValue & 0xFF))/255.0 \
                                alpha:1.0]

// RGB颜色转换（16进制->10进制）
#define UIColorFromHexARGB(rgbValue)    \
                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0    \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0   \
                blue:((float)(rgbValue & 0xFF))/255.0 \
                alpha:((float)((rgbValue & 0xFF000000) >> 24)) / 255.0]

// 角度转弧度
#define ANGLE(a) 2.0 * M_PI / 360.0 * a

// 屏幕尺寸
#define MainScreen       [UIScreen mainScreen]
#define ScreenSize      [UIScreen mainScreen].bounds.size
#define ScreenBounds    [UIScreen mainScreen].bounds
#define ScreenWidth     ScreenSize.width
#define ScreenHeight    ScreenSize.height
#define CurrentScale    MainScreen.scale

// View 坐标和宽高
#define X(v)        (v).frame.origin.x
#define Y(v)        (v).frame.origin.y
#define Width(v)    (v).frame.size.width
#define Height(v)   (v).frame.size.height

#define MinX(v)     CGRectGetMinX((v).frame)
#define MinY(v)     CGRectGetMinY((v).frame)

#define MidX(v)     CGRectGetMidX((v).frame)
#define MidY(v)     CGRectGetMidY((v).frame)

#define MaxX(v)     CGRectGetMaxX((v).frame)
#define MaxY(v)     CGRectGetMaxY((v).frame)

#define RectChangeX(v, x)          CGRectMake(x, Y(v), Width(v), Height(v))
#define RectChangeY(v, y)          CGRectMake(X(v), y, Width(v), Height(v))
#define RectChangePoint(v, x, y)   CGRectMake(x, y, Width(v), Height(v))
#define RectChangeWidth(v, w)      CGRectMake(X(v), Y(v), w, Height(v))
#define RectChangeHeight(v, h)     CGRectMake(X(v), Y(v), Width(v), h)
#define RectChangeSize(v, w, h)    CGRectMake(X(v), Y(v), w, h)


// 沙盒路径
#define PathOfAppHome       NSHomeDirectory()
#define PathOfTemp          NSTemporaryDirectory()
#define PathOfDucument      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0]

// 资源／路径
#define MainBundle [NSBundle mainBundle]
#define MainSB [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define PathOfMainBubdle(name, type)    [MainBundle pathForResource:name ofType:type]
#define NibOfMainBundle(name) [MainBundle loadNibNamed:name owner:nil options:nil].firstObject
#define ViewOfMainBundle(name) [MainBundle loadNibNamed:name owner:nil options:nil].firstObject
#define ViewOfMainBundleWithOwner(name, ownerObj) [MainBundle loadNibNamed:name owner:ownerObj options:nil].firstObject

// 从Storyboard中获取ViewController
#define ViewControllerOfMainSB(identifier)   [MainSB instantiateViewControllerWithIdentifier:identifier]
#define InitialViewControllerOfMainSB        [MainSB instantiateInitialViewController]

// PNG JPG 图片路径
#define PNGPath(name)   PathOfMainBundle(name, @"png")
#define JPEGPath(name)  PathOfMainBundle(name, @"jpg")

// 加载图片
#define PNGImage(name)          [UIImage imageWithContentsOfFile:PNGPath(name)]
#define JPEGImage(name)         [UIImage imageWithContentsOfFile:JPEGPath(name)]
#define Image1(name, type)       [UIImage imageWithContentsOfFile:PathOfMainBubdle(name, type)]

// 字体大小(常规/粗体)
#define BoldSystemFont(fontsize)    [UIFont boldSystemFontOfSize:fontsize]
#define SystemFont(fontsize)        [UIFont systemFontOfSize:fontsize]
#define Font(name, fontsize)        [UIFont fontWithName:(name) size:(fontsize)]

// 系统版本
#define OSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
// 是否为phone
#define DeviceIsPhone  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
// 是否为pad
#define DeviceIsPad  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
// 当前语言
#define CurrentLanguage [[NSLocale preferredLanguages] objectAtIndex:0]

// 本地化字符串
#define LocalString(x, ...)     NSLocalizedString(x, nil)
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** X天的秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** X天的毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))

// Log打印，发布阶段自动关闭
#ifdef DEBUG
#define WZMLog(...)  NSLog(__VA_ARGS__)
#else
#define WZMLog(...)
#endif

#define  KSoundState            @"ksoundboxstate"

// 为TextField设置左右空白
#define SetTextFiledLeftView(textFiled, padding) \
                textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, padding, 0.0)]; \
                textFiled.leftViewMode = UITextFieldViewModeAlways;
#define SetTextFiledRightView(textFiled, padding) \
textFiled.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, padding, 0.0)]; \
textFiled.rightViewMode = UITextFieldViewModeAlways;

// View 圆角和加边框
#define ViewBorderRadius(view, radius, lienWidth, lienColor)    \
                [view.layer setCornerRadius:(radius)];\
                [view.layer setMasksToBounds:YES];  \
                [view.layer setBorderWidth:(lienWidth)];    \
                [view.layer setBorderColor:lienColor.CGColor];
// View 圆角
#define ViewRadius(view, radius)    \
                [view.layer setCornerRadius:(radius)];  \
                [view.layer setMasksToBounds:YES];

// 判断手机号或者邮箱是否输入正确
#define RegexEmail  @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"
#define RegexPhone  @"^((\\86)|(\\+86 ))?1\\d{10}$"
#define RegexNotBlack  @"^.+$"
#define RegexPassWord  @"^([a-zA-Z0-9_]){6,12}$"

// Block weakself strongself
#define WEAKSELF __weak typeof(self) weakself = self;
#define STRONGSELF __strong typeof(weakself) strongself = weakSelf;


// UIApplication, AppDelegate
#define SharedApplication [UIApplication sharedApplication]
#define MyAppDelegate ((AppDelegate *)SharedApplication.delegate)

#define KShowFavorHome          @"KShowFavorHome"
#define KShowSubscribeHome      @"KShowSubscribeHome"

// 状态栏
#define SetLightContentStatusBar SharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
#define SetBlackContentStatusBar SharedApplication.statusBarStyle = UIStatusBarStyleDefault;

// NSNotificationCenter
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#define NotificationCenterAddObserverOfSelf(selectorName, notificationName, ojbect) \
[DefaultNotificationCenter addObserver:self \
selector:@selector(selectorName) \
name:notificationName \
object:ojbect];
#define NOtificationCenterRemoveObserverOfSelf [DefaultNotificationCenter removeObserver:self];



#define GESTURE_TAP(tapView,SEL) {\
tapView.userInteractionEnabled = YES;\
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:SEL];\
[tapView addGestureRecognizer:tap];\
}

#endif
