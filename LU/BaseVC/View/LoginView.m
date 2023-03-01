//
//  LoginView.m
//  ZhongYi
//
//  Created by WinterChen on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "LoginView.h"
//#import "WinSocialShareTool.h"
#import <ShareSDK/ShareSDK.h>
#import "HudManager.h"
#include "AppDelegate.h"
//#import "BehaviorGather.h"
#import "GTMBase64.h"
#import "UIImage+Resizing.h"

@interface LoginView ()
@property (weak, nonatomic) IBOutlet UILabel *weXin;
@property (weak, nonatomic) IBOutlet UILabel *QQLb;
@property (weak, nonatomic) IBOutlet UILabel *faceBookLB;
@property (weak, nonatomic) IBOutlet UILabel *twLb;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weboLb;

@end

@implementation LoginView

- (void)showLoginView
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    style.alignment = NSTextAlignmentCenter;
//    NSString *welcomeString = [CNManager loadLanguage:@"欢迎\n您可以通过以下账号登录"];
    
    self.welcomeLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[CNManager isCN]?@"欢迎\n您可以通过以下账号登录":@"Benvenuto\nIscriviti con" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSKernAttributeName : @(6.0), NSParagraphStyleAttributeName : style}];
    self.welcomeLabel.textColor = [UIColor whiteColor];
//    [UIApplication sharedApplication].statusBarHidden = YES;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImgView.image = [UIImage imageNamed: @"loginBG"];
    UIImageView * iv = [JPMyControl createImageViewWithFrame:bgImgView.bounds ImageName:@"loginBGY"];
    [bgImgView addSubview:iv];
    [self insertSubview:bgImgView atIndex:0];
    _weXin.textAlignment = NSTextAlignmentCenter;
    _QQLb.textAlignment = NSTextAlignmentCenter;
    _faceBookLB.textAlignment = NSTextAlignmentCenter;
    _twLb.textAlignment = NSTextAlignmentCenter;
    _weboLb.textAlignment = NSTextAlignmentCenter;
    
    _weXin.textColor = [UIColor whiteColor];
    _QQLb.textColor = [UIColor whiteColor];
    _faceBookLB.textColor = [UIColor whiteColor];
    _twLb.textColor = [UIColor whiteColor];
    _weboLb.textColor = [UIColor whiteColor];
    
    _weXin.text = [CNManager loadLanguage:@"微信"];
    _QQLb.text = [CNManager loadLanguage:@"QQ"];
    _faceBookLB.text = [CNManager loadLanguage:@"Facebook"];
    _twLb.text = [CNManager loadLanguage:@"Twitter"];
    _weboLb.text = [CNManager loadLanguage:@"新浪微博"];
    
    _weXin.font = [UIFont systemFontOfSize:12];
    _QQLb.font = [UIFont systemFontOfSize:12];
    _faceBookLB.font = [UIFont systemFontOfSize:12];
    _twLb.font = [UIFont systemFontOfSize:12];
    _weboLb.font = [UIFont systemFontOfSize:12];
    
//    _weXin.text = [];
//    _QQLb.;
//    _faceBookLB.;
//    _twLb.;
//    _weboLb.;
    
//    [((AppDelegate *)([UIApplication sharedApplication].delegate)).rootC.navigationController.view addSubview:self];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

+ (instancetype)loadLoginView
{
    return [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].firstObject;
}

- (IBAction)closeLoginView
{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self layoutIfNeeded];
    }];
