//
//  ARVCUtils.m
//  ChinaNews
//
//  Created by JinPeng on 2017/3/27.
//  Copyright © 2017年 JinPeng. All rights reserved.
//

#import "ARVCUtils.h"
#import "CNDetailWebViewController.h"
#import "CISecondStepViewController.h"
#import "CISecondSelectViewController.h"
#import "CIInlinkViewController.h"
#import "CIRestaurantViewController.h"
#import "CIPlayAudioViewController.h"
#import "AppDelegate.h"

#define ACTDO_out_link @"out_link"
#define ACTDO_in_link @"in_link"
#define ACTDO_hide_link @"hide_link"

static NSDictionary *actionDictionary;
static NSDictionary * actDic;
static UIViewController * _pvc;

@interface ARVCUtils ()<UIAlertViewDelegate>

@end

@implementation ARVCUtils


+ (void)createDic {
    if (!actionDictionary) {
        actionDictionary = @{
                             @"radio_play": @1,
                             @"album_play": @2,
                             @"general_list": @3,
                             @"dj_details": @4,
                             @"album_details": @5,
                             @"in_link": @6,
                             @"out_link": @7,
                             @"hide_link": @8,
                             @"album_list": @9,
                             @"special_list": @10,
                             @"recommend": @11,
                             @"dj_list":@12,
                             @"radio_areas":@13,
                             @"ranking":@14,
                             @"category_list":@15,
                             @"close_and_in_link":@16,
                             @"community_info":@17,
                             @"post_info":@18,
                             @"video_list":@19,//视频列表  带分类
                             @"video_play":@20,//单集视频
                             @"episode_play":@21,//视频集合
                             @"news":@22,//新闻
                             @"singer_list":@23,//歌手分类
                             @"music_details":@24,//音乐详情
                             @"music_play":@25,//音乐单曲播放
                             @"special_type":@26,//直播列表页
                             @"singer_details":@27,//歌手详情
                             @"article_details":@28,//详情页
                            // @"special_list":@29,//带头图的二级列表页
                             @"article_list":@30,//不带头图，需要请求的二级列表页
                            // @"recommend":@31,//类首页界面
                             @"restaurant":@32 //餐厅详情页
                             };
        
    }
}

