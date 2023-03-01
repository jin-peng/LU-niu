//
//  CNManager.m
//  ChinaNews
//
//  Created by JinPeng on 2016/11/15.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import "CNManager.h"
#import "LPPopup.h"
#import "YRSideViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
//#import "LoginView.h"
#import <SBJson/SBJson4.h>
//#import "NYXImagesHelper.h"

BOOL  isHengPing;
@implementation CNManager
#pragma mark 获取语言

+(CNManager *)shareInstance{
    static id instance;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        [instance testLanguage:LG];
    });
    return instance;
}

- (void)testLanguage:(NSString *)tmp{
//    NSString * tmp = LG;
//    if ([tmp isEqualToString:@"1"]) {
//        _language = [[NSDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@.plist",tmp]];
//    }else{
        _nowLG = tmp;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
        _language = [[NSDictionary alloc] initWithContentsOfFile:path];
//    }
    
}

+ (void)writePlist{
    NSString * tmp = @"2";
    NSString *path = [[NSBundle mainBundle] pathForResource:tmp ofType:@"plist"];
    NSDictionary * tmpDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary * tmp1 = [[NSMutableDictionary alloc]init];
    for (NSString *key in [tmpDic allKeys]) {
        [tmp1 setObject:key forKey:key];
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"test.plist"];
    //输入写入
    [tmp1 writeToFile:filename atomically:YES];
    NSLog(@"路径：%@",plistPath1);
}

- (void)changeLanguage:(NSString *)languge{
    [CNManager saveObject:languge byKey:@"lg"];
    [self testLanguage:languge];
}

+ (NSString *)loadLanguage:(NSString *)baseString{
    if ([[CNManager shareInstance].nowLG isEqualToString:@"2"]) {
        return baseString;
    }else{
        NSString * tmp = nil;
        if ([CNManager shareInstance].language) {
            tmp = [CNManager shareInstance].language[baseString];
        }
        return (tmp?tmp:baseString);
    }
}

+ (NSString *)languageID{
    return [self loadByKey:MYLANGUAGE];
}

+ (void)saveObject:(id)obj byKey:(NSString *)key{
    NSUserDefaults*df=[NSUserDefaults standardUserDefaults];
    [df setObject:obj forKey:key];
    [df synchronize];
}

+ (id)loadByKey:(NSString *)key{
    NSUserDefaults*df=[NSUserDefaults standardUserDefaults];
    return [df objectForKey:key];
}

+ (BOOL)hasLogin{
    return [CNManager isLogin];
}

+ (void)loginOut{
    [CNManager saveObject:nil byKey:@"AppLoginOK"];
    [CNManager saveObject:nil byKey:USERID];
    [CNManager saveObject:nil byKey:MONEYCODE];
    [CNManager saveObject:nil byKey:USERPHONE];
    
//    if (userdic[@"nick_name"]&&[userdic[@"nick_name"] length])
        [CNManager saveObject:nil byKey:USERNAME];
    
        [CNManager saveObject:@"0" byKey:MONEY];
    
//    if (userdic[@"rules"])
        [CNManager saveObject:nil byKey:RULES];
        [CNManager saveObject:nil byKey:REALNAME];
        [CNManager saveObject:nil byKey:REALCODE];
    
        [CNManager saveObject:nil byKey:BANKCARD];
        [CNManager saveObject:nil byKey:BANKNAME];
}

+ (void)showWindowAlert:(NSString*)alert{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LPPopup *popup = [LPPopup popupWithText:alert];
    popup.alpha=.7;
    [popup showInView:window
        centerAtPoint:window.center
             duration:kLPPopupDefaultWaitDuration
           completion:nil];
}

+ (void)showWindowAlert:(NSString*)alert center:(CGPoint)center time:(CGFloat)time{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LPPopup *popup = [LPPopup popupWithText:alert];
    popup.alpha=.5;
    [popup showInView:window
        centerAtPoint:center
             duration:time
           completion:nil];
}

