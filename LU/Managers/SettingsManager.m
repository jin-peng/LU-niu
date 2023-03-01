//
//  SettingsManager.m
//  AnyRadio
//
//  Created by Bruce Yee on 6/11/14.
//  Copyright (c) 2014 AnyRadio.CN. All rights reserved.
//

#import "SettingsManager.h"
#import "SynthesizeSingleton.h"
//#import "ARLocationUtils.h"
#import "ARCommUtils.h"
#import "OpenUDID.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSString *SETTING_MAIN_SERVER_URL = @"SETTING_MAIN_SERVER_URL";
static NSString *SETTING_APPLICATION_SERVER_URL = @"SETTING_APPLICATION_SERVER_URL";
static NSString *SETTING_LONGITUDE = @"SETTING_LONGITUDE";
static NSString *SETTING_LATITUDE = @"SETTING_LATITUDE";
static NSString *SETTING_LOCATION_NAME = @"SETTING_LOCATION_NAME";
static NSString *SETTING_COUNTRY_NAME = @"SETTING_COUNTRY_NAME";
static NSString *SETTING_STATE_NAME = @"SETTING_STATE_NAME";
static NSString *SETTING_CITY_NAME = @"SETTING_CITY_NAME";

static NSString *SETTING_USERNAME = @"SETTING_USERNAME";
static NSString *SETTING_PASSWORD = @"SETTING_PASSWORD";
static NSString *SETTING_EMAIL = @"SETTING_EMAIL";
static NSString *SETTING_UUID = @"SETTING_UUID";
static NSString *SETTING_SYS_ID = @"SETTING_SYS_ID";
static NSString *SETTING_CHANNEL_ID = @"SETTING_CHANNEL_ID";
static NSString *SETTING_CHANNEL_ID2 = @"SETTING_CHANNEL_ID2";
static NSString *SETTING_VERSION = @"SETTING_VERSION";
static NSString *SETTING_SMSCID = @"SETTING_SMSCID";

static NSString *SETTING_NETWORK_REMIND = @"SETTING_NETWORK_REMIND";
static NSString *SETTING_AUTO_CHECK_UPDATE = @"SETTING_AUTO_CHECK_UPDATE";
static NSString *SETTING_CLOSE_PUSH = @"SETTING_CLOSE_PUSH";
static NSString *SETTING_BUFF_TIME = @"SETTING_BUFF_TIME";
static NSString *SETTING_INTRO_VERSION = @"SETTING_INTRO_VERSION";
static NSString *SETTING_PLAY_MODE = @"SETTING_PLAY_MODE";
static NSString *SETTINT_SOFT_VERSION = @"SETTINT_SOFT_VERSION";

static NSString *RELOAD_RECOMMEND_VIEW = @"RELOAD_RECOMMEND_VIEW";
static NSString *CAN_START_DOWNLOAD = @"CAN_START_DOWNLOAD";
static NSString *SETTING_PUSH_TOKEN = @"SETTING_PUSH_TOKEN";
static NSString *LAST_UPDATE_PUSH_TOKEN_DATE = @"LAST_UPDATE_PUSH_TOKEN_DATE";
static NSString *LOCATION_LAST_UPDATE = @"LOCATION_LAST_UPDATE";

static NSString *SETTING_AUTO_UPDATE_WIFI = @"SETTING_AUTO_UPDATE_WIFI";
static NSString *SETTING_AUTO_UPDATE_CELLPHONE = @"SETTING_AUTO_UPDATE_CELLPHONE";
static NSString *SETTING_FRIST_SET_AUTO_UPDATE = @"SETTING_FRIST_SET_AUTO_UPDATE";

static NSString *MY_COMMUNITY_URL = @"MY_COMMUNITY_URL";
static NSString *COMMUNITY_DETAIL_URL = @"COMMUNITY_DETAIL_URL";
static NSString *COMMUNITY_POST_DETAIL_URL = @"COMMUNITY_POST_DETAIL_URL";
static NSString *COMMUNITY_APPLY_URL = @"COMMUNITY_APPLY_URL";

