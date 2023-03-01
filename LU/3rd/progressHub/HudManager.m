//
//  HudManager.m
//  CNLive3.3
//
//  Created by cnlive bj on 13-1-30.
//  Copyright (c) 2013年 cnlive. All rights reserved.
//

#import "HudManager.h"
#import "MBProgressHUD.h"

#define HUD_TAG 123321

@implementation HudManager

static HudManager*hudManager = nil;

+(HudManager *)sharedHudManager{
    
    @synchronized([HudManager class])
    {
        if(!hudManager){
            
            hudManager = [[HudManager alloc]init];
        }
    }

    return hudManager;
}

//alert
- (void)alertHUD:(NSString*)caption superView:(UIView*)superView
{
    [self alertHUD:caption hideAfter:2 superView:superView];
}

- (void)alertHUD:(NSString*)caption hideAfter:(NSTimeInterval)delay superView:(UIView*)superView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:NO];
//    hud.customView = [JPMyControl createViewWithFrame:CGRectMake(0, 0, 50, 50) bgColor:[UIColor blackColor]];
    hud.customView.contentMode = UIViewContentModeCenter;
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeCustomView;
	hud.detailsLabelText = caption;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:delay];
}

//progress

- (void)progressHUD:(NSString*)caption activity:(BOOL)activity superView:(UIView*)superView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:NO];
	
    if (!activity) {
        hud.mode = MBProgressHUDModeCustomView;
    }
    hud.dimBackground =NO;
    hud.color = UIColorFromRGB(0x000000);
    hud.activityIndicatorColor = UIColorFromRGB(0xababab);
    hud.labelText = caption;
//	hud.detailsLabelText = caption;
	hud.removeFromSuperViewOnHide = YES;
    
}

- (void)hideProgressHUD:(UIView*)superView{
    
    [MBProgressHUD hideHUDForView:superView animated:NO];
}

@end