+ (void)clearMemoryLargeThanSize:(NSInteger)maxSize{
    
}
+ (void)shareView
{
    /*
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.frame = CGRectMake(0,_MainScreen_Height, _MainScreen_Width,184);
    NSString *str = @"Share to...";
    if ([LG isEqualToString:@"2"])
    {
        str = @"分享到...";
    }
    UILabel *title = [[UILabel alloc] init];
    title.text = str;
    title.font = [UIFont systemFontOfSize:15];
    [title sizeToFit];
    title.x = 13;
    title.y = 0;
    title.textColor = UIColorFromRGB(0xb9b9b9);
    [shareView addSubview:title];
    
    NSArray *imageArray = @[@"转发图标-1",@"转发图标-2",@"转发图标-3",@"转发图标-4"];
    float jiange = (_MainScreen_Width - 42 * 4) / 8;
    CGRect frame;
    for (int i = 0; i < imageArray.count; i++)
    {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        but.frame = CGRectMake(jiange + i * (jiange * 2 + 42), CGRectGetMaxY(title.frame) + 21, 42, 42);
        [shareView addSubview:but];
        if (i == 0)
        {
            frame = but.frame;
        }
    }
    UIButton *closeBtn = [UIButton buttonWithType:1];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    closeBtn.x = _MainScreen_Width - 12 - closeBtn.width;
    closeBtn.y = CGRectGetMaxY(frame) + 63;
    [closeBtn addTarget:self action:@selector(closeShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:closeBtn];
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    [win addSubview:shareView];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = CGRectMake(0,_MainScreen_Height - 184, _MainScreen_Width,184);
    }];*/
}
+ (void)closeShareView:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        btn.superview.frame = CGRectMake(0,_MainScreen_Height, _MainScreen_Width,184);
    } completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
    }];
}
+ (NSString *)setShowTime:(double)time{
//    double datetime = [[NSDate date] timeIntervalSince1970];
//    double x = datetime - time/1000;
//    if (x<=60*10) {
//        return [CNManager loadLanguage:@"刚刚"];
//    }else if (x<=60*60){
//        if (x/60 == 1)
//        {
//            return [NSString stringWithFormat:@"%ld%@",(NSInteger)x/60,[CNManager isCN]?@"分钟前":@"minuto fa"];
//        }
//        else
//        {
//            return [NSString stringWithFormat:@"%ld%@",(NSInteger)x/60,[CNManager isCN]?@"分钟前":@"minuti fa"];
//        }
//    }else if (x<=60*60*24){
//        if (x/60/60 == 1)
//        {
//            return  [NSString stringWithFormat:@"%ld%@",(NSInteger)x/60/60,[CNManager isCN]?@"小时前":@"ora fa"];
//        }
//        else
//        {
//            return  [NSString stringWithFormat:@"%ld%@",(NSInteger)x/60/60,[CNManager isCN]?@"小时前":@"ore fa"];
//        }
//
//    }else{
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //        [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        
    [formatter setDateFormat:@"yyyy/MM/dd HH:MM:SS"];
        return [formatter stringFromDate:confromTimesp];
//    }
}
+ (NSString *)setShowDateTime:(double)time{
    //    double datetime = [[NSDate date] timeIntervalSince1970];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter stringFromDate:confromTimesp];
}

+ (double)getTimeStamp:(NSString*)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:timeStr];
    double  stamp =  (double)[date timeIntervalSince1970];
    return stamp*1000;
}