static NSString *VOTE_APPLY_URL = @"VOTE_APPLY_URL";
static NSString *SHAKE_APPLY_URL = @"SHAKE_APPLY_URL";
static NSString *MYACTIV_APPLY_URL = @"MYACTIV_APPLY_URL";
static NSString *RADIO_SHARE_URL = @"RADIO_SHARE_URL";

static NSString *APP_IS_SHOW_DOWNLOAD = @"APP_IS_SHOW_DOWNLOAD";

static NSString *APP_FIND_V_TOPTYPE = @"APP_FIND_V_TOPTYPE";
static NSString *CHAT_ROOM_ON_OFF = @"CHAT_ROOM_ON_OFF";

@interface SettingsManager ()

@property (nonatomic, retain) NSUserDefaults *userDefaults;

@end


@implementation SettingsManager

SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsManager)

@synthesize userDefaults = _userDefaults;

- (id)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        [self.userDefaults setObject:[self getUUIDString] forKey:SETTING_UUID];
        
        // 安装包初始渠道号信息设置，默认打包进去，可以通过秘笈修改，并且在版本号发送变化的情况下，初始化，防止升级用户渠道信息不变的问题
        NSString *s = @"8094"; // 系统号
        NSString *v = @"7022"; // 版本号
        NSString *c = @"6010"; // 渠道号
        NSString *c2 = @"5900"; // 渠道号2
        
        NSString *oldVersion = [self.userDefaults stringForKey:SETTINT_SOFT_VERSION];
        NSString *curVersion = [self getSyvn];
        if (oldVersion && [oldVersion isEqualToString:curVersion]) {
            // 如果是版本号不变，直接使用上次保存的渠道号(渠道号变化也需要更新)
            if (![self sysID] || ![[self sysID] isEqualToString:s])
                [self.userDefaults setObject:s forKey:SETTING_SYS_ID];
            if (![self version] || ![[self version] isEqualToString:v])
                [self.userDefaults setObject:v forKey:SETTING_VERSION];
            if (![self channelID] || ![[self channelID] isEqualToString:c])
                [self.userDefaults setObject:c forKey:SETTING_CHANNEL_ID];
            if (![self channelID2] || ![[self channelID2] isEqualToString:c2])
                [self.userDefaults setObject:c2 forKey:SETTING_CHANNEL_ID2];
        } else {
            // 如果是版本不一样，需要重新设置渠道号
            [self.userDefaults setObject:s forKey:SETTING_SYS_ID];
            [self.userDefaults setObject:v forKey:SETTING_VERSION];
            [self.userDefaults setObject:c forKey:SETTING_CHANNEL_ID];
            [self.userDefaults setObject:c2 forKey:SETTING_CHANNEL_ID2];
            [self.userDefaults setObject:curVersion forKey:SETTINT_SOFT_VERSION];
        }
        
        [self.userDefaults synchronize];
    }
    
    return self;
}

- (void)dealloc
{
    self.userDefaults = nil;
}

- (void)clearUserInformation {
    [self.userDefaults removeObjectForKey:SETTING_USERNAME];
    [self.userDefaults removeObjectForKey:SETTING_PASSWORD];
    [self.userDefaults removeObjectForKey:SETTING_EMAIL];
    [self.userDefaults removeObjectForKey:@"AppUserInfo"];
    [self.userDefaults synchronize];
}

-(void)setProductID:(NSString*)proID{
    NSString *s = [proID substringWithRange:NSMakeRange(0, 4)];
    [self.userDefaults setObject:s forKey:SETTING_SYS_ID];
    s = [proID substringWithRange:NSMakeRange(4, 4)];
    [self.userDefaults setObject:s forKey:SETTING_VERSION];
    s = [proID substringWithRange:NSMakeRange(8, 4)];
    [self.userDefaults setObject:s forKey:SETTING_CHANNEL_ID];
    s = [proID substringWithRange:NSMakeRange(12, 4)];
    [self.userDefaults setObject:s forKey:SETTING_CHANNEL_ID2];
}

#pragma mark -
#pragma mark Public methods

