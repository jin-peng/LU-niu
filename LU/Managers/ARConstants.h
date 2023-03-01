#ifndef AnyRadioClient_ARConstants_h
#define AnyRadioClient_ARConstants_h
#define Layout_Big_Video @"bigpic_2" //一行1个图标视频的
#define Layout_Big_Other @"bigpic" //一行1个图标
#define Layout_Two @"2x1_w" //一行2个小图标
#define Layout_Two_unTitle1 @"2x1" //一行2个小图标 无标题
#define Layout_Two_unTitle2 @"2x2" //一行2个小图标 无标题
#define Layout_Two_unTitle3 @"2x3" //一行2个小图标 无标题
#define Layout_Three_Video @"3x1_l" //一行3个小图标视频的
#define Layout_Three_Other @"3x1" //一行3个小图标
#define Layout_Three_Other2 @"3x2" //一行3个小图标
#define Layout_Image_title @"1x3" //一列三行  左边图标右边文字
#define Layout_Five @"icon_5" //一行5个小图标
#define Layout_Three @"icon"  //一行3个小图标
#define Layout_Word @"word"   //一行文字
#define Layout_Twoline @"twoline"   //两行标题
#define Layout_Scroll  @"icon_a"     //一行scroll
#define Layout_Normal @"3x1_l" //默认一行三个


//设备屏幕大小
#define _MainScreenFrame   [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define _MainScreen_Width  _MainScreenFrame.size.width
//设备屏幕高 20,表示状态栏高度.如3.5inch 的高,得到的__MainScreenFrame.size.height是480,而去掉电量那条状态栏,我们真正用到的是460;
#define _MainScreen_Height (_MainScreenFrame.size.height)

//设置相对标准屏幕的高度差
#define _MainScreen_SubHeight (_MainScreen_Height - 480)

#define ScrollBtnH 36            //首页滑动标签高度
//---------------------------字体宏
#pragma mark UIFont宏
#define FONTSYS(size) ([UIFont systemFontOfSize:(size)])
#define FONTBOLDSYS(size) ([UIFont boldSystemFontOfSize:(size)])
#define kFont_NavTitle FONTBOLDSYS(16)//调整
#define kColor_NavTitle UIColorFromRGB(0xFFFFFF)
#define kColor_SecNavTitle UIColorFromRGB(0x000000)

#define NAVTITLEFONT(size) ([UIFont systemFontOfSize:(size)])
#define kNavTitleFont NAVTITLEFONT(18)//字体调整
#define kLiveNavTitleFont NAVTITLEFONT(14)//字体调整
//---------------------------颜色宏
#pragma mark Color宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//
#define _BOTTOM_COLOR [UIColor colorWithRed:(255.0f)/255.0f green:(255.0f)/255.0f blue:(255.0f)/255.0f alpha:1]

// 分割线颜色
#define SEP_COLOR UIColorFromRGB(0xDEDEDE)

#define SEP_LIGHT_COLOR UIColorFromRGB(0x999999)
//顶部导航栏底部分割线
#define TOP_SEP_COLOR UIColorFromRGB(0xC7C7C7)
//背景色
#define AR_BACKGROUND_COLOR UIColorFromRGB(0xfafafa)
//基本色
//#define ARUITintColor UIColorFromRGB(0xff4b09)
#define ARUITintColor UIColorFromRGB(0xd33b3c)
#define ARBaseViewColor UIColorFromRGB(0xF6F6F6)
#define BaseColoudAppColor UIColorFromRGB(0xF6F6F6)
#define ARSepLineColor UIColorFromRGB(0xe4e4e4)
//列表标题文字
#define ARLIST_TITLE_COLOR UIColorFromRGB(0x303030)
//列表副标题（第二行）文字
#define ARLIST_SUB_TITLE_COLOR UIColorFromRGB(0x808080)
//更多 按钮
#define ARMORE_TITLE_COLOR UIColorFromRGB(0xFF4B09)