//获取item的size
//视频的layout （已经补充其他模块layout）
+ (ItemParameter)getItemSize:(NSString *)layout
{
    if (!layout)
    {
        layout = Layout_Normal;
    }
    CGFloat imgX = 0;
    CGFloat imagW = _MainScreen_Width - imgX * 2;
    CGFloat imgY = 0;
    CGFloat scale = .44;//默认宽高比2：1；
    CGFloat jianJu = 4;
    CGFloat titleW = imagW;
    
    if ([layout isEqualToString:Layout_Five] || [layout isEqualToString:Layout_Three])//一行五个或三个的小图标
    {
        imagW = (_MainScreen_Width - 22 - jianJu * 4) / 5.0;
        scale = 1.0;
    }
    else if ([layout isEqualToString:Layout_Big_Video])//大图比2：1
    {
        imagW = _MainScreen_Width - 22;
        scale = 1 / 2.0;
    }
    else if ([layout isEqualToString:Layout_Big_Other])
    {
        imgY = 10;
        titleW = imagW - 20;
    }
    else if ([layout isEqualToString:Layout_Two])//一行两个，宽高比 3：2
    {
        imagW = (_MainScreen_Width - 22 - jianJu * 1) / 2.0;
        scale = 2 / 3.0;
    }
    else if ([layout isEqualToString:Layout_Three_Video])//一行三个，宽高比 3: 4
    {
        jianJu = 6;
        imagW = (_MainScreen_Width - 22 - jianJu * 2 ) / 3.0;
        scale = 4 / 3.0;
    }
    else if ([layout isEqualToString:Layout_Two_unTitle1] || [layout isEqualToString:Layout_Two_unTitle2] || [layout isEqualToString:Layout_Two_unTitle3])//一行两个，无标题
    {
        imagW = (_MainScreen_Width - 22 - jianJu * 1) / 2.0;
        scale = 2 / 3.0;
    }
    else if ([layout isEqualToString:Layout_Three_Other] || [layout isEqualToString:Layout_Three_Other2])//一行三个，宽高比 1: 1
    {
        jianJu = 6;
        imagW = (_MainScreen_Width - 22 - jianJu * 2 ) / 3.0;
        scale = 1 / 1.0;
    }
    else if ([layout isEqualToString:Layout_Image_title])
    {
        jianJu = 6;
        imagW = 55;
        imgY = 6;
        scale = 1 / 1.0;
    }
    else if ([layout isEqualToString:Layout_Word] || [layout isEqualToString:Layout_Twoline])
    {
        jianJu = 6;
        imagW = _MainScreen_Width - 22;
        imgY = 4;
        scale = 0.0;
    }
    ItemParameter param; param.imgW = imagW; param.scale = scale; param.imgX = imgX; param.imgY = imgY;
    return param;
}
+ (int)getNumberOfSec:(NSString *)layout
{
    if (!layout)
    {
        layout = Layout_Normal;
    }
    int num = 0;
    if ([layout isEqualToString:Layout_Big_Video] || [layout isEqualToString:Layout_Big_Other])
    {
        num = 1;
    }
    else if ([layout isEqualToString:Layout_Two])
    {
        num = 2;
    }
    else if ([layout isEqualToString:Layout_Three_Video] || [layout isEqualToString:Layout_Three_Other] || [layout isEqualToString:Layout_Three_Other2])
    {
        num = 3;
    }
    else if ([layout isEqualToString:Layout_Two_unTitle1] || [layout isEqualToString:Layout_Two_unTitle2] || [layout isEqualToString:Layout_Two_unTitle3])//一行两个，无标题
    {
        num = 2;
    }
    else if ([layout isEqualToString:Layout_Word] || [layout isEqualToString:Layout_Twoline])
    {
        num = 1;
    }
    else
    {
        num = 1;//如果没有就返回1；
    }
    return num;
}

/**
 把每一个区的每一行的高度额外值（取每一行所有cell其中最大的H）保存到self.heightArray，每次刷新都先去看self.heightArray中有没有这个高度额外值，如果没有先去计算这一行中最高的cell，然后把这个值添加到self.heightArray，再去取。
 */