- (NSString *)getUUIDString
{
    NSString *uuid = [self.userDefaults stringForKey:SETTING_UUID];
    if (uuid) {
        return uuid;
    }else{
        CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
        CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
        CFRelease(uuid_ref);
        NSString *uuidString = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        CFRelease(uuid_string_ref);
        return uuidString;
    }
}

- (NSString *)username
{
    return [self.userDefaults stringForKey:SETTING_USERNAME];
}

- (NSString *)password{
    return [self.userDefaults stringForKey:SETTING_PASSWORD];
}

- (NSString *)email
{
    return [self.userDefaults stringForKey:SETTING_EMAIL];
}

- (NSString *)uuid
{
    return [self.userDefaults stringForKey:SETTING_UUID];
}

- (NSString *)sysID
{
    return [self.userDefaults stringForKey:SETTING_SYS_ID];
}

- (NSString *)channelID
{
    return [self.userDefaults stringForKey:SETTING_CHANNEL_ID];
}
- (NSString *)channelID2
{
    return [self.userDefaults stringForKey:SETTING_CHANNEL_ID2];
}
- (NSString *)version
{
    return [self.userDefaults stringForKey:SETTING_VERSION];
}

- (NSString *)smscid
{
    return [self.userDefaults stringForKey:SETTING_SMSCID];
}

- (void)setSmscid:(NSString *)val
{
    [self.userDefaults setObject:val forKey:SETTING_SMSCID];
    [self.userDefaults synchronize];
}

- (NSString *)mainServerURL
{
    return [self.userDefaults stringForKey:SETTING_MAIN_SERVER_URL];
}
- (NSString *)openUDID
{
    
    return [OpenUDID value];
}
- (NSString *)versionCode
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *buildString = [infoDictionary objectForKey:@"CFBundleVersion"];
    return buildString;
}
- (void)setMainServerURL:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_MAIN_SERVER_URL];
    [self.userDefaults synchronize];
}

- (NSString *)applicationServerURL
{
    return @"223.87.178.115";
//    return @"223.87.178.9:31080";
    NSString *ip = [self.userDefaults stringForKey:SETTING_APPLICATION_SERVER_URL];
    //    DLog(@"ip:%@", ip);
//    BOOL isIp = [ARCommUtils checkIsValidIp:ip];
    if(ip.length)
        return ip;
//    return @"mapi.china-plus.net";
    return @"master1.china-plus.net:31080";
    
}

- (NSString *)myCommunityUrl{
    return [self.userDefaults stringForKey:MY_COMMUNITY_URL];
}

- (NSString *)communityUrl{
    return [self.userDefaults stringForKey:COMMUNITY_DETAIL_URL];
}

- (NSString *)communityPostUrl{
    return [self.userDefaults stringForKey:COMMUNITY_POST_DETAIL_URL];
}

- (NSString *)communityApplyUrl{
    return [self.userDefaults stringForKey:COMMUNITY_APPLY_URL];
}

- (BOOL)isShowDownload{
    return [self.userDefaults boolForKey:APP_IS_SHOW_DOWNLOAD];
}

//投票
-(void)setVoteApplyUrl:(NSString*)value{
    [self.userDefaults setObject:value forKey:VOTE_APPLY_URL];
    [self.userDefaults synchronize];
}

- (NSString *)voteApplyUrl{
    return [self.userDefaults stringForKey:VOTE_APPLY_URL];
}
//摇奖
-(void)setShakeApplyUrl:(NSString*)value{
    [self.userDefaults setObject:value forKey:SHAKE_APPLY_URL];
    [self.userDefaults synchronize];
}

-(void)setMyactivApplyUrl:(NSString*)value{
    [self.userDefaults setObject:value forKey:MYACTIV_APPLY_URL];
    [self.userDefaults synchronize];
}

-(NSString*)myactivApplyUrl{
    return [self.userDefaults stringForKey:MYACTIV_APPLY_URL];
}

-(NSString *)shakeApplyUrl{
    return [self.userDefaults stringForKey:SHAKE_APPLY_URL];
}

-(NSString*)radioShareUrl{
    return [self.userDefaults stringForKey:RADIO_SHARE_URL];
}

