//
//  CHYaoQingViewController.m
//  LU
//
//  Created by peng jin on 2019/7/17.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHYaoQingViewController.h"
#import "ZCZBarViewController.h"
#import "CHYaoQingListViewController.h"

@interface CHYaoQingViewController () {
    NSString * urlStr;
}
@property (nonatomic , strong) UIScrollView * homeSC;
@property (nonatomic , strong) UIImageView  * IV;
@property (nonatomic , strong) UIImageView  * codeView;
@property (nonatomic , strong) UIImageView  * crownViwe;
@property (nonatomic , strong) UIButton     * listBtn;
@property (nonatomic , strong) UILabel      * levelLB;
@property (nonatomic , strong) UILabel      * peopleNumLB;
@property (nonatomic , strong) UILabel      * tradeNumLB;
@property (nonatomic , strong) UILabel      * perLB;
@property (nonatomic , strong) UILabel      * priceLB;
@property (nonatomic , strong) UIButton      * urlLB;
@end

@implementation CHYaoQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    urlStr = [NSString stringWithFormat:@"http://39.100.77.204/zwtp/index.html?id=%@",[CNManager loadByKey:USERPHONE]];
    [self setupNav];
    [self.view addSubview:self.homeSC];
    // Do any additional setup after loading the view.
}

- (UIScrollView *)homeSC{
    if (!_homeSC) {
        _homeSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        [_homeSC addSubview:self.IV];
        _homeSC.userInteractionEnabled = YES;
    }
    return _homeSC;
}

- (UIImageView *)crownViwe{
    if (!_crownViwe) {
        CGFloat h1 = 773./1125. * MAINWIDTH;
        CGFloat w = MAINWIDTH /1125. * 150. ;
        _crownViwe = [JPMyControl createImageViewWithFrame:CGRectMake(0, 0, w, w) ImageName:@"白银"];
        _crownViwe.center = CGPointMake(MAINWIDTH/2., h1);
    }
    return _crownViwe;
}

- (UILabel *)levelLB{
    if (!_levelLB) {
        _levelLB = [JPMyControl createLabelWithFrame:CGRectMake(0, 0, MAINWIDTH, 20) Font:18 Text:@"白银推广员"];
        _levelLB.textColor = [UIColor orangeColor];
        _levelLB.textAlignment = NSTextAlignmentCenter ;
        CGFloat h = 970./1125. * MAINWIDTH;
        _levelLB.center = CGPointMake(MAINWIDTH/2., h);
        self.peopleNumLB = [[UILabel alloc]init];
        self.tradeNumLB = [[UILabel alloc]init];
        self.perLB = [[UILabel alloc]init];
        self.priceLB = [[UILabel alloc]init];
        CGFloat h1 = 1255./1125. * MAINWIDTH;
        CGFloat h2 = 1445./1125. * MAINWIDTH;
        CGFloat w1 = MAINWIDTH /1125. * 330.;
        CGFloat w2 = MAINWIDTH /1125. * 802.;
        NSMutableArray * arr = [[NSMutableArray alloc]initWithArray: @[self.peopleNumLB,self.tradeNumLB,self.perLB,self.priceLB]];
        for ( int  i = 0 ; i< arr.count; i++) {
            UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(0, 0, 90, 15) Font:15 Text:@"0"];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.textColor = [UIColor orangeColor];
            lb.center = CGPointMake(i/2 ? w2: w1, i%2 ? h2: h1);
            arr[i] = lb;
            [_IV addSubview:lb];
        }
        
    }
    return _levelLB;
}

- (UIImageView *)IV{
    if (!_IV) {
        UIImage * im = [UIImage imageNamed:@"邀请好友"];
        CGFloat h = im.size.height/im.size.width * MAINWIDTH;
        
        _IV = [JPMyControl createImageViewWithFrame:CGRectMake(0, 0, MAINWIDTH, h) ImageName:@"邀请好友"];
        _IV.userInteractionEnabled = YES;
        _homeSC.contentSize = _IV.size;
       
        [_IV addSubview:self.listBtn];
        [_IV addSubview:self.levelLB];
        [_IV addSubview:self.crownViwe];
        [_IV addSubview:self.codeView];
        [_IV addSubview:self.urlLB];
        
        
//        UIImage * img =[MXManager convertViewToImage:vii];
    }
    return _IV;
}

- (UIButton *)listBtn{
    if (!_listBtn) {
        CGFloat h = 48./750. * MAINWIDTH;
        _listBtn = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, 90, 20) Target:self SEL:@selector(listBtnClick) Title:@"邀请记录" ImageName:@"" bgImage:@"" Tag:0];
        _listBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        _listBtn.center = CGPointMake(MAINWIDTH - 33., h);
        _listBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _listBtn.layer.borderWidth = 1.;
        _listBtn.backgroundColor = [UIColor clearColor];
        _listBtn.layer.masksToBounds = YES;
        _listBtn.layer.cornerRadius = _listBtn.height/2.;
        
    }
    return _listBtn;
}

- (UIButton *)urlLB{
    if (!_urlLB) {
        CGFloat h = 1370./750. * MAINWIDTH;
        _urlLB = [JPMyControl createButtonWithFrame:CGRectMake(0, 0, 120, 35) Target:self SEL:@selector(copyClick) Title:@"复制链接" ImageName:@"" bgImage:@"" Tag:0];
        _urlLB.titleLabel.font = [UIFont systemFontOfSize:16];
        _urlLB.center = CGPointMake(MAINWIDTH/2., h);
        _urlLB.backgroundColor = [UIColor blueColor];
        _urlLB.layer.masksToBounds = YES;
        _urlLB.layer.cornerRadius = _urlLB.height/2.;
        
    }
    return _urlLB;
}

- (UIImageView *)codeView{
    if (!_codeView) {
        CGFloat h = 1640./750. * MAINWIDTH;
        _codeView = [JPMyControl createImageViewWithFrame:CGRectMake(0, 0, 120, 120) ImageName:@""];
        _codeView.center = CGPointMake(MAINWIDTH/2., h);
        [ZCZBarViewController createImageWithImageView:_codeView String:urlStr  scale:5.];
    }
    return _codeView;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"邀请有礼";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = moreItem;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)copyClick{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = urlStr;
    [CNManager showWindowAlert:@"链接复制成功"];
}

- (void)listBtnClick{
    CHYaoQingListViewController *vc = [[CHYaoQingListViewController alloc]init];
    vc.title = @"邀请有礼";
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