+ (void)addHeight:(NSIndexPath *)indexPath heightArray:(NSMutableArray *)heightArray tripleArray:(NSArray *)tripleArray
{
    [self addHeight:indexPath heightArray:heightArray tripleArray:tripleArray isTripleData:YES];
}
+ (void)addHeight:(NSIndexPath *)indexPath heightArray:(NSMutableArray *)heightArray tripleArray:(NSArray *)tripleArray isTripleData:(BOOL)isTripleData
{   NSArray *array;
    NSString *layout;
    if (isTripleData)
    {
        NSDictionary *dicta = tripleArray[indexPath.section];
        layout = dicta[@"layout"];
        array = dicta[@"content"];
    }
    else
    {
        array = tripleArray;
    }
    NSMutableArray *secArray;
    CGFloat height = 0.0;
    if (heightArray.count > indexPath.section)
    {
        secArray = heightArray[indexPath.section];
    }
    else
    {
        secArray = [NSMutableArray array];
        [heightArray addObject:secArray];
    }
    NSDictionary *dict = array[indexPath.row];
    NSString *title;
    NSString *subTitle;
    if (isTripleData)
    {
        title = dict[@"subtitle1"][@"text"];
        subTitle = dict[@"title"][@"text"];
    }
    else
    {
        title = dict[@"name"];
        subTitle = dict[@"description"];
    }
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14]];
    if (!layout)
    {
        layout = Layout_Normal;
    }
    ItemParameter para = [CNManager getItemSize:layout];
    CGFloat titleW = para.imgW;
    if ([layout isEqualToString:Layout_Big_Video] || [layout isEqualToString:Layout_Big_Other])//大图比2：1
    {
        titleW = titleW - 20;
    }
    if (titleSize.width > titleW)
    {
        height = height + titleSize.height;
    }
    CGSize subTitleSize = [subTitle sizeWithFont:[UIFont systemFontOfSize:11]];
    if (subTitleSize.width > titleW)
    {
        height = height + subTitleSize.height;
    }
    
    if ([layout isEqualToString:Layout_Big_Video] || [layout isEqualToString:Layout_Big_Other])
    {
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
    else if ([layout isEqualToString:Layout_Two_unTitle1] || [layout isEqualToString:Layout_Two_unTitle2] || [layout isEqualToString:Layout_Two_unTitle3])
    {
        height = -40;
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
    else if ([layout isEqualToString:Layout_Word] || [layout isEqualToString:Layout_Twoline])
    {
        height = -4;
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
    else if ([layout isEqualToString:Layout_Two])
    {
        if (indexPath.row % 2 == 0)
        {
            if (array.count > indexPath.row + 1)
            {
                NSDictionary *dict = array[indexPath.row + 1];
                NSString *title = dict[@"subtitle1"][@"text"];
                NSString *subTitle = dict[@"title"][@"text"];
                CGFloat tempH = 0;
                CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14]];
                if (titleSize.width > para.imgW)
                {
                    tempH = tempH + titleSize.height;
                }
                CGSize subTitleSize = [subTitle sizeWithFont:[UIFont systemFontOfSize:11]];
                if (subTitleSize.width > para.imgW)
                {
                    tempH = tempH + subTitleSize.height;
                }
                height = tempH > height ? tempH : height;
            }
        }
        [secArray addObject:[NSNumber numberWithFloat:height]];
        
    }
    else if ([layout isEqualToString:Layout_Three_Video] || [layout isEqualToString:Layout_Three_Other] || [layout isEqualToString:Layout_Three_Other2])
    {
        if (indexPath.row % 3 == 0)
        {
            if (array.count > indexPath.row + 1)
            {
                NSDictionary *dict = array[indexPath.row + 1];
                NSString *title = dict[@"subtitle1"][@"text"];
                NSString *subTitle = dict[@"title"][@"text"];
                CGFloat tempH = 0;
                CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14]];
                if (titleSize.width > para.imgW)
                {
                    tempH = tempH + titleSize.height;
                }
                CGSize subTitleSize = [subTitle sizeWithFont:[UIFont systemFontOfSize:11]];
                if (subTitleSize.width > para.imgW)
                {
                    tempH = tempH + subTitleSize.height;
                }
                height = tempH > height ? tempH : height;
            }
            if (array.count > indexPath.row + 2)
            {
                NSDictionary *dict = array[indexPath.row + 2];
                NSString *title = dict[@"subtitle1"][@"text"];
                NSString *subTitle = dict[@"title"][@"text"];
                CGFloat tempH = 0;
                CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14]];
                if (titleSize.width > para.imgW)
                {
                    tempH = tempH + titleSize.height;
                }
                CGSize subTitleSize = [subTitle sizeWithFont:[UIFont systemFontOfSize:11]];
                if (subTitleSize.width > para.imgW)
                {
                    tempH = tempH + subTitleSize.height;
                }
                height = tempH > height ? tempH : height;
            }
        }
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
    else if ([layout isEqualToString:Layout_Image_title])
    {
        height = -40;
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
    else
    {
        [secArray addObject:[NSNumber numberWithFloat:height]];
    }
}