-(void)setRadioShareUrl:(NSString*)value{
    [self.userDefaults setObject:value forKey:RADIO_SHARE_URL];
    [self.userDefaults synchronize];
}

- (NSArray*)getFindViewTopType{

    return [NSArray arrayWithArray:[self.userDefaults objectForKey:APP_FIND_V_TOPTYPE]];
}

- (NSString *)pushToken{
    return [self.userDefaults stringForKey:SETTING_PUSH_TOKEN];
}

- (void)setPushToken:(NSString *)value{
    [self.userDefaults setObject:value forKey:SETTING_PUSH_TOKEN];
    [self.userDefaults synchronize];
}

- (NSDate *)lastUpdatePushTokenDate{
    return [self.userDefaults objectForKey:LAST_UPDATE_PUSH_TOKEN_DATE];
}

- (void)setLastUpdatePushTokenDate:(NSDate *)value{
    [self.userDefaults setObject:value forKey:LAST_UPDATE_PUSH_TOKEN_DATE];
    [self.userDefaults synchronize];
}

- (BOOL)closePush{
    return [self.userDefaults boolForKey:SETTING_CLOSE_PUSH];
}

- (void)setClosePush:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_CLOSE_PUSH];
    [self.userDefaults synchronize];
}

- (NSDate *)lastUpdateLocation{
    return [self.userDefaults objectForKey:LOCATION_LAST_UPDATE];
}

- (void)setLastUpdateLocation:(NSDate *)value{
    [self.userDefaults setObject:value forKey:LOCATION_LAST_UPDATE];
    [self.userDefaults synchronize];
}

- (void)setApplicationServerURL:(NSString *)value
{
    BOOL isIp = [ARCommUtils checkIsValidIp:value];
    if(isIp) {
        [self.userDefaults setObject:value forKey:SETTING_APPLICATION_SERVER_URL];
        [self.userDefaults synchronize];
    }
}

- (NSString *)latitude
{
    return [self.userDefaults stringForKey:SETTING_LATITUDE];
}

- (void)setLatitude:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_LATITUDE];
    [self.userDefaults synchronize];
}

- (NSString *)longitude
{
    return [self.userDefaults stringForKey:SETTING_LONGITUDE];
}

- (BOOL)autoUpdateWifi{
    return [self.userDefaults boolForKey:SETTING_AUTO_UPDATE_WIFI];
}

- (BOOL)autoUpdateCellphone{
    return [self.userDefaults boolForKey:SETTING_AUTO_UPDATE_CELLPHONE];
}

- (BOOL)isFirstSetAutoUpdate{
    return [self.userDefaults boolForKey:SETTING_FRIST_SET_AUTO_UPDATE];
}

- (void)setLongitude:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_LONGITUDE];
    [self.userDefaults synchronize];
}

- (NSString *)locationName{
    return [self.userDefaults stringForKey:SETTING_LOCATION_NAME];
}

- (void)setLocationName:(NSString *)value{
    [self.userDefaults setObject:value forKey:SETTING_LOCATION_NAME];
    [self.userDefaults synchronize];
}
- (NSString *)countryName{
    return [self.userDefaults stringForKey:SETTING_COUNTRY_NAME];
}

- (void)setCountryName:(NSString *)value{
    [self.userDefaults setObject:value forKey:SETTING_COUNTRY_NAME];
    [self.userDefaults synchronize];
}

- (NSString *)stateName{
    return [self.userDefaults stringForKey:SETTING_STATE_NAME];
}

- (NSString *)cityName{
    return [self.userDefaults stringForKey:SETTING_CITY_NAME];
}

- (void)setStateName:(NSString *)value{
    [self.userDefaults setObject:value forKey:SETTING_STATE_NAME];
    [self.userDefaults synchronize];
}

- (void)setCityName:(NSString *)value{
    [self.userDefaults setObject:value forKey:SETTING_CITY_NAME];
    [self.userDefaults synchronize];
}

- (NSString *)getSyvn {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)getBuildNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (void)setUsername:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_USERNAME];
    [self.userDefaults synchronize];
}

