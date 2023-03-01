//
//  YZPullMenu.m
//  BoHe
//
//  Created by siyuzhe on 16/2/26.
//  Copyright © 2016年 siyuzhe. All rights reserved.
//

#import "YZPullMenu.h"
#import "UIView+Extension.h"
#define MainScreenW _MainScreen_Width
#define MainScreenH _MainScreen_Height
#define GreenColor [UIColor colorWithRed:190.0/255 green:50.0/255 blue:40.0/255 alpha:1]
@interface YZPullMenu()
@property (nonatomic, strong)UILabel *vernier;//游标
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, assign)BOOL isOpen;
@property (nonatomic, weak)UIButton *openButton;
@property (nonatomic, weak)UIButton *changeButton;//删除或排序按钮
@property (nonatomic, strong)UIView *moreMenu;//下拉所有的菜单
@property (nonatomic, strong)UIView *menuManager;//排序或删除控制器
@property (nonatomic, strong)NSMutableArray *buttonArray;
//@property (nonatomic, weak)UIButton *currentBut;//当前拖动的button
@property (nonatomic, assign)CGRect indexFrame;
@property (nonatomic, assign)BOOL isChanged;//记录菜单顺序是否改变；
@property (nonatomic, strong)NSMutableArray *otherTitle;//存放的其他标题str