+ (BOOL)testCollectionVideo:(NSString *)videoID{
    return (BOOL)[[CNManager loadByKey:VIDEOCOLLECTION] objectForKey:videoID];
}

+ (BOOL)testCollectionRadio:(NSString *)RadioID{
    return (BOOL)[[CNManager loadByKey:RADIOCOLLECTION] objectForKey:RadioID];
}

+ (BOOL)testCollectionMusic:(NSString *)MusicID{
    return (BOOL)[[CNManager loadByKey:MUSICCOLLECTION] objectForKey:MusicID];
}



+ (UIInterfaceOrientationMask)interfaceOrientationMask {
    
    if (isHengPing) {
        //return [[UIApplication sharedApplication] statusBarOrientation];
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
+ (BOOL)isHengPing
{
    return isHengPing;
}
+ (void)isHengPing:(BOOL)hengPing
{
    isHengPing = hengPing;
}

+ (BOOL)isMobile:(NSString *)phoneNum
{
    NSString * CM = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    return [phoneTest evaluateWithObject:phoneNum];
}

+ (UIViewController *)getCurrentVC
{
    return nil;
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    BaseTabBarViewController * tmpYR = (BaseTabBarViewController *)delegate.window.rootViewController;
//    BaseNavigationController * nc = (BaseNavigationController *)tmpYR.selectedViewController;
//    return [nc.viewControllers lastObject];
}

+ (BOOL)isIta{
    return [[CNManager shareInstance].nowLG isEqualToString:@"1"];
}

+ (BOOL)isCN{
    return [[CNManager shareInstance].nowLG isEqualToString:@"2"];
}

+ (BOOL)showLogin{
    return [[CNManager loadByKey:@"SHOWDONWLOAD"]boolValue];
}

+ (BOOL)isLogin{
    return  [[CNManager loadByKey:@"AppLoginOK"] boolValue];
}

+ (void)CIGetCollectedArray{
    [[CNManager shareInstance] loadCollectData];
//    return [CNManager shareInstance].collectArray;
}

+ (BOOL)hasCollect:(NSString *)rid{
    if ([CNManager shareInstance].collectArray.count) {
        for (NSDictionary * dic in [CNManager shareInstance].collectArray) {
            if ([[NSString stringWithFormat:@"%@",dic[@"id"]] isEqualToString:rid]) {
                return YES;
                break;
            }
        }
    }
    return NO;
}

+ (void)delCollect:(NSString *)aid{
    if ([CNManager shareInstance].collectArray.count) {
        NSArray * tmp = [[CNManager shareInstance].collectArray copy];
        for (NSDictionary * dic in tmp) {
            if ([[NSString stringWithFormat:@"%@",dic[@"id"]] isEqualToString:aid]) {
                NSString * rid = [dic[@"RID"] copy];
//                [[CNManager shareInstance] collectionUpdate:[NSString stringWithFormat:@"%@",rid]];
                [[CNManager shareInstance].collectArray removeObject:dic];
                break;
            }
        }
    }
}

- (void)loadCollectData {
    if (![CNManager isLogin]) {
        [_collectArray removeAllObjects];
        return;
    }
    if (!_collectArray) {
        [CNManager shareInstance].collectArray = [[NSMutableArray alloc]init];
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:@"article" forKey:@"rtp"];
    
    [dataDict setObject:[SettingsManager sharedSettingsManager].username forKey:@"un"];
    NSString *dataString = [NewSettingsManager getUrlStringWithParam:nil prarm:dataDict];
    NSString *dataStringEncoded = [dataString URLEncodedString];
    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/ServiceCenter.do",
                           [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"action": @"getSavList",
                                 @"pv": @"3",
                                 @"format": @"json",
                                 @"verf": [dataStringEncoded md5],
                                 @"data": [NewSettingsManager encodeBase64:dataStringEncoded]};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSLog(@"%@",responseObject);
            NSString *msgString = [responseObject objectForKey:@"msg"];
            NSString *errcodeString = [responseObject objectForKey:@"errcode"];
            if ([errcodeString isEqualToString:@"100000"] && [msgString isEqualToString:@"Success"]) {
                _hasGetCollect = YES;
                NSArray * arr = responseObject[@"result"];
                if (arr.count) {
                    [_collectArray removeAllObjects];
                    [_collectArray addObjectsFromArray:arr];
//                    for (int i = 0; i < arr.count; i++) {
//                        [_collectArray insertObject:arr[i] atIndex:0];
//                    }
//
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        ;
    }];
    
}
+ (NSString *)getShowNum:(double)x{
    NSString * str = nil;
    if (x<10000) {
        str = [NSString stringWithFormat:@"%.0f",x];
        if ([str isEqualToString:@"10000"])
        {
            str = @"1.0万";
        }
    }else if (x<100000000){
        str = [NSString stringWithFormat:@"%.1f万",x/10000.f];
        if ([str isEqualToString:@"10000.0万"])
        {
            str = @"1.0亿";
        }
    }else{
        str = [NSString stringWithFormat:@"%.1f亿",x/100000000.f];
    }
    return str;
}
+(void)delFile:(NSURL *)url{
    NSString * FileFullPath = [url absoluteString];
    FileFullPath = [[FileFullPath componentsSeparatedByString:@"file:///private"] lastObject];
    NSFileManager * fileMgr =[NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:FileFullPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:FileFullPath error:&err];
    }
}
//- (void)collectionUpdate: (NSString *)rid{
//    if (![CNManager isLogin]) {
//        LoginView *loginView = [LoginView loadLoginView];
//        [loginView showLoginView];
//        return;
//    }
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
//    NSDictionary * tmp = @{@"act":@"delete",@"id":rid};
//    NSArray * tmp1 = @[tmp];
//    SBJson4Writer *jsonWriter = [[SBJson4Writer alloc] init];
//    NSString * jsonString = [jsonWriter stringWithObject:tmp1];
//    [dataDict setObject:jsonString forKey:@"pfs"];
//    
//    [dataDict setObject:[SettingsManager sharedSettingsManager].username forKey:@"un"];
//    NSString *dataString = [NewSettingsManager getUrlStringWithParam:nil prarm:dataDict];
//    NSString *dataStringEncoded = [dataString URLEncodedString];
//    NSString *URLString = [NSString stringWithFormat:@"http://%@/api/ServiceCenter.do",
//                           [NewSettingsManager applicationServerURL]];
//    NSDictionary *parameters = @{@"action": @"userPreference",
//                                 @"pv": @"3",
//                                 @"format": @"json",
//                                 @"verf": [dataStringEncoded md5],
//                                 @"data": [NewSettingsManager encodeBase64:dataStringEncoded]};
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        ;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]){
//            NSLog(@"%@",responseObject);
//            NSString *msgString = [responseObject objectForKey:@"msg"];
//            NSString *errcodeString = [responseObject objectForKey:@"errcode"];
//            if ([errcodeString isEqualToString:@"100000"] && [msgString isEqualToString:@"Success"]) {
//                [CNManager showWindowAlert:[CNManager loadLanguage:@"取消收藏成功"]];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"network error");
//    }];
//}

+ (void)getConf{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
//    [dataDict setObject:phone forKey:@"phone"];
    //    [dataDict setObject:_password.text forKey:@"password"];
    //    [dataDict setObject:_name.text forKey:@"nick_name"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/conf/getConf",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
//                    NSDictionary * userdic = dic[@"memberInfo"];
                    [CNManager saveObject:[NSString stringWithFormat:@"%@",dic[@"help_url"]] byKey:HELPPAGE];
                    [CNManager saveObject:[NSString stringWithFormat:@"%@",dic[@"risk_url"]] byKey:REGHELPPAGE];
                    [CNManager saveObject:[NSString stringWithFormat:@"%@",dic[@"phone"]] byKey:HOTPHONE];
                    
                    //还差协议和风险提示
                    
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        NSLog(@"error slider");
    }];
}


