//
//  YZPullMenu.h
//  BoHe
//
//  Created by siyuzhe on 16/2/26.
//  Copyright © 2016年 siyuzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZPullMenu;
@protocol YZPullMenuDelegate <NSObject>

- (void)pullMenuTitleDidClick:(YZPullMenu *)pullMenu;

@end
#pragma TODO:self.titleArray内的字符串不可以是重复的不然下面的会出错
@interface YZPullMenu : UIView
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign)id<YZPullMenuDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *titleButtonArray;//导航条中所有的button
@property (nonatomic, strong)UIButton *currentButton;
- (void)showFrom:(UIView *)superView;
//title按钮点击方法
- (void)titleClicked:(UIButton *)button;
@end