- (void)setPassword:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_PASSWORD];
    [self.userDefaults synchronize];
}

- (void)setEmail:(NSString *)value
{
    [self.userDefaults setObject:value forKey:SETTING_EMAIL];
    [self.userDefaults synchronize];
}

- (BOOL)netWorkRemind{
    return [self.userDefaults boolForKey:SETTING_NETWORK_REMIND];
}

- (BOOL)autoCheckUpdate{
    return [self.userDefaults boolForKey:SETTING_AUTO_CHECK_UPDATE];
}

- (NSInteger)buffTime{
    return [self.userDefaults integerForKey:SETTING_BUFF_TIME];
}

- (NSInteger)playMode{
    return [self.userDefaults integerForKey:SETTING_PLAY_MODE];
}

- (NSString *)introVersion{
    return [self.userDefaults stringForKey:SETTING_INTRO_VERSION];
}

- (BOOL)reloadRecommendView{
    return [self.userDefaults boolForKey:RELOAD_RECOMMEND_VIEW];
}

- (BOOL)endDownload{
    return [self.userDefaults boolForKey:CAN_START_DOWNLOAD];
}

- (void)setEndDownload:(BOOL)value{
    [self.userDefaults setBool:value forKey:CAN_START_DOWNLOAD];
    [self.userDefaults synchronize];
}

- (void)setNetWorkRemind:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_NETWORK_REMIND];
    [self.userDefaults synchronize];
}

- (void)setAutoCheckRemind:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_AUTO_CHECK_UPDATE];
    [self.userDefaults synchronize];
}

- (void)setBuffTime:(NSInteger)value{
    [self.userDefaults setInteger:value forKey:SETTING_BUFF_TIME];
    [self.userDefaults synchronize];
//    [[PlayManager getInstance] setLimtTime:value];
}

- (void)setIntroVersion:(NSString *)value{
    [self.userDefaults setValue:value forKey:SETTING_INTRO_VERSION];
    [self.userDefaults synchronize];
}

- (void)setReloadRecommendView:(BOOL)value{
    [self.userDefaults setBool:value forKey:RELOAD_RECOMMEND_VIEW];
    [self.userDefaults synchronize];
}

- (void)setPlayMode:(NSInteger)value{
    [self.userDefaults setInteger:value forKey:SETTING_PLAY_MODE];
    [self.userDefaults synchronize];
}

- (void)setAutoUpdateWifi:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_AUTO_UPDATE_WIFI];
    [self.userDefaults synchronize];
}

- (void)setAutoUpdateCellphone:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_AUTO_UPDATE_CELLPHONE];
    [self.userDefaults synchronize];
}

- (void)setIsFirstSetAutoUpdate:(BOOL)value{
    [self.userDefaults setBool:value forKey:SETTING_FRIST_SET_AUTO_UPDATE];
    [self.userDefaults synchronize];
}

- (void)setMyCommunityUrl:(NSString *)value{
    [self.userDefaults setObject:value forKey:MY_COMMUNITY_URL];
    [self.userDefaults synchronize];
}

- (void)setCommunityUrl:(NSString *)value{
    [self.userDefaults setObject:value forKey:COMMUNITY_DETAIL_URL];
    [self.userDefaults synchronize];
}

- (void)setCommunityPostUrl:(NSString *)value{
    [self.userDefaults setObject:value forKey:COMMUNITY_POST_DETAIL_URL];
    [self.userDefaults synchronize];
}

- (void)setCommunityApplyUrl:(NSString *)value{
    [self.userDefaults setObject:value forKey:COMMUNITY_APPLY_URL];
    [self.userDefaults synchronize];
}

- (void)setShowDownload:(BOOL)value{
    [self.userDefaults setBool:value forKey:APP_IS_SHOW_DOWNLOAD];
    [self.userDefaults synchronize];
}

- (void)setFindViewTopTypeShow:(NSArray*)_arr{
    
    [self.userDefaults setObject:_arr forKey:APP_FIND_V_TOPTYPE];
    [self.userDefaults synchronize];
}

