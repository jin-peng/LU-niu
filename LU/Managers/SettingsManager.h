//
//  SettingsManager.h
//  AnyRadio
//
//  Created by Bruce Yee on 6/11/14.
//  Copyright (c) 2014 AnyRadio.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+ (SettingsManager *)sharedSettingsManager;

- (NSString *)getUUIDString;
- (NSString *)username;
- (NSString *)password;
- (NSString *)email;
- (NSString *)uuid;
- (NSString *)sysID;
- (NSString *)channelID;
- (NSString *)channelID2;
- (NSString *)version;
- (NSString *)smscid;
- (NSString *)mainServerURL;
- (NSString *)openUDID;
- (NSString *)versionCode;
- (NSString *)countryName;
- (NSString *)stateName;
- (NSString *)cityName;
- (NSString *)macaddress;
- (NSString *)scmString;
- (BOOL)netWorkRemind;//网络提醒是否关闭(YES-关闭状态；NO-开启)
- (BOOL)autoCheckUpdate;//自动检测更新
- (BOOL)closePush;//是否关闭推送(YES-关闭;NO-未关闭)
- (NSInteger)buffTime;//播放缓冲时长
- (NSInteger)playMode;//播放模式
- (NSString *)introVersion;//欢迎引导版本，同版本只显示一次
- (BOOL)reloadRecommendView;
- (BOOL)endDownload;
- (NSString *)pushToken;
- (NSDate *)lastUpdatePushTokenDate;
- (NSDate *)lastUpdateLocation;
- (BOOL)autoUpdateWifi;//Wi-Fi环境下自动下载更新
- (BOOL)autoUpdateCellphone;//手机网络下自动下载更新
- (BOOL)isFirstSetAutoUpdate;
- (NSString *)myCommunityUrl;
- (NSString *)communityUrl;
- (NSString *)communityPostUrl;
- (NSString *)communityApplyUrl;
-(NSString*)myactivApplyUrl;
//投票
- (NSString *)voteApplyUrl;
//摇奖
-(NSString *)shakeApplyUrl;
//电台分享
-(NSString*)radioShareUrl;

- (void)setAppChatRoomOnOff:(BOOL)value;
- (BOOL)getAppCharRoomOnOff;

- (NSArray*)getFindViewTopType;//获取发现页面顶部类型文字
- (BOOL)isShowDownload;
- (void)setLastUpdatePushTokenDate:(NSDate *)value;
- (void)setLastUpdateLocation:(NSDate *)value;
- (void)setPushToken:(NSString *)value;
- (void)setNetWorkRemind:(BOOL)value;
- (void)setAutoCheckRemind:(BOOL)value;
- (void)setClosePush:(BOOL)value;
- (void)setBuffTime:(NSInteger)value;
- (void)setPlayMode:(NSInteger)value;
- (void)setIntroVersion:(NSString *)value;
- (void)setReloadRecommendView:(BOOL)value;
- (void)setEndDownload:(BOOL)value;
- (void)setMainServerURL:(NSString *)value;
- (void)setFindViewTopTypeShow:(NSArray*)_arr;
- (NSString *)applicationServerURL;
- (void)setApplicationServerURL:(NSString *)value;
- (NSString *)latitude;
- (void)setLatitude:(NSString *)value;
- (NSString *)longitude;
- (void)setLongitude:(NSString *)value;
- (NSString *)getSyvn;
- (NSString *)getBuildNumber;
- (void)setUsername:(NSString *)value;
- (void)setPassword:(NSString *)value;
- (void)setEmail:(NSString *)value;
- (NSString *)locationName;//ln:区域名称
- (void)setLocationName:(NSString *)value;
- (void)setStateName:(NSString *)value;
- (void)setCityName:(NSString *)value;
+ (NSDictionary *)getGeneralParameters;
+(NSDictionary*)getSoundBoxGeneralParameters;
+ (NSDictionary *)getGeneralParameters:(BOOL)isPushToken;
- (void)clearUserInformation;
- (void)setAutoUpdateWifi:(BOOL)value;
- (void)setAutoUpdateCellphone:(BOOL)value;
- (void)setIsFirstSetAutoUpdate:(BOOL)value;
- (void)setMyCommunityUrl:(NSString *)value;
- (void)setCommunityUrl:(NSString *)value;
- (void)setCommunityPostUrl:(NSString *)value;
- (void)setCommunityApplyUrl:(NSString *)value;
- (void)setShowDownload:(BOOL)value;

-(void)setShakeApplyUrl:(NSString*)value;
-(void)setVoteApplyUrl:(NSString*)value;
-(void)setMyactivApplyUrl:(NSString*)value;
-(void)setRadioShareUrl:(NSString*)value;

-(void)setProductID:(NSString*)proID;
- (void)setCountryName:(NSString *)value;

+ (NSString *)getLocalIP;
@end
