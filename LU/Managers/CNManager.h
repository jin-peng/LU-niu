//
//  CNManager.h
//  ChinaNews
//
//  Created by JinPeng on 2016/11/15.
//  Copyright © 2016年 JinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARConstants.h"
#import <AFNetworking/AFNetworking.h>
#import "UIButton+AFNetworking.h"
#import "JKEncrypt.h"
#define MYLANGUAGE @"my_Language_HasSelected"
#define VIDEOCOLLECTION @"videoCollection"
#define RADIOCOLLECTION @"radioCollection"
#define MUSICCOLLECTION @"musicCollection"
#define UPVIDEOID       @"upVideoID"
#define OPENPICARRAY    @"openPicArray"
#define OPENPICARRAYI   @"openPicArrayI"
#define HASBUYSTOCK     @"hasBuyStock"
#define STOCKHISTORY    @"stockHistory"
#define REALNAME        @"realName" //实名
#define REALCODE        @"realCode" //身份证
#define BANKCARD        @"BankCard" //银行卡号
#define MONEYCODE       @"moneyCode" //提现密码
#define USERNAME        @"userName" //昵称
#define USERID          @"userID"
#define USERPHONE       @"userPhone"
#define LOGINUSERPHOTO  @"LOGINUSERPHOTO"
#define JOIN5K          @"Join5K"
#define gkey            [CNManager getRadomString]
#define gIv             @"087bb3f0"
#define SERVER          @"39.100.77.204:8001" //正式服务器
//#define SERVER          @"39.100.155.103:8001" //测试服务器
//#define SERVER          @"192.168.0.109:8001"//本地测试
#define MONEY           @"USERMONEY" //z余额
#define RULES           @"USERRULES" //用户策略
#define BANKNAME        @"bankName" //银行名称
#define USERIP          @"userIP"
static NSString *       ramdom;
//#define BANKCARD        @"bankCard"

#ifdef DEBUG
# define DLog(fmt, ...); NSLog((@"[%s]\n" "[%s %d] " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#ifdef DEBUG
# define XLog(fmt, ...); NSLog((@"[%s]\n" "[%s %d] " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define XLog(fmt, ...); NSLog(fmt,## __VA_ARGS__);
//# define XLog(...);
#endif

#define GETKEY(dict, key) [dict objectForKey:key]?[NSString stringWithFormat:@"%@",[dict objectForKey:key]]:[dict objectForKey:key];
#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define MOVMENULIST     @"movMenuList"
#define HASDOWNLOADZIP  @"hasDownloadZIP"


struct ItemParameter {//图片宽和宽高比
    CGFloat imgW;
    CGFloat scale;
    CGFloat imgX;
    CGFloat imgY;
};
typedef struct ItemParameter ItemParameter;
@interface CNManager : NSObject

@property (nonatomic, strong)NSDictionary * language;
@property (nonatomic, strong)NSMutableArray * collectArray;
@property (nonatomic) BOOL hasGetCollect;
@property (nonatomic, strong) NSString * nowLG;

+(CNManager * )shareInstance;
#pragma mark 多语言支持
+ (NSString *)loadLanguage:(NSString*)baseString;
+ (NSString *)languageID;
#pragma mark 快速本地存取

+ (void)saveObject:(id)obj byKey:(NSString*)key;

+ (id)loadByKey:(NSString*)key;
+ (void)shareView;//分享
//判断登录

+ (BOOL)hasLogin;

//登出

+ (void)loginOut;
+ (BOOL)hasMoneyCode;
//自动清除缓存

+ (void)clearMemoryLargeThanSize:(NSInteger)maxSize;

//屏显提示

+ (void)showWindowAlert:(NSString*)alert;

+ (void)showWindowAlert:(NSString*)alert center:(CGPoint)center time:(CGFloat)time;
//时间戳转文字
+ (NSString *)setShowTime:(double)time;

+(NSString *)setShowMessageTime:(NSString *)timeStr;
+ (NSString *)setShowDateTime:(double)time;
//文字时间转时间戳
+ (double)getTimeStamp:(NSString*)timeStr;

+ (NSString *)getShowNum:(double)x;
+(void)delFile:(NSURL *)url;

//获取item的size
//视频的layout
+ (ItemParameter)getItemSize:(NSString *)layout;
//根据layout获取每行的item个数
+ (int)getNumberOfSec:(NSString *)layout;
//UIcollection中保存indexPath行中最大的height到heightArray
/**
 把每一个区的每一行的高度额外值（取每一行所有cell其中最大的H）保存到self.heightArray，每次刷新都先去看self.heightArray中有没有这个高度额外值，如果没有先去计算这一行中最高的cell，然后把这个值添加到self.heightArray，再去取。
 */
+ (void)addHeight:(NSIndexPath *)indexPath heightArray:(NSMutableArray *)heightArray tripleArray:(NSArray *)tripleArray;
//tripleArray的数据格式有区别
+ (void)addHeight:(NSIndexPath *)indexPath heightArray:(NSMutableArray *)heightArray tripleArray:(NSArray *)tripleArray isTripleData:(BOOL)isTripleData;


+ (BOOL)testCollectionVideo:(NSString *)videoID;
+ (BOOL)testCollectionRadio:(NSString *)RadioID;
+ (BOOL)testCollectionMusic:(NSString *)MusicID;



//设置是否横屏
+ (void)isHengPing:(BOOL)hengPing;
+ (BOOL)isHengPing;
//是否横屏
+ (UIInterfaceOrientationMask)interfaceOrientationMask;

+ (BOOL)isMobile:(NSString *)phoneNum;//判断是否手机号

- (void)changeLanguage:(NSString *)languge;

+ (UIViewController *)getCurrentVC;//获取当前显示的vc

+ (BOOL)isIta;

+ (BOOL)isCN;
//+ (void)writePlist;
+ (BOOL)showLogin;

+ (BOOL)isLogin;

+ (void)CIGetCollectedArray;

+ (void)delCollect:(NSString *)rid;

+ (BOOL)hasCollect:(NSString *)rid;

+ (BOOL)hasRealName;
+ (BOOL)hasBankCard;
+ (void)getConf;

+ (void)downloadFile:(NSString *)urlString :(NSString *)fileString :(NSString *)imgVer;

+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
+ (id)CNtoArrayOrNSDictionary:(NSString *)jsonString;

+ (AFSecurityPolicy *)createSecurity;
+ (NSArray *)getArrayFromFile:(NSString *)fileName;
//+ (UIImage*)scaleToFillSize:(CGSize)newSize image:(UIImage *)image;
+ (NSString *)resetFormat:(NSString *)str digit:(NSInteger)i;
+ (NSString *)resetFormatWithPlus:(NSString *)str digit:(NSInteger)i;
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)getRadomString;
@end