- (void)setAppChatRoomOnOff:(BOOL)value{
    
    [self.userDefaults setBool:value forKey:CHAT_ROOM_ON_OFF];
    [self.userDefaults synchronize];
}

- (BOOL)getAppCharRoomOnOff{
    return [self.userDefaults boolForKey:CHAT_ROOM_ON_OFF];
}

+ (NSDictionary *)getGeneralParameters {
    return [SettingsManager getGeneralParameters:NO];
}



+(NSDictionary*)getSoundBoxGeneralParameters{
    SettingsManager *sm = [SettingsManager sharedSettingsManager];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:sm.sysID?sm.sysID:@"" forKey:@"si"];
    [dictionary setObject:sm.version?sm.version:@"" forKey:@"vi"];
    [dictionary setObject:sm.channelID?sm.channelID:@"" forKey:@"ci"];
    [dictionary setObject:sm.channelID2?sm.channelID2:@"" forKey:@"ds"];
    return dictionary;
}

+ (NSString *)getLocalIP{
    if ([CNManager loadByKey:USERIP]) {
        return [CNManager loadByKey:USERIP];
    }
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (data == nil) {
        return @"0.0.0.0";
    }
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *ipStr = nil;
    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
        ipStr = ipDic[@"data"][@"ip"];
        if (![ipStr isEqualToString:@"0.0.0.0"]) {
            [CNManager saveObject:ipStr byKey:USERIP];
        }
    }
    
    return (ipStr ? ipStr : @"0.0.0.0");
}

+ (NSString *)getCurentLocalIP {
    return [CNManager loadByKey:USERIP]?:@"0.0.0.0";
}