+ (void)downLoadOPI:(NSDictionary *)dic{
    NSString *urlString = dic[@"value"];
    urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,   (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",              NULL, kCFStringEncodingUTF8));
    NSString * fileString = [[urlString componentsSeparatedByString:@"/"] lastObject];
    
    if ([[CNManager loadByKey:fileString]boolValue]) {
        return;
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //    WEAKSELF
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:OPENPICARRAYI];
        //        [[NSFileManager defaultManager] removeItemAtPath:documentDir error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
        return [NSURL fileURLWithPath:[documentDir stringByAppendingPathComponent:fileString]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error == nil) {
            //保存dic到数组
            //            NSLog(@"%@",filePath);
            [CNManager saveObject:@"1" byKey:fileString];
        }
    }];
    [downloadTask resume];
}

+ (void)downLoadOP:(NSDictionary *)dic{
    NSString *urlString = dic[@"value"];
    urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,   (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",              NULL, kCFStringEncodingUTF8));
    NSString * fileString = [[urlString componentsSeparatedByString:@"/"] lastObject];
    
    if ([[CNManager loadByKey:fileString]boolValue]) {
        return;
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //    WEAKSELF
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:OPENPICARRAY];
        //        [[NSFileManager defaultManager] removeItemAtPath:documentDir error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
        return [NSURL fileURLWithPath:[documentDir stringByAppendingPathComponent:fileString]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error == nil) {
            //保存dic到数组
            //            NSLog(@"%@",filePath);
            [CNManager saveObject:@"1" byKey:fileString];
        }
    }];
    [downloadTask resume];
}


