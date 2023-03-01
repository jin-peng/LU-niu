//
//  LogoutView.m
//  ZhongYi
//
//  Created by WinterChen on 16/7/13.
//  Copyright © 2016年 win. All rights reserved.
//

#import "LogoutView.h"

@interface LogoutView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsHeightConstraints;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation LogoutView


- (void)showLogoutView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (0) {
            self.title.text = @"Log out?";
            self.message.text = @"Non verrà eliminato nessun dato dai Preferiti";
            [self.exitButton setTitle:@"Log out" forState:UIControlStateNormal];
            [self.cancelButton setTitle:@"Annulla" forState:UIControlStateNormal];
        } else {
            self.title.text = @"退出登录?";
            self.message.text = @"退出后不会删除您收藏内的任何数据";
            [self.exitButton setTitle:@"退出" forState:UIControlStateNormal];
            [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        self.title.font = [UIFont boldSystemFontOfSize:19];
        CGRect bounds = [UIScreen mainScreen].bounds;
        UIView *bgView = [[UIView alloc] initWithFrame:bounds];
        self.bgView = bgView;
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:bgView];
        [bgView addSubview:self];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.message.font = [UIFont boldSystemFontOfSize:19];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        CGFloat tipsHeight = [self.message.text boundingRectWithSize:CGSizeMake(bounds.size.width - 80, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19], NSParagraphStyleAttributeName : style} context:nil].size.height;
        self.tipsHeightConstraints.constant = tipsHeight;
        self.frame = CGRectMake(0, 0, bounds.size.width - 60, 100 + tipsHeight);
        self.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
    });
}

+ (instancetype)loadLogoutView
{
    return [[NSBundle mainBundle] loadNibNamed:@"LogoutView" owner:nil options:nil].lastObject;
}

- (IBAction)exitButtonClick {
    [self.bgView removeFromSuperview];
    
    if (self.logoutBlock) {
        self.logoutBlock(YES);
    }
}

- (IBAction)cancelButtonClick {
    [self.bgView removeFromSuperview];
    if (self.logoutBlock) {
        self.logoutBlock(NO);
    }
}

- (void)drawRect:(CGRect)rect {
    self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1f];
    self.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
}

@end