//    [UIApplication sharedApplication].statusBarHidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)loginWithType:(SSDKPlatformType)loginType
{
    /*
    [FAFProgressHUD showMessage:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FAFProgressHUD hideHUD];
    });
    [WinSocialShareTool win_loginWithPlatformType:loginType resultBlock:^(WinSSDKUser *user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.ResultBlock) {
                self.ResultBlock(user.uid ? user : nil);
            }
            if (user.uid) {
                [self closeLoginView];
                NSString *loginTpyeString = [user.uid substringToIndex:2];
                NSString *RegistrationID = [WinSwitchLanguageTool win_getRegistrationId];
                if (RegistrationID.length == 0) {
                    RegistrationID = @"";
                }
                NSDictionary *paramas = @{@"LoginType" : loginTpyeString, @"LoginCode" : user.uid,@"RegistrationID" : RegistrationID,@"SysTemType" : @"2"};
                
                NSLog(@"%@",paramas);
                
                [FAFHttpTool faf_POST:[HTTPURL stringByAppendingString:@"Login"] parameters:paramas success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                    if (((NSString *)responseObject[@"Code"]).integerValue > 0) {
                        NSLog(@"%@",responseObject);
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                }];
            }
        });
    }];
     */
    [ShareSDK getUserInfo:loginType
     onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
         if (state == SSDKResponseStateSuccess)
         {
             NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
             if (user.credential.token) {
                 [dataDict setObject:user.credential.token forKey:@"ats"];
             }
             if (user.uid) {
                 [dataDict setObject:user.uid forKey:@"uid"];
             }
             NSString * type = nil;
             switch (loginType) {
                 case 1:
                     type = @"sina_weibo";
                     break;
                 case SSDKPlatformTypeQQ:
                     type = @"qq";
                     break;
                 case 8:
                     type = @"facebook";
                     break;
                 case 10:
                     type = @"twitter";
                     break;
                 case SSDKPlatformTypeWechat:
                     type = @"wechat";
                     break;
                 default:
                     type = @"unknown";
                     break;
             }
            [dataDict setObject:type forKey:@"tpf"];
             NSLog(@"type = %@",type);
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);//user.icon
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [CNManager saveObject:@"" byKey:@"user_nickName"];
             [CNManager saveObject:@"" byKey:@"user_icon"];
             if (user.nickname)
             {
                 [CNManager saveObject:user.nickname byKey:@"user_nickName"];
             }
             if (user.icon)
             {
                 [CNManager saveObject:user.icon byKey:@"user_icon"];
             }
            [self loadLogin:dataDict];
         }else{
             [CNManager showWindowAlert:[CNManager loadLanguage:@"登录失败"]];
         }
     }];
}

- (void)loadLogin:(NSDictionary *)dataDict{
    
    NSString *dataString = [NewSettingsManager getUrlStringWithParam:nil prarm:dataDict];
    NSString *dataStringEncoded = [dataString URLEncodedString];
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/ServiceCenter.do",
                           [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"action": @"userLoginByThirdParty",
                                 @"pv": @"3",
                                 @"format": @"json",
                                 @"verf": [dataStringEncoded md5],
                                 @"data": [NewSettingsManager encodeBase64:dataStringEncoded]};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[HudManager sharedHudManager] hideProgressHUD:self];
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSLog(@"%@",responseObject);
            NSString *msgString = [responseObject objectForKey:@"msg"];
            NSString *errcodeString = [responseObject objectForKey:@"errcode"];
            if ([errcodeString isEqualToString:@"100000"] && [msgString isEqualToString:@"Success"]) {
                NSArray * arr = responseObject[@"result"];
                if (arr.count) {
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:0]];
                    
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *DateTime = [formatter stringFromDate:date];
                    
                    NSDictionary *dictionaryB = @{
                                                 @"eventType":@"login",
                                                 @"eventTime":DateTime,
                                                 @"userName":[dictionary objectForKey:@"register_name"],
                                                 @"other":@"",
                                                 };
//                    [BehaviorGather gatherBehaviorMessage:dictionaryB];

                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *qqID = [dictionary objectForKey:@"qq_id"];
                    [userDefaults setObject:qqID forKey:@"qq_id"];
                    
                    
                    [SettingsManager sharedSettingsManager].username = [dictionary objectForKey:@"register_name"];
                    [SettingsManager sharedSettingsManager].password = [dictionary objectForKey:@"register_password"];
                    
                    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"AppLoginOK"];//登录状态
                    
                    
                    [userDefaults setObject:dictionary forKey:@"AppUserInfo"];
                    [userDefaults setObject:[dictionary objectForKey:@"first_login"] forKey:@"first_login"]; // 判断第一次登录
                    [userDefaults setObject:@"qq" forKey:@"AppUserType"];//用户类型
                    [userDefaults synchronize];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:@"YES" forKey:@"LoginOK"];
                    NSString *photoString = [dictionary objectForKey:@"photo"];
                    if (photoString) {
                        [userInfo setObject:photoString forKey:@"photo"];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LOGINUSERPHOTO"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // photoString服务器不一定返回 LoginOK登录成功标识 // 成功登录后返回"我的"
                    
                    [CNManager showWindowAlert:[CNManager loadLanguage:@"登录成功"]];
                    [CNManager CIGetCollectedArray];
                    NSString *nickname = dictionary[@"nickname"];
                    NSString *photo = dictionary[@"photo"];
                    if (!nickname.length || !photo.length)
                    {
                        [dictionary setObject:[CNManager loadByKey:@"user_nickName"] forKey:@"nickname"];
                        [dictionary setObject:[CNManager loadByKey:@"user_icon"] forKey:@"photo"];
//                        [dictionary setObject:[CNManager loadByKey:@"sex"] forKey:@"sex"];
                        [userDefaults setObject:dictionary forKey:@"AppUserInfo"];
                        [userDefaults synchronize];
                        [LoginView saveLoginByThirdUserInfo];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOrLogout" object:nil userInfo:userInfo];
                    [self closeLoginView];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HudManager sharedHudManager] hideProgressHUD:self];
        [CNManager showWindowAlert:[CNManager loadLanguage:@"登录失败"]];
    }];

}

