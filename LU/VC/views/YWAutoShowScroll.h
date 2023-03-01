//
//  YWAutoShowScroll.h
//  YiWuBao
//
//  Created by 金鹏 on 14/12/15.
//  Copyright (c) 2014年 i1515. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWAutoShowScroll : UIScrollView
//@property(nonatomic)CGFloat x;
@property(nonatomic)NSInteger y;
@property(nonatomic)NSMutableArray *arr;
@property(nonatomic)NSTimer *runTime;
@property(nonatomic,strong)void (^jumpBlock)(NSInteger);

- (void)createUI:(NSArray*)dic;
@end
