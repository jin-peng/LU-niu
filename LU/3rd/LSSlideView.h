//
//  slideView.h
//  testScrollViewViewController
//
//  Created by apple  on 13-8-16.
//  Copyright (c) 2013年 imac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"


@protocol slideViewDelegate <NSObject>
-(void)whichOneIsSelected:(int)page;
@end

@interface LSSlideView : UIView<UIScrollViewDelegate>
@property (strong,nonatomic)NSMutableArray *slideImages;//存放图片数组
@property (strong,nonatomic)id<slideViewDelegate> delegate;
@property (strong,nonatomic)UIScrollView *scrollView;
@property (nonatomic ,strong) NSMutableArray * imgArr;

@property (strong,nonatomic)UIPageControl *pageControl;
@property (nonatomic,assign)BOOL isNetworkImage;//如果是网络图片 Yes:网络 NO:本地
@property (nonatomic,strong)NSString *str_DefaultPageImageName;//缺省也图片名
@property (nonatomic,assign)long shufflingTimer;//轮播的时间间隔
@property (copy,nonatomic)void(^clickedWithIndex)(int);

/*-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame
 *参数：(CGRect)scrollFrame  ScrollView的Frame imageArray:(NSMutableArray*)arr_Imgs  图片地址数组
 *初始化scorllView和pageController  并设定时间
 *无返回值
 */
-(void)initScrollViewAndPageController:(CGRect)scrollFrame imageArray:(NSMutableArray*)arr_Imgs;
/*-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame  imageArray:(NSMutableArray*)arr_Imgs
 *参数：(CGRect)scrollFrame  ScrollView的Frame     PageControllerFrame:(CGRect)pageCFrame pageConreoller的Frame
 *初始化scorllView和pageController  并设定时间
 *无返回值
 */
-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame ;
/*-(void)startSlide:(NSInteger)time
 *参数：滑动的时间(long)shufflingTimer
 *控制视图滑动的开始
 *无返回值
 */
-(void)startSlide;

/*-(void)endSlide
 *参数：无参数
 *控制视图滑动的结束
 *无返回值
 */
-(void)endSlide;

/*-(void)turnThePageWithIsRight
 *参数：isRight  yes:向后翻 no：向前翻
 *
 *无返回值
 */
-(void)turnThePageWithIsRight:(BOOL)isRight;


@end
