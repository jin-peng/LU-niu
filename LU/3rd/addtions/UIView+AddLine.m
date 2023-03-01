//
//  AddLine.m
//  AnyRadio
//
//  Created by anchen on 15/6/3.
//  Copyright (c) 2015年 AnyRadio.CN. All rights reserved.
//

#import "UIView+AddLine.h"
@implementation UIView (AddLine)

-(void)addLineOnSelf{

    UIView *_l = [[UIView alloc] init];
    _l.frame = CGRectMake(0, 0, _MainScreen_Width, 0.5);
    _l.backgroundColor = SEP_COLOR;
    [self addSubview:_l];
}

@end