+ (NSDictionary *)getGeneralParameters:(BOOL)isPushToken{
    
//    NSDate *lastUpdate = [self sharedSettingsManager].lastUpdateLocation;
//    NSDate *currentDate = [NSDate date];
    //每30分钟更新一次location
  /*  if ((lastUpdate != nil
         && [lastUpdate isKindOfClass:[NSDate class]]
         && [currentDate timeIntervalSinceDate:lastUpdate] > 30*60)) {
        [[self sharedSettingsManager] setLastUpdateLocation:currentDate];
        
        ARLocationUtils *locationUtils = [ARLocationUtils getInstance];
        [locationUtils startLocationService];
    }else if(lastUpdate == nil || [lastUpdate isEqual:[NSNull null]]){
        [[self sharedSettingsManager] setLastUpdateLocation:currentDate];
        
        ARLocationUtils *locationUtils = [ARLocationUtils getInstance];
        [locationUtils startLocationService];
    }*/
    
//    NSString *resolutionWidth = [NSString stringWithFormat:@"%.0f",
//                                 [[UIScreen mainScreen] bounds].size.width*[UIScreen mainScreen].scale];
//    NSString *resolutionHeight = [NSString stringWithFormat:@"%.0f", [[UIScreen mainScreen] bounds].size.height*[UIScreen mainScreen].scale];
    
    AFNetworkReachabilityStatus networkReachabilityStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSString *networking = networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable ? @"" : (networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ? @"WIFI" : @"3G");
    if (networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown) {
        networking = @"unknown";
    }else if (networkReachabilityStatus ==AFNetworkReachabilityStatusNotReachable) {
        networking = @"notreachable";
    }else if (networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN) {
        networking = @"3G";
    }else if (networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi) {
        networking = @"WIFI";
    }
    SettingsManager *sm = [SettingsManager sharedSettingsManager];
    if (sm.latitude == nil)
    {
        sm.latitude = @"";
        sm.longitude = @"";
    }
    NSString *token = @"";
    if (isPushToken) {
        token = sm.pushToken;
    }
    if (sm.countryName==nil||sm.countryName.length<=0) {
        sm.countryName = @"";
    }
    NSString * strModel  = [self getDeviceVersion];
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    NSString *currentLanguage = LG;
//    DLog( @"%@" , currentLanguage);
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//    systemVersion = [NSString stringWithFormat:@"%.1f",IOS_VERSION];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:sm.sysID?sm.sysID:@"none" forKey:@"si"];//系统号 8094
    [dictionary setObject:sm.version?sm.version:@"none" forKey:@"vi"]; //内部版本号 7016
    [dictionary setObject:sm.channelID?sm.channelID:@"none" forKey:@"ci"]; //渠道号6010
//    [dictionary setObject:sm.channelID2?sm.channelID2:@"" forKey:@"ds"];
    [dictionary setObject:[sm getSyvn]?[sm getSyvn]:@"none" forKey:@"vn"]; //外部版本号
    [dictionary setObject:[self getCurentLocalIP] forKey:@"ip"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *appLoginOK = [userDefaults objectForKey:@"AppLoginOK"];
    BOOL isLogin = NO;
    if (appLoginOK) {
        isLogin = [appLoginOK boolValue];
    } else {
        isLogin = NO;
    }
    if (isLogin) {
        [dictionary setObject:[CNManager loadByKey:USERID]?:@"" forKey:@"ui"];//用户名
//        [dictionary setObject:[sm password]?[sm password]:@"" forKey:@"up"];
        [dictionary setObject:[CNManager loadByKey:USERPHONE]?:@"none" forKey:@"ph"];//手机号
        [dictionary setObject:[CNManager loadByKey:USERNAME]?:@"none" forKey:@"un"];
    }else{
//        [dictionary setObject:@"none" forKey:@"ph"];//手机号为空表示未登录
//        [dictionary setObject:@"none1" forKey:@"ui"];
//        [dictionary setObject:@"" forKey:@"un"];
    }
    
//    if ([userDefaults objectForKey:@"loginun"] && [[userDefaults objectForKey:@"loginun"] length]>0) {
//        [dictionary setObject:[userDefaults objectForKey:@"loginun"] forKey:@"un"];//用户名
//
//        [userDefaults setObject:@"none" forKey:@"loginun"];
//        [userDefaults synchronize];
//    }
    
//    [dictionary setObject:strModel forKey:@"tm"];//操作系统
//    [dictionary setObject:sm.uuid?sm.uuid:@"" forKey:@"me"];
//    [dictionary setObject:@"" forKey:@"pn"];
//    [dictionary setObject:@"" forKey:@"ms"];
    [dictionary setObject:systemVersion forKey:@"tv"];//操作系统版本
    [dictionary setObject:networking forKey:@"nt"];//WIFI,4G 联网方式
//    [dictionary setObject:@"" forKey:@"lc"];
//    [dictionary setObject:@"" forKey:@"ce"];
//    [dictionary setObject:sm.locationName?sm.locationName:@"" forKey:@"ln"];
//    [dictionary setObject:currentLanguage forKey:@"lg"];
//    [dictionary setObject:sm.latitude?sm.latitude:@"" forKey:@"la"];
//    [dictionary setObject:sm.longitude?sm.longitude:@"" forKey:@"lo"];
//    [dictionary setObject:sm.countryName?sm.countryName:@"" forKey:@"cr"];
//    [dictionary setObject:sm.stateName?sm.stateName:@"" forKey:@"pr"];
//    [dictionary setObject:sm.cityName?sm.cityName:@"" forKey:@"ct"];
//    [dictionary setObject:@"" forKey:@"co"];
//    [dictionary setObject:@"" forKey:@"st"];
    [dictionary setObject:@"apple" forKey:@"tb"];//手机类型
//    [dictionary setObject:[NSString stringWithFormat:@"ios%@", systemVersion] forKey:@"ov"];//手机系统版本号
//    [dictionary setObject:resolutionWidth forKey:@"sw"];//屏幕宽度
//    [dictionary setObject:resolutionHeight forKey:@"sh"];//屏幕高度
//    [dictionary setObject:@"portrait" forKey:@"so"];
//    [dictionary setObject:sm.openUDID forKey:@"m2"];
    [dictionary setObject:sm.versionCode?sm.versionCode:@"0000" forKey:@"vc"];//build号
//    [dictionary setObject:sm.macaddress forKey:@"wm"];

    return dictionary;
}

-(NSString *)scmString{

    return [SettingsManager getGeneralParameters:YES][@"sd"];
}

+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *)macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
@end

