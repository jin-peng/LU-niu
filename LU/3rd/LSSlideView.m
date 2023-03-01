//
//  slideView.m
//  testScrollViewViewController
//
//  Created by apple  on 13-8-16.
//  Copyright (c) 2013年 imac . All rights reserved.
//

#import "LSSlideView.h"

@interface LSSlideView (){
    
    NSTimer *timer;//滚动的时间
    float width;///没长图片的宽度（显示区域的宽度）
    
    UILabel *label_CurrentPage;
    
}
//@property (nonatomic ,strong) NSMutableArray * imgArr;

@end

@implementation LSSlideView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _str_DefaultPageImageName = @"";
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)initScrollViewAndPageController:(CGRect)scrollFrame imageArray:(NSMutableArray*)arr_Imgs{
    
    self.slideImages=[NSMutableArray arrayWithArray:arr_Imgs];
    CGRect  pageCFrame=  CGRectMake((self.frame.size.width-10*self.slideImages.count)/2, self.frame.size.height-20 ,10*self.slideImages.count, 18);
    [self addScrollViewAndPageController:scrollFrame PageControllerFrame:pageCFrame];
}

-(void)addScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame{
    // 初始化 scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
    self.imgArr = [[NSMutableArray alloc]init];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    /// 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc]initWithFrame:pageCFrame];
    _pageControl.numberOfPages = [_slideImages count];
    _pageControl.currentPage = 0;
    /// 触摸mypagecontrol触发change这个方法事件
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:_pageControl];
    // 创建四个图片 imageview
    width=scrollFrame.size.width - 50;
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((width * i) + width + 25, 0, width, scrollFrame.size.height)];
        image.backgroundColor=[UIColor clearColor];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 10.;
        [_imgArr addObject:image];
        if (self.isNetworkImage) {
            [image setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
        }else{
            //本地
            [image setImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        }
        
        UIButton *button=[[UIButton alloc]initWithFrame:image.frame];
        [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setBackgroundImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTag:i];
        [_scrollView addSubview:image];
        [_scrollView addSubview:button]; // 首页是第0页,默认从第1页开始的。所以+width。。。
    }
    // 取数组最后一张图片 放在第0页
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 0, width, scrollFrame.size.height)];
    image1.backgroundColor=[UIColor clearColor];
    image1.layer.masksToBounds = YES;
    image1.layer.cornerRadius = 10.;
    [_imgArr insertObject:image1 atIndex:0];
    if (self.isNetworkImage) {
        [image1 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:([_slideImages count]-1)]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
    }else{
        //本地
        [image1 setImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    }
    
    UIButton *button1=[[UIButton alloc]initWithFrame: image1.frame];
    [button1 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 setTag:[_slideImages count]-1];
    [_scrollView addSubview:image1];
    [_scrollView addSubview:button1]; // 首页是第0页,默认从第1页开始的。所以+width。。。
    
    // 取数组第一张图片 放在最后1页
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake((width * ([self.slideImages count] + 1)) + 25 , 0, width, scrollFrame.size.height)];
    image2.backgroundColor=[UIColor clearColor];
    image2.layer.masksToBounds = YES;
    image2.layer.cornerRadius = 10.;
    if (self.isNetworkImage) {
        [image2 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
    }else{
        //本地
        [image2 setImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    }

    UIButton *button2=[[UIButton alloc]init];
    
    button2.frame=image2.frame;// 添加第1页在最后 循环
    [button2 setTag:0];
    [_scrollView addSubview:image2];
    [_scrollView addSubview:button2];
    
    [_scrollView setContentSize:CGSizeMake(width * ([_slideImages count] + 2), scrollFrame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(width,0,scrollFrame.size.width,scrollFrame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
}

-(void)initScrollViewAndPageController:(CGRect)scrollFrame PageControllerFrame:(CGRect)pageCFrame{
    self.imgArr = [[NSMutableArray alloc]init];
    // 初始化 scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    /// 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc]initWithFrame:pageCFrame];
    _pageControl.numberOfPages = [_slideImages count];
    _pageControl.currentPage = 0;
    /// 触摸mypagecontrol触发change这个方法事件
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
//    _pageControl.backgroundColor =  RGBACOLOR(99, 99, 99, .2);
    [self addSubview:_pageControl];
    // 创建四个图片 imageview
    width=scrollFrame.size.width - 50;
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((width * i) + width + 25, 0, width, scrollFrame.size.height)];
        //        [image setImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        image.backgroundColor=[UIColor clearColor];
        [_imgArr addObject:image];
//        image.transform =  CGAffineTransformScale(image.transform, .9, .9) ;
        if (self.isNetworkImage) {
            [image setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
        }else{
            //本地
            [image setImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        }
        
        UIButton *button=[[UIButton alloc]initWithFrame:image.frame];
        [button addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setBackgroundImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTag:i];
        [_scrollView addSubview:image];
        [_scrollView addSubview:button]; // 首页是第0页,默认从第1页开始的。所以+width。。。
    }
    // 取数组最后一张图片 放在第0页
    
    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 0, width, scrollFrame.size.height)];
    image1.backgroundColor=[UIColor clearColor];
    [_imgArr insertObject:image1 atIndex:0];
    if (self.isNetworkImage) {
        [image1 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:([_slideImages count]-1)]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
    }else{
        //本地
        [image1 setImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    }
    
    UIButton *button1=[[UIButton alloc]initWithFrame: image1.frame];
    [button1 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 setTag:[_slideImages count]-1];
    [_scrollView addSubview:image1];
    [_scrollView addSubview:button1]; // 首页是第0页,默认从第1页开始的。所以+width。。。
    
    // 取数组第一张图片 放在最后1页
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake((width * ([self.slideImages count] + 1)) + 25 , 0, width, scrollFrame.size.height)];
//    image2.transform =  CGAffineTransformScale(image2.transform, .9, .9);
    image2.backgroundColor=[UIColor clearColor];
    [_imgArr addObject:image2];
    if (self.isNetworkImage) {
        [image2 setImageWithURL:[NSURL URLWithString:[_slideImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:_str_DefaultPageImageName]];
    }else{
        //本地
        [image2 setImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    }
    
    UIButton *button2=[[UIButton alloc]init];
    
    button2.frame=image2.frame;// 添加第1页在最后 循环
    [button2 setTag:0];
    [_scrollView addSubview:image2];
    [_scrollView addSubview:button2];
    
    [_scrollView setContentSize:CGSizeMake(width * ([_slideImages count] + 2), scrollFrame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(width,0,scrollFrame.size.width,scrollFrame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
}
/*-(void)startSlide:(NSInteger)time
 *参数：滑动的时间(NSInteger)time
 *控制视图滑动的开始
 *无返回值
 */
-(void)startSlide{
    if (_slideImages.count>1) {
        // 定时器 循环
        timer= [NSTimer scheduledTimerWithTimeInterval:self.shufflingTimer target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//为定时器开辟线程
    }
    
}

/*-(void)endSlide
 *参数：无参数
 *控制视图滑动的结束
 *无返回值
 */
-(void)endSlide{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDragging");
    [self endSlide];
}

//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    NSLog(@"scrollViewDidEndDragging");
    if(![timer isValid]){
        [self startSlide];
    }
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (int i = 0; i < _imgArr.count; i++) {
        UIImageView * vi = (UIImageView *)_imgArr[i];
        CGFloat scales;
        if (i==0 || i == _imgArr.count) {
            scales = 1. - fabs(scrollView.contentOffset.x - vi.x )/width * .1;
        }else
        scales = 1. - fabs(scrollView.contentOffset.x - vi.x)/width * .1;
        vi.transform = CGAffineTransformMakeScale(scales, scales);
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![timer isValid]){
        [self startSlide];
    }
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    int currentPage_ = (int)self.scrollView.contentOffset.x/width; // 和上面两行效果一样
    _pageControl.currentPage=currentPage_-1;
    
    if (currentPage==0)
    {
        //手动滑到最后一页
        _pageControl.currentPage=[_slideImages count]-1;
        [self.scrollView scrollRectToVisible:CGRectMake(0,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 序号0 最后1页
        
        [self.scrollView scrollRectToVisible:CGRectMake(width * [_slideImages count],0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];
        label_CurrentPage.text=[NSString stringWithFormat:@"%d",(int)_pageControl.currentPage+1];
    }
    else if (currentPage==([_slideImages count]+1))
    {
        //手动滑到第一页
        _pageControl.currentPage=0;
        [self.scrollView scrollRectToVisible:CGRectMake(width,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 最后+1,循环第1页
        label_CurrentPage.text=[NSString stringWithFormat:@"%d",(int)_pageControl.currentPage+1];
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page =(int) _pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(width*(page+1),0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    label_CurrentPage.text=[NSString stringWithFormat:@"%d",(int)_pageControl.currentPage+1];
}
//循环时跳转到第一页
-(void)turnFirstPage{
    [self.scrollView scrollRectToVisible:CGRectMake(width*1,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    label_CurrentPage.text=[NSString stringWithFormat:@"%d",(int)_pageControl.currentPage+1];
}

//跳转到最后一页的下一页
-(void)turnNextPage{
    _pageControl.currentPage=0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(width*([_slideImages count]+1),0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
    } completion:^(BOOL finished){
        [self turnFirstPage];
    }];
}

// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)_pageControl.currentPage; // 获取当前的page
    page++;
    //判断是否已到最后一页实现循环
    if (page==[_slideImages count]) {
        _pageControl.currentPage=0;
        [self turnNextPage];
        
    }else{
        _pageControl.currentPage = page ;
        [self turnPage];
    }
}

//button  点击事件
-(void)imageClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    self.clickedWithIndex((int)btn.tag);
}


/*-(void)turnThePageWithIsRight
 *参数：isRight  yes:向后翻 no：向前翻
 *
 *无返回值
 */
-(void)turnThePageWithIsRight:(BOOL)isRight{
    if (isRight) {
        [self turnNextPageWithBtn];
    }else{
        [self turnLastPageWithBtn];
    }
}
/*turnNextPageWithBtn
 *参数：wu
 *翻倒下一页 按钮点击
 *无返回值
 */
-(void)turnNextPageWithBtn{
    [self runTimePage];
}
/*turnLastPageWithBtn
 *参数：wu
 *翻倒上一页 按钮点击
 *无返回值
 */
-(void)turnLastPageWithBtn{
    int page =(int) _pageControl.currentPage; // 获取当前的page
    page--;
    //判断是否已到第一页实现循环
    if (page==-1) {
        _pageControl.currentPage=_slideImages.count-1;
        [UIView animateWithDuration:0.3 animations:^{
            [self.scrollView scrollRectToVisible:CGRectMake(width*(0),0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];
        } completion:^(BOOL finished){
            [self.scrollView scrollRectToVisible:CGRectMake(width*_slideImages.count,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];
            label_CurrentPage.text=[NSString stringWithFormat:@"%d",(int)_pageControl.currentPage+1];
        }];
        
    }else{
        _pageControl.currentPage = page ;
        [self turnPage];
    }
}
@end