#define AR_APPLYEFFECT_COLOR [UIColor colorWithWhite:0.11 alpha:0.3]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//----------------------------Release宏
#pragma mark release宏
#define SY_RELEASE(__POINTER) { [__POINTER release]; if (__POINTER) { __POINTER = nil; }}
#define SY_RELEASE_SAFELY(__POINTER) {if (__POINTER) { __POINTER = nil; }}

#pragma mark UIImage宏
#define SY_IMAGE(name) [UIImage imageNamed:(name)]

// #define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kClientType  @"ios"

#pragma mark- Banner
#define kHeight_NavigationBar       (OSVersionIsAtLeastiOS7()?64.0:0.0)//ios7 60改为64
#define kTopMargin_NavigationBar    0
#define kTopMargin_OSVersion_IOS    (OSVersionIsAtLeastiOS7()?20:0.0)//
#define kLeftMargin_NavigationBar   0
#define kLeftMargin_LeftButton      0   //  扩大响应区域
#define kToDdistance_NavigationBar  40
#define kWidth_LeftButton           40
#define kHeight_LeftButton          40

#define kBottomBar_height          114

#define kHeight_NewRecommend_Title 45 //改版后3.12.0

#define kHeight_Recommend_Title    35 //推荐页标题栏高度
#define kHeight_ListViewCell       75 //listviewcell高度

//首界面头部滚动高度
#define kHeaderScrollViewHeight  568/2. * MULTIPLE
#define kHeaderScrollImageHeight _MainScreen_Width*0.4875

#define kWidth_TwoColum_Image    (_MainScreen_Width-24)/2
#define kHeight_TwoColum_Image   kWidth_TwoColum_Image*0.473
//---------------------------error
#define kDajiaErrorDomain        @"DajiaErrorDomain"
#define kServerErrorCode        @"errorCode"
#define kServerErrorMessage     @"errorMessage"
#define kServerErrorStack       @"errorStack"
#define kServerExceptionID       @"exceptionId"
#define kDajiaLocalErrorDomain        @"DajiaLocalErrorDomain"
#define kAuthError       @"error"
#define kDajiaAuthErrorDomain        @"DajiaAuthErrorDomain"


#define kServerErrorInvalidToken  1003
#define kServerErrorFileMissed  2006
#define kServerErrorGroupForwardForbidden  2007
#define kServerErrorGroupNotificationProcessed  2008
#define kLocalErrorNoCommunity  4001
#define kAuthErrorInvalidGrant 5001

//#define kMasterServer          @"master.g3radio.com"
//#define kSlaveServer           @"slave.g3radio.com"

#define kMasterServer       @"master2.hewokan.cn"    //@"master2.china-plus.net"
#define kSlaveServer        @"slave2.hewokan.cn"    //@"slave2.china-plus.net"

#define kUrlType_UserRegister 8                     // 用户注册专用
#define kUrlType_UserLogin 7                       // 用户登录专用
#define kUrlType_ServerIP   4                       //主服务器地址
#define kUrlType_IP            5                       //服务器返回IP地址
#define kUrlType_childIP     6                       //请求分类列IP地址

#define kHeight_PlayBar          50
#define kHeight_TabBar          40
#define kPublicLeftMenuWidth     250
#define kTabviewFootHeight       (kHeight_PlayBar+20+20)

#define WMA_FORMAT 353
#define LIVE_TYPE_MP3 1000
#define LIVE_TYPE_AAC 1001
#define LIVE_TYPE_SHOUT 1002
#define LIVE_TYPE_SHOUT_RECONNECT 1003
#define LIVE_TYPE_SHOUT_RELOCATION 1004
#define LIVE_TYPE_STOP 1005
//播放类型
#define DEMAND_TYPE 1//点播
#define LIVE_TYPE 2//直播
#define RECORD_FILE_TYPE 3//录音文件
#define LOCAL_FILE_TYPE 4//本地文件
#define PLAYBACK_TYPE 5//回播类型


#define PLAY_STATE_UNSUPPORT -2

#define MAX_PCM 8000
// 前端最大的buffer缓冲区
#define MAXBUFFERSIZE 50*1000*4
// 后端PCM最大的缓冲时间
#define MAX_DEFAULT_TIME 10
// 直播播放时，暂停状态保持时长 单位：秒
#define MAX_TIMEOUT 5

