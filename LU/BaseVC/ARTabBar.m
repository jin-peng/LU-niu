//
//  ARTabBar.m
//  AnyRadio
//
//  Created by siyuzhe on 2017/9/29.
//  Copyright © 2017年 AnyRadio.CN. All rights reserved.
//

#import "ARTabBar.h"

@interface ARTabBar() 
@property (nonatomic, weak) UIImageView *bgView;
@end
@implementation ARTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleBlack;
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"菜单栏"];
        bgView.size = bgView.image.size;
        self.bgView = bgView;
        self.backgroundColor = [UIColor colorWithWhite:249.0/255 alpha:1];
//        [self addSubview:bgView];
        self.barStyle = UIBarStyleDefault;
    }
    return self;
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = CGRectMake(0, -1, _MainScreen_Width, 51);
    
    UIImage *image1 =[UIImage imageNamed:@"菜单栏"];
    
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width*0.3 topCapHeight:image1.size.height*0.7];
    
    _bgView.image=image1;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            if (tabbarButtonIndex == 2) {
//                
////                child.centerX = _bgView.centerX;
////                child.y = TabBarHeight - child.height - 9;
//                child.center = CGPointMake(child.center.x, 6);
//            }
//            else
//            {
////                child.y = child.y + 2.5;
//            }
//            tabbarButtonIndex++;
//            
//        }
    }
}

@end
