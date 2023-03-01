//
//  YWAutoShowScroll.m
//  YiWuBao
//
//  Created by 金鹏 on 14/12/15.
//  Copyright (c) 2014年 i1515. All rights reserved.
//

#import "YWAutoShowScroll.h"

@implementation YWAutoShowScroll

- (void)createUI:(NSArray *)dic{
    for (UIView*view in self.subviews) {
        [view removeFromSuperview];
    }
    self.y=dic.count+2;
    self.arr=[NSMutableArray arrayWithArray:dic];
    [self.arr addObject:dic[0]];
    if (dic.count > 1) {
        [self.arr addObject:dic[1]];
    }else{
        [self.arr addObject:dic[0]];
    }
    self.pagingEnabled=YES;
    self.contentSize=CGSizeMake(self.width, 33*self.y);
    for (int i=0; i<self.arr.count; i++) {
        
        UIImageView*line=[JPMyControl createImageViewWithFrame:CGRectMake(0, 32+33*i, self.width, .5) ImageName:@"message-line"];
        [self addSubview:line];

        UIButton * qname = [JPMyControl createButtonWithFrame:CGRectMake(10, 6+33*i, self.width, 20) Target:self SEL:@selector(btnClick:) Title:[self.arr[i] objectForKey:@"title"] ImageName:@"" bgImage:@"" Tag:100+1];
        [qname setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        qname.titleLabel.font=[UIFont systemFontOfSize:11];
        [self addSubview:qname];
    }
    if (!_runTime) {
        self.runTime=[NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(ani) userInfo:nil repeats:YES];
    }
}

- (void)btnClick:(UIButton *)btn{
    WEAKSELF
    if (self.jumpBlock) {
        weakself.jumpBlock(btn.tag - 100);
    }
}

- (void)ani{
    CGFloat y=self.contentOffset.y+33;
    if (y>=(self.y-1)*33) {
        self.contentOffset=CGPointMake(0, 0);
        y=33;
    }
    [UIView animateWithDuration:1.4 animations:^{
        self.contentOffset=CGPointMake(0, y);
    }];
    
}
- (NSString*)nowTime:(NSInteger)i{
    NSString*str=nil;
    NSLog(@"%f",[[NSDate date]timeIntervalSince1970]/60/60/24/365);
    CGFloat gTime=[[[self.arr[i] objectForKey:@"qtime"] substringToIndex:9]floatValue];
    NSLog(@"%f",gTime/6/60/24/365);
    CGFloat time=[[NSDate date]timeIntervalSince1970]-gTime*10;
    if(10>time/60){
        str=@"几分钟前";
    }else if (60>time/60){
        str=@"几十分前";
    }else if (24>time/60/60){
        str=@"几小时前";
    }else if (2>time/60/60/24){
        str=@"一天前";
    }else if (10>time/60/60/24){
        str=@"几天前";
    }else str=@"几十天前";
    return str;
}

@end