// 播放消息定义
#define MSG_WHAT_PLAY_DEMAND 1000
// 点播时间
#define MSG_WHAT_PLAY_DEMAND_TIME 1001
// 回播下载定义
// 播放消息定义
#define MSG_WHAT_PLAYBACK_DOWNLOAD 1002
//免流量消息提示
#define MSG_WHAT_FREE_TOAST 1003
//服务器原因造成不能播放
#define MSG_WHAT_SERVER_FAILED 1004
// 点播文件总时长
#define MSG_ARG1_TOTAL_DURATION 0
// 播放状态
#define MSG_ARG1_PLAY_STATE 1
// 播放完成
#define MSG_ARG1_FILE_FINISH 2
// 当前时间
#define MSG_ARG1_CURRENT_TIME 3
// 流量
#define MSG_ARG1_CAPACITY 4
// 录音状态
#define MSG_ARG1_RECORD_STATE 5

#define MSG_ARG2_PLAY_STATE_CONNECTION 1
#define MSG_ARG2_PLAY_STATE_INTERACTION 2
#define MSG_ARG2_PLAY_STATE_BUFFERING 3
#define MSG_ARG2_PLAY_STATE_PLAYING 4
#define MSG_ARG2_PLAY_STATE_STOPING 5
#define MSG_ARG2_PLAY_STATE_STOP 6

// 消息如果小于0 或者是停止和完成，则可以认为播放器不在播放状态
#define MSG_ARG2_PLAY_URL_ERROR -10
#define MSG_ARG2_PLAY_STATE_FAILED  -1// 连接失败
#define MSG_ARG2_PLAY_STATE_UNSUPPORT -2// 不支持的媒体格式
#define MSG_ARG2_RECORD_FILE_NOTFOUND -3// 录音文件未找到
#define MSG_ARG2_RECORD_FILE_FINISH -9// 播放完成
#define MSG_ARG2_PLAY_DECODE_ERROR -5// 解码器出现错误
#define MSG_ARG2_RECORD_FILE_ERROR -6 // 录音播放错误
#define MSG_ARG2_LIVE_URL_FORMAT_ERROR -7// 直播地址格式错误

#define MSG_ARG2_DEMAND_FILE_NOTFOUND -8
#define MSG_ARG2_RECORD_STOP 7// 录音停止，不是播放而是形成录音文件
#define MSG_ARG2_PLAY_STATE_PAUSE 8// 录音文件或者点播的暂停

#define MSG_ARG2_PLAY_STATE_FIRSTPLAY 13
#define MSG_ARG2_PLAY_STATE_BUFFER_START 14
#define MSG_ARG2_PLAY_STATE_BUFFER_END 15
#define MSG_ARG2_HEART_CONNECTION 16

#define MSG_ARG2_RECORD_SOSHORT 19 // 录音时长太短
#define MAXRECONECTTIME 30

#define MAX_PLAY_HISTORY_COUNT 30// 收听历史最大记录条数

#define BAIDU_LOCATION_AK @"e6q1WpOh35LQwHG79gEGSGII"

//界面表示
#define FIRST_VC_TAG 0
#define STEPTWO_VC_TAG 1
#define SECON_VC_TAG 2
#define THIRD_VC_TAG 3
#define PUSH_VC_TAG 4 //push打开
#define FIRST_ALBUMPLAY_TAG 5 //推荐页专辑播放
#define COMMUNITY_VC_TAG 6 //社区

//动画时长
#define ANIMATION_DURATION 1

//#define IS_STREAMING_KIT //测试streamingKit时放开

//更新push token得时间间隔（24小时24*60*60）
#ifdef DEBUG
#define UPDATE_PUSHTOKEN_TIME 60*60
#else
#define UPDATE_PUSHTOKEN_TIME 24*60*60
#endif

#define LAYOUT_31 1
#define LAYOUT_13 2
#define LAYOUT_PIC 3
#define LAYOUT_WORD 4


#define NEED_HANDLE_SCHEMADATA @"NEED_HANDLE_SCHEMADATA"

#endif