+ (void)downloadFile:(NSString *)urlString :(NSString *)fileString :(NSString *)imgVer{
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    WEAKSELF
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:imgVer];
        [[NSFileManager defaultManager] removeItemAtPath:documentDir error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
        return [NSURL fileURLWithPath:[documentDir stringByAppendingPathComponent:fileString]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error == nil) {
//            [weakself showPDF:filePath];
            [CNManager saveObject:urlString byKey:imgVer];
        }else{
            NSLog(@"saveError :%@",error);
        }
    }];
    [downloadTask resume];
}
+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

/**
 收到消息的时间距离当前时间小于10分钟：显示刚刚
 收到消息的时间距离当前时间大于10分钟小于1小时：显示xx分钟前
 收到消息的时间距离当前时间大于1小时小于24小时：显示xx小时前
 收到消息的时间距离当前时间大于24小时：显示xx月xx日 xx：xx
 */
+(NSString *)setShowMessageTime:(NSString *)timeStr{
    
    if (!timeStr || timeStr.length == 0)
    {
        return @"";
    }
    double time = [self getTimeStamp:timeStr];
    double datetime = [[NSDate date] timeIntervalSince1970];
    double x = datetime - time/1000;
    if (x<=60*10) {
        return @"刚刚";
    }else if (x<60*60){
        return [NSString stringWithFormat:@"%ld分钟前",(NSInteger)x/60];
    }else if (x<60*60*24){
        return  [NSString stringWithFormat:@"%ld小时前",(NSInteger)x/60/60];
    }else{
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //        [formatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
        
        //        [formatter setDateFormat:@"MM-dd"];
        //        [formatter setDateFormat:@"yyyy"];
        //        NSInteger currentYear=[[formatter stringFromDate:confromTimesp] integerValue];
        [formatter setDateFormat:@"YYYY"];
        NSInteger currentyear=[[formatter stringFromDate:confromTimesp]integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:confromTimesp]integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:confromTimesp] integerValue];
        [formatter setDateFormat:@"HH"];
        NSInteger currentH=[[formatter stringFromDate:confromTimesp] integerValue];
        [formatter setDateFormat:@"mm"];
        NSInteger currentM=[[formatter stringFromDate:confromTimesp] integerValue];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", currentyear,(long)currentMonth,currentDay];
        
        return dateStr;
    }
}
+ (NSArray *)getArrayFromFile:(NSString *)fileName {
    NSArray *array = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if ([fm fileExistsAtPath:fileName isDirectory:&isDir]) {
        array = [[NSArray alloc] initWithContentsOfFile:fileName];
    }
    return array;
}