@property (nonatomic, strong)UIButton *centerBtn;  //最中间的btn；
@end
@implementation YZPullMenu

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (NSMutableArray *)titleButtonArray
{
    if (_titleButtonArray == nil)
    {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}
- (void)showFrom:(UIView *)superView
{
    
    [superView addSubview:self];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView]; 
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake((self.titleArray.count + 3) * 50, 0);
//    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    //布局scrollView
    [self layoutSomeSubviews];
    //添加右侧小箭头
//    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    openButton.frame = CGRectMake(self.width - 40, 0, 40, self.height - 2);
//    openButton.backgroundColor = [UIColor whiteColor];
//    [openButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
//    [openButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateHighlighted];
//    [openButton addTarget:self action:@selector(openAllMenu:) forControlEvents:UIControlEventTouchUpInside];
//    openButton.clipsToBounds = YES;
//    self.openButton = openButton;
//    [self addSubview:openButton];
//    //添加下拉更多菜单
//    [self addSubview:self.moreMenu];

}
//布局按钮
- (void)layoutSomeSubviews
{
    for (UIView *view in self.scrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }    CGFloat w = 12;
    BOOL f = NO;
    for (int i = 0; i < self.titleArray.count; i++)
    {
        NSString *str = self.titleArray[i];
        CGSize strSize = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮标题
        [button setTitle:str forState:UIControlStateNormal];
        //设置按钮颜色
        [button setTitleColor:UIColorFromRGB(0x303030) forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateSelected];
//        [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.frame = CGRectMake(w, 0, strSize.width + 2, self.height - 2);
//        self.vernier.frame = button.frame;
        w = w + button.width + 37;
        button.tag = i;
        [self.titleButtonArray addObject:button];
        if (w > MainScreenW / 2 && !f)
        {
            self.centerBtn = button;
            f = YES;
        }
        if (i == 0)
        {
            
            _currentButton = button;
            button.selected = YES;
            //添加游标
            self.vernier.frame = CGRectMake(12, self.height - 2, 30, 2);
            self.vernier.width = button.width - 3;
            self.vernier.center = CGPointMake(button.center.x, self.height - 2);
            [self.scrollView addSubview:self.vernier];
        }
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
    }
    self.scrollView.contentSize = CGSizeMake(w, 0);

}
//打开或关闭下拉菜单
- (void)openAllMenu:(UIButton *)openButton
{
//    self.backgroundColor = GreenColor;
    self.isOpen = !self.isOpen;
    [UIView animateWithDuration:0.5 animations:^{
        openButton.imageView.transform = CGAffineTransformRotate(openButton.imageView.transform, M_PI);
    }];
}
//title按钮点击方法
- (void)titleClicked:(UIButton *)button
{
    self.currentButton.selected = NO;
    button.selected = YES;
    self.currentButton = button;
    //代理要处理的事情
    if ([self.delegate respondsToSelector:@selector(pullMenuTitleDidClick:)])
    {
        [self.delegate pullMenuTitleDidClick:self];
    }
    else
    {
        NSLog(@"title点了，但是没有实现代理方法");
    }
    //游标重定位
    [UIView animateWithDuration:0.1 animations:^{
        self.vernier.width = button.width - 3;
        self.vernier.center = CGPointMake(button.center.x, self.height - 2);
    }];
    //设置scrollview偏移量
    if (button.tag > self.centerBtn.tag)
    {
        float w = button.center.x - MainScreenW / 2;
        [self.scrollView setContentOffset:CGPointMake(w, 0) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (UILabel *)vernier
{
    if (_vernier == nil)
    {
        _vernier = [[UILabel alloc] init];
        _vernier.backgroundColor = GreenColor;
    }
    return _vernier;
}
- (NSArray *)titleArray
{
    if (_titleArray == nil)
    {
        _titleArray = [NSArray array];

    }
    return _titleArray;
}
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    CGRect newFrame = [self convertRect:self.bounds toView:window];
    if (isOpen)
    {
        [window addSubview:self.moreMenu];
        [UIView animateWithDuration:0.5 animations:^{
            self.moreMenu.frame = CGRectMake(0, newFrame.origin.y + self.height, self.width, MainScreenH - self.height);
            UIViewController *VC = (UIViewController *)self.delegate;
            VC.tabBarController.tabBar.hidden = YES;
        }];
        //移除scrollView
        [self.scrollView removeFromSuperview];
        //添加排序控制器
        [self addSubview:self.menuManager];
        [self bringSubviewToFront:self.openButton];
    }
    else
    {
        [self.menuManager removeFromSuperview];
        [self addSubview:self.scrollView];
        [self bringSubviewToFront:self.openButton];
        self.changeButton.selected = YES;
        [self sequenceOrDelete:self.changeButton];
        [UIView animateWithDuration:0.5 animations:^{
            self.moreMenu.frame = CGRectMake(0, newFrame.origin.y + self.height, self.width, 0);
        } completion:^(BOOL finished) {
            UIViewController *VC = (UIViewController *)self.delegate;
            VC.tabBarController.tabBar.hidden = NO;
        }];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, MainScreenW, self.height);CGContextSetRGBStrokeColor(context, 220 / 255.0, 220 / 255.0, 220 / 255.0, 1);
    CGContextStrokePath(context);
    
}
- (UIView *)moreMenu
{
    if (_moreMenu == nil)
    {
        _moreMenu = [[UIView alloc] init];
        _moreMenu.clipsToBounds = YES;
        _moreMenu.userInteractionEnabled = YES;
        _moreMenu.backgroundColor = [UIColor whiteColor];
        
        //找最上面的Windows
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        CGRect newFrame = [self convertRect:self.bounds toView:window];
        _moreMenu.frame = CGRectMake(0, newFrame.origin.y + self.height, self.width, 0);
        
        //布局展开菜单上的按钮
        [self layoutButtonInMenu];
    }
    return _moreMenu;
}
//布局展开菜单上的按钮
- (void)layoutButtonInMenu
{
    for (UIView *view in self.moreMenu.subviews)
    {
        if (([view isKindOfClass:[UIButton class]] || view.tag == 1111))
        {
            [view removeFromSuperview];
        }
    }
    //布局上面显示的按钮
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮标题
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitle:self.titleArray[i] forState:UIControlStateHighlighted];
        //设置按钮颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13]];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.tag = i;
        
        int wCount = MainScreenW / 90;//每行放的个数
        button.frame = CGRectMake(i % wCount * 90 + 12, i / wCount * 40 + 20, 80, 30);
        [button addTarget:self action:@selector(buttonOnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreMenu addSubview:button];
        [arrM addObject:button];
    }
    self.buttonArray = arrM;
    //布局其他不显示的按钮
    UIButton *lastBut = self.buttonArray.lastObject;
    float y = CGRectGetMaxY(lastBut.frame);
    if (self.otherTitle.count > 0)
    {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, y + 25, MainScreenW, 40)];
        titleView.tag = 1111;
        titleView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        [self.moreMenu addSubview:titleView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 150, 24)];
        label.text = @"点击添加更多频道";
        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
        label.textColor = [UIColor grayColor];
        [titleView addSubview:label];
        for (int i = 0; i < self.otherTitle.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置按钮标题
            [button setTitle:self.otherTitle[i] forState:UIControlStateNormal];
            [button setTitle:self.otherTitle[i] forState:UIControlStateHighlighted];
            //设置按钮颜色
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:GreenColor forState:UIControlStateSelected];
            [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13]];
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 3;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.tag = i;
            
            int wCount = MainScreenW / 90;//每行放的个数
            button.frame = CGRectMake(i % wCount * 90 + 12, i / wCount * 40 + y + 90, 80, 30);
            [button addTarget:self action:@selector(displayClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.moreMenu addSubview:button];
            
        }

        
    }
}
//其他按钮点击展示的方法
- (void)displayClicked:(UIButton *)button
{
    
    NSString *str = self.otherTitle[button.tag];
    [self.otherTitle removeObjectAtIndex:button.tag];
    [self.buttonArray addObject:button];
    button.tag = self.buttonArray.count - 1;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSString *str in self.titleArray)
    {
        [arrayM addObject:str];
    }
    [arrayM addObject:str];
    self.titleArray = arrayM;
    //重新布局按钮
    [self layoutSomeSubviews];
    //重新布局展开菜单上的按钮
    [self layoutButtonInMenu];
    self.changeButton.selected = NO;
    [self sequenceOrDelete:self.changeButton];
    self.isChanged = NO;
}
//展开菜单上的按钮点击方法
- (void)buttonOnMenuClicked:(UIButton *)button
{
    UIButton *aButton = self.titleButtonArray[button.tag];
    [self titleClicked:aButton];
    self.isOpen = NO;
}
- (UIView *)menuManager
{
    if (_menuManager == nil)
    {
        _menuManager = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        UILabel *changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.height - 25) / 2, 60, 25)];
        [changeLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15]];
        changeLabel.text = @"切换频道";
        [_menuManager addSubview:changeLabel];
        
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeButton = changeButton;
        changeButton.frame = CGRectMake(self.width - 130, (self.height - 25) / 2, 75, 25);
        [changeButton setTitle:@"排序或删除" forState:UIControlStateNormal];
        [changeButton setTitleColor:GreenColor forState:UIControlStateNormal];
        [changeButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15]];
        [changeButton addTarget:self action:@selector(sequenceOrDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_menuManager addSubview:changeButton];
        
    }
    return _menuManager;
}
- (void)sequenceOrDelete:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        [button setTitle:@"完成" forState:UIControlStateNormal];
        for (int i = 0; i < self.buttonArray.count; i++)
        {
            UIButton *button = self.buttonArray[i];
            [button removeTarget:self action:@selector(buttonOnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0)
            {
                continue;
            }
            //添加小删除按钮
            UIButton *deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBut.bounds = CGRectMake(0, 0, 20, 20);
            deleteBut.center = CGPointMake(button.width - 2, 3);
            [deleteBut setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            deleteBut.tag = button.tag;
            [deleteBut addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:deleteBut];
            
            //添加拖动手势
            [self myPanRecognizer:button];
            
//            添加抖动动画
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.duration = 0.3;
            //设置旋转动画的起始值，可以使用nsnumber类型
            rotationAnimation.fromValue = @(- M_PI / 50);
            //设置结束值
            rotationAnimation.toValue = @(M_PI / 50);
            rotationAnimation.repeatCount = MAXFLOAT;
            [button.layer addAnimation:rotationAnimation forKey:nil];
            
        }

    }
    else
    {
        [button setTitle:@"排序或删除" forState:UIControlStateNormal];
        for (int i = 0; i < self.buttonArray.count; i++)
        {
            UIButton *button = self.buttonArray[i];
            [button addTarget:self action:@selector(buttonOnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0)
            {
                continue;
            }
            for (UIView *view in button.subviews)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    [view removeFromSuperview];
                }
            }
            //移除所有手势
            for (UISwipeGestureRecognizer *recognizer in [button gestureRecognizers])
            {
                [button removeGestureRecognizer:recognizer];
            }
            //移除所有动画
            [button.layer removeAllAnimations];
            
        }

    }
}