- (IBAction)wechatLogin {
    [self loginWithType:SSDKPlatformTypeWechat];
}

- (IBAction)qqLogin {
    [self loginWithType:SSDKPlatformTypeQQ];
}


- (IBAction)facebookLogin {
    [self loginWithType:SSDKPlatformTypeFacebook];
}

- (IBAction)twitterLogin {
    [self loginWithType:SSDKPlatformTypeTwitter];
}

- (IBAction)weiboLogin {
    [self loginWithType:SSDKPlatformTypeSinaWeibo];
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, bounds.size.height, bounds.size.width, bounds.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = bounds;
        [self layoutIfNeeded];
    }];
}
+(void)saveLoginByThirdUserInfo{
    
    NSDictionary *_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserInfo"];
    if (!_user) {
        return;
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[SettingsManager getGeneralParameters]];
    if (_user[@"nickname"]) {
        NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)_user[@"nickname"], NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
        
        
        [dataDict setObject:encodedString forKey:@"unk"];
    }
    
    if (_user[@"photo"]) {
        [dataDict setObject:_user[@"photo"] forKey:@"upt"];
    }
    [self saveLoginPhoto:_user[@"photo"]];
    //接口upUserInfo 上传用户信息
    NSString *dataString = [NewSettingsManager getUrlStringWithParam:nil prarm:dataDict]; //dataDict
    NSString *dataStringEncoded = [dataString URLEncodedString];
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/ServiceCenter.do?action=upUserInfo&pv=3&format=json",
                           [SettingsManager sharedSettingsManager].applicationServerURL];
    NSDictionary *parameters = @{@"verf": [dataStringEncoded md5],
                                 @"data": [NewSettingsManager encodeBase64:dataStringEncoded]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        DLog(@"%@ %@", responseObject, [responseObject class]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msgString = [responseObject objectForKey:@"msg"];
            NSString *errcodeString = [responseObject objectForKey:@"errcode"];
            if ([errcodeString isEqualToString:@"100000"] && [msgString isEqualToString:@"Success"]) {
                
            } else {
                
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
}
//上传用户头像
+ (void)cropImageFinish:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    UIImage *newImage = nil;
    CGFloat maxSize = 60;
    if ((width > maxSize) || (height > maxSize)) {
        newImage = [image scaleToSize:CGSizeMake(maxSize, maxSize)]; //UIImage+Resizing.h
    } else {
        newImage = image;
    }
    NSData *binaryImageData = UIImagePNGRepresentation(newImage);
    [self p_uploadUserAvatar:binaryImageData];
}
// 上传账号头像
+ (void)p_uploadUserAvatar:(NSData *)data {
    //通用参数 包含账号信息
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[SettingsManager getGeneralParameters]];
    [dataDict setValue:@"" forKey:@"phd"];
    [dataDict setValue:[[GTMBase64 stringByEncodingData:data] URLEncodedString] forKey:@"phc"]; // GTMBase64
    NSString *dataString = [NewSettingsManager getUrlStringWithParam:nil prarm:dataDict];
    NSString *dataStringEncoded = [dataString URLEncodedString];
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/ServiceCenter.do",
                           [SettingsManager sharedSettingsManager].applicationServerURL];
    NSDictionary *parameters = @{@"action": @"upUserPhoto",
                                 @"pv": @"3",
                                 @"format": @"json",
                                 @"verf": [dataStringEncoded md5],
                                 @"data": [NewSettingsManager encodeBase64:dataStringEncoded]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {        if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString *msgString = [responseObject objectForKey:@"msg"];
        NSString *errcodeString = [responseObject objectForKey:@"errcode"];
        if ([errcodeString isEqualToString:@"100000"] && [msgString isEqualToString:@"Success"]) {
            
            
        }
    }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}
+(void)saveLoginPhoto:(NSString *)photo{
    if (!photo || photo.length == 0)
    {
        return;
    }
    [self cropImageFinish:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo]]]];
    
    
}
@end