+ (id)CNtoArrayOrNSDictionary:(NSString *)jsonString{
    
    NSError *error = nil;
    NSData *jsonData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

+ (BOOL)hasRealName{
    return [CNManager loadByKey:REALCODE];
}

+ (BOOL)hasBankCard{
    
    return [CNManager loadByKey:BANKCARD];
}

+ (BOOL)hasMoneyCode{
    return [CNManager loadByKey:MONEYCODE];
}
//+(UIImage*)scaleToFillSize:(CGSize)newSize image:(UIImage *)image
//{
//    size_t destWidth = (size_t)(newSize.width * image.scale);
//    size_t destHeight = (size_t)(newSize.height * image.scale);
//    if (image.imageOrientation == UIImageOrientationLeft
//        || image.imageOrientation == UIImageOrientationLeftMirrored
//        || image.imageOrientation == UIImageOrientationRight
//        || image.imageOrientation == UIImageOrientationRightMirrored)
//    {
//        size_t temp = destWidth;
//        destWidth = destHeight;
//        destHeight = temp;
//    }
//
//    /// Create an ARGB bitmap context
//    CGContextRef NYXCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow, BOOL withAlpha);
//    CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * 4, NYXImageHasAlpha(image.CGImage));
//    if (!bmContext)
//        return nil;
//
//    /// Image quality
//    CGContextSetShouldAntialias(bmContext, true);
//    CGContextSetAllowsAntialiasing(bmContext, true);
//    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
//
//    /// Draw the image in the bitmap context
//
//    UIGraphicsPushContext(bmContext);
//    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), image.CGImage);
//    UIGraphicsPopContext();
//
//    /// Create an image object from the context
//    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
//    UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:image.scale orientation:image.imageOrientation];
//
//    /// Cleanup
//    CGImageRelease(scaledImageRef);
//    CGContextRelease(bmContext);
//
//    return scaled;
//}

+ (NSString *)resetFormat:(NSString *)str digit:(NSInteger)i{
    return [NSString stringWithFormat:@"%.2f",[str floatValue]];
}

+ (NSString *)resetFormatWithPlus:(NSString *)str digit:(NSInteger)i{
    if ([str floatValue]>=0) {
        return [NSString stringWithFormat:@"+%@",[CNManager resetFormat:str digit:i]];
    }
    return [CNManager resetFormat:str digit:i];
}

+ (AFSecurityPolicy *)createSecurity{
    
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
    return securityPolicy;
}

//+ (AFSecurityPolicy *)createSecurity{
//
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // 是否允许,NO-- 不允许无效的证书
//    [securityPolicy setAllowInvalidCertificates:YES];
//    [securityPolicy setValidatesDomainName:NO];
//    // 设置证书
//    [securityPolicy setPinnedCertificates:certSet];
//    return securityPolicy;
//}
+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    [mutStr replaceOccurrencesOfString:@"" withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)getRadomString{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString *ramdom;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<24 ; i ++) {
            int a = (arc4random() % 26) + 65;
            int b = (arc4random() % 26) + 97;
            int c = (arc4random() % 10) + 48;
            int d = arc4random() % 3;
            char n = (char)(d?(d==1?b:c):a);
            [array addObject:[NSString stringWithFormat:@"%c",n]];
        }
        ramdom = [array componentsJoinedByString:@""];
    });
    
    //这个是把数组转换为字符串
    return ramdom;
}

@end