#pragma mark 拖动手势
- (void)myPanRecognizer:(UIButton *)button
{
    //创建拖动手势，并且绑定响应事件，并传递手势对象
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [button addGestureRecognizer:panRecognizer];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)aRecognizer
{
    //获取手势所添加到的视图对象
    UIView *touchView = aRecognizer.view;
    
    //locationInView获取手指坐落在指定视图上的位置信息
    //CGPoint locationPoint =  [aRecognizer locationInView:touchView.superview];
    
    //translationInView获取手势在指定视图中的位移量
    CGPoint offSetPiont = [aRecognizer translationInView:touchView.superview];
    //NSLog(@"__%s",__func__);
    touchView.center = CGPointMake(touchView.center.x + offSetPiont.x, touchView.center.y + offSetPiont.y);
    //重置位移量，也就是每移动一点就把位移量清零，防止位移量累加
    [aRecognizer setTranslation:CGPointZero inView:touchView.superview];
    int tag = 0;
    for (int i = 0; i < self.buttonArray.count; i++)
    {
        if (i == touchView.tag)
        {
            continue;
        }
        UIButton *button = self.buttonArray[i];
        if (CGRectContainsPoint(button.frame, touchView.center))
        {
            if (button.enabled)
            {
                tag = button.tag;

            }
            
            break;
        }
    }
    if (tag > 0)
    {
//        NSMutableArray *newArray = [NSMutableArray array];
        //    UIButton *button = (UIView *)self.buttonArray;
        //    self.indexFrame = button.frame;
        if (touchView.tag > tag)
        {
            for (int i = tag; i < self.buttonArray.count; i++)
            {
                if (i == touchView.tag)
                {
                    break;
                }
                
                UIButton *butF = self.buttonArray[i];
                UIButton *butA = self.buttonArray[i+1];
                butF.enabled = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    if (i == touchView.tag - 1)
                    {
                        int wCount = MainScreenW / 90;//每行放的个数
                        butF.frame = CGRectMake(touchView.tag % wCount * 90 + 12, touchView.tag / wCount * 40 + 20, 80, 30);
                        
                    }
                    else
                    {
                        butF.frame = butA.frame;
                    }
                    
                } completion:^(BOOL finished) {
                    butF.enabled = YES;
                }];
            }
        }
        else
        {
            __block CGRect rectF;
            __block CGRect rectA;
            for (int i = touchView.tag; i < self.buttonArray.count; i++)
            {
                if (i == tag)
                {
                    break;
                }
                
                UIButton *butF = self.buttonArray[i];
                UIButton *butA = self.buttonArray[i + 1];
                butA.enabled = NO;
                rectA = butA.frame;
                [UIView animateWithDuration:0.2 animations:^{
                    if (i == touchView.tag)
                    {
                        int wCount = MainScreenW / 90;//每行放的个数
                        butA.frame = CGRectMake(touchView.tag % wCount * 90 + 12, touchView.tag / wCount * 40 + 20, 80, 30);
                        rectF = rectA;
                    }
                    else
                    {
                        butA.frame = rectF;
                        rectF = rectA;
                    }
                    
                } completion:^(BOOL finished) {
                    butA.enabled = YES;
                }];
            }

        }
        
        //重构数组内button顺序 和titleArray顺序
        [self makeSureArrayWithTagF:touchView.tag tagA:tag];
        
        self.isChanged = YES;
    }
    if (aRecognizer.state == UIGestureRecognizerStateEnded)
    {
        int wCount = MainScreenW / 90;//每行放的个数
        touchView.frame = CGRectMake(touchView.tag % wCount * 90 + 12, touchView.tag / wCount * 40 + 20, 80, 30);
        self.isChanged = NO;//恢复默认状态

    }

    
}
- (void)setIsChanged:(BOOL)isChanged
{
    _isChanged = isChanged;
    if (_isChanged)
    {
        //移除原有的button
        for (UIView *view in self.scrollView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                [view removeFromSuperview];
            }
        }
        [self.titleButtonArray removeAllObjects];
        //重新布局按钮
        [self layoutSomeSubviews];
//        NSLog(@"%@",self.titleArray[1]);
    }
}
//重构数组内button顺序 和titleArray顺序
- (void)makeSureArrayWithTagF:(NSInteger)tagF tagA:(NSInteger)tagA
{
    UIButton *button = self.buttonArray[tagF];
    [self.buttonArray removeObject:button];
    [self.buttonArray insertObject:button atIndex:tagA];
    for (int i = 0; i < self.buttonArray.count; i ++)
    {
        UIButton *button = self.buttonArray[i];
        button.tag = i;
    }
    
    NSString *title = self.titleArray[tagF];
    NSMutableArray *arrayM = [NSMutableArray array];
#pragma TODO:self.titleArray内的字符串不可以是重复的不然下面的会出错
    for (NSString *str in self.titleArray)
    {
        [arrayM addObject:str];
    }
    [arrayM removeObject:title];
    [arrayM insertObject:title atIndex:tagA];
    self.titleArray = arrayM;
}
- (void)deleteButtonClick:(UIButton *)button
{
    [self.buttonArray removeObject:button];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSString *str in self.titleArray)
    {
        [arrayM addObject:str];
    }
    NSString *str = arrayM[button.tag];
    [arrayM removeObjectAtIndex:button.tag];
    self.titleArray = arrayM;
    [self.otherTitle addObject:str];
//    NSLog(@"%d,%d",self.otherTitle.count,self.)
    //重新布局按钮
    [self layoutSomeSubviews];
    //重新布局展开菜单上的按钮
    [self layoutButtonInMenu];
    self.changeButton.selected = NO;
    [self sequenceOrDelete:self.changeButton];
}
- (NSMutableArray *)otherTitle
{
    if (_otherTitle == nil)
    {
        _otherTitle = [NSMutableArray array];
    }
    return _otherTitle;
}
@end