+ (void)handleEvents:(NSDictionary *)dictionary controller:(UIViewController *)viewController fromTag:(NSInteger)fromtag{
    [self createDic];
    NSArray *actionArray = [dictionary objectForKey:@"action"];
    if (!actionArray.count) {
        return;
    }
    NSDictionary *infoDictionary = [actionArray objectAtIndex:0];
    NSString *event = [infoDictionary objectForKey:@"event"];
    NSInteger index = 0;
    NSString *doString;
    NSMutableDictionary *playDictionary;
    if (![event isEqualToString:@"click"]&&![event isEqualToString:@"load"]) {
        DLog(@"行为事件不支持：%@", event);
        if ([[dictionary objectForKey:@"type"] isEqualToString:@"category"]) {
            if ([[dictionary objectForKey:@"resource_type"] isEqualToString:@"radio"]) {
                doString = @"general_list";
                index = [[actionDictionary objectForKey:doString] integerValue];
                playDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            }else if ([[dictionary objectForKey:@"resource_type"] isEqualToString:@"album"]){
                doString = @"album_list";
                index = [[actionDictionary objectForKey:doString] integerValue];
                playDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            }
        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"recommend"]){
            if ([[dictionary objectForKey:@"resource_type"] isEqualToString:@"album"]) {
                doString = @"recommend";
                index = [[actionDictionary objectForKey:doString] integerValue];
                playDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            }else if ([[dictionary objectForKey:@"resource_type"] isEqualToString:@"star_dj"]){
                doString = @"recommend";
                index = [[actionDictionary objectForKey:doString] integerValue];
                playDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            }
        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"radio_areas"]){
            if ([[dictionary objectForKey:@"resource_type"] isEqualToString:@"radio"]) {
                doString = @"general_list";
                index = [[actionDictionary objectForKey:doString] integerValue];
                playDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            }
        }
    }else{
        doString = [infoDictionary objectForKey:@"do"];
        index = [[actionDictionary objectForKey:doString] integerValue];
        playDictionary = [[NSMutableDictionary alloc] initWithDictionary:[infoDictionary objectForKey:doString]];
        NSString *type = [dictionary objectForKey:@"type"];
        NSString *resourceType = [dictionary objectForKey:@"resource_type"];
        if ([type isEqualToString:@"category"] && [resourceType isEqualToString:@"radio"]) {
            [playDictionary setObject:type forKey:@"type"];
            [playDictionary setObject:resourceType forKey:@"resource_type"];
        }
    }
    
    if (playDictionary) {
        switch (index) {
            case 1:{
                CIPlayAudioViewController *vc = [[CIPlayAudioViewController alloc] initWithPlayId:@""];
                vc.playInfo = playDictionary;
                [MyAppDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
//                [viewController presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 6:{
                if (viewController) {//内链
                    CIInlinkViewController * vc = [[CIInlinkViewController alloc]init];
//                    vc.isSpa = YES;
                    vc.urlStr =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)playDictionary[@"url"], nil, nil, kCFStringEncodingUTF8));
                    
                    //                    vc.rid = playDictionary[@"rid"];
                    //                    vc.tid = playDictionary[@"rid"];
                    [viewController.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case 7:{
    
                NSString *urlText = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)playDictionary[@"url"], nil, nil, kCFStringEncodingUTF8));
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
                break;
            }
            case 10:{
                if (viewController) {//带头图
                    CISecondStepViewController * vc = [[CISecondStepViewController alloc]init];
                    vc.isSpa = YES;
                    vc.rid = playDictionary[@"id"];
                    //                    vc.rid = playDictionary[@"rid"];
                    //                    vc.tid = playDictionary[@"rid"];
                    [viewController.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case 11:{
                if (viewController) {
                    CISecondSelectViewController * vc = [[CISecondSelectViewController alloc]init];
                    vc.sid = playDictionary[@"type"];
                    vc.tid = playDictionary[@"id"];
                    vc.onlyList = [playDictionary[@"type2"] boolValue];
                    if (dictionary[@"title"])
                    {
                        vc.navtitle = dictionary[@"title"];
                    }else if(dictionary[@"hint_text"]){
                        vc.navtitle = dictionary[@"hint_text"];
                    }
                    [viewController.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case 28:{//进入详情页
                if (viewController) {
                    CNDetailWebViewController * vc = [[CNDetailWebViewController alloc]init];
                    BOOL isPdf = [infoDictionary[@"article_id"] boolValue];
                    NSString *filePath = nil;
                    if (isPdf) {
                        //是否弹框
                        
                        NSString *urlString = infoDictionary[@"pdfurl"];
                        vc.htmlString = urlString;
                        vc.DetailType = @"1";
                        urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, nil, nil, kCFStringEncodingUTF8));
                        //    NSString *fileString = [self.typeString stringByAppendingString:[urlString lastPathComponent]];
                        NSString * fileString = [[urlString componentsSeparatedByString:@"/"]lastObject];
                        
                        filePath = [self searchLocalWithFileLastPath:fileString];
                    }
                    if (filePath||!isPdf) {
                        
                        vc.newsUrl = [NSURL URLWithString:playDictionary[@"link"]];
                        if (dictionary[@"title"])
                        {
                            vc.newsTitle = dictionary[@"title"];
                        }
                        if (!dictionary[@"title"])
                        {
                            if (dictionary[@"hint_text"])
                            {
                                vc.newsTitle = dictionary[@"hint_text"];
                            }else{
                                vc.newsTitle = @"";
                            }
                        }

                        vc.hidesBottomBarWhenPushed = YES;
                        vc.detailID = [NSString stringWithFormat:@"%@", playDictionary[@"id"]];
                        [viewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        _pvc = viewController;
                        actDic = playDictionary;
                        UIAlertView *logoutAlertV = [[UIAlertView alloc] initWithTitle:[CNManager loadLanguage:@"是否加载本期杂志？"]
                                                                               message:nil
                                                                              delegate:self
                                                                     cancelButtonTitle:[CNManager loadLanguage:@"否" ]otherButtonTitles:[CNManager loadLanguage:@"是"], nil];
                        [logoutAlertV show];
                    }
                    
                }
                break;
            }
            
            case 30:{//不带头图
                if (viewController) {
                    CISecondStepViewController * vc = [[CISecondStepViewController alloc]init];
                    vc.rid = playDictionary[@"rid"];
                    vc.tid = playDictionary[@"tid"];
                    [viewController.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
             
            case 32:{//餐厅详情页
                if (viewController) {
                    CIRestaurantViewController * vc = [[CIRestaurantViewController alloc]init];
//                    vc.rid = playDictionary[@"rid"];
                    vc.detailID = playDictionary[@"id"];
                    [viewController.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
                
            
            default: {
                DLog(@"行为操作不支持：%@", doString);
                break;
            }
        }
    }
}


+ (NSString *)searchLocalWithFileLastPath:(NSString *)lastPath
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"PDF"];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [documentDir stringByAppendingPathComponent:lastPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        CNDetailWebViewController * vc = [[CNDetailWebViewController alloc]init];
        vc.detailID = actDic[@"id"];
        [_pvc.navigationController pushViewController:vc animated:YES];
    }
}

@end
