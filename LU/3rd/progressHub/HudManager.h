//
//  HudManager.h
//  CNLive3.3
//
//  Created by cnlive bj on 13-1-30.
//  Copyright (c) 2013年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HudManager : NSObject

+(HudManager *)sharedHudManager;

//alert

- (void)alertHUD:(NSString*)caption superView:(UIView*)superView;
- (void)alertHUD:(NSString*)caption hideAfter:(NSTimeInterval)delay superView:(UIView*)superView;

//progress
- (void)progressHUD:(NSString*)caption activity:(BOOL)activity superView:(UIView*)superView;


//hide progress
- (void)hideProgressHUD:(UIView*)superView;

@end
