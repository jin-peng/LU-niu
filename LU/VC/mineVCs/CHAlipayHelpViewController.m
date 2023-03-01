//
//  CHAlipayHelpViewController.m
//  LU
//
//  Created by peng jin on 2019/7/2.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHAlipayHelpViewController.h"

@interface CHAlipayHelpViewController ()
@property (nonatomic , strong)UIScrollView * WX;
@property (nonatomic , strong)UIScrollView * Alipay;
@property (nonatomic , strong)UILabel      * help;
@property (nonatomic , strong)UIImageView  * codeVI;
@end

@implementation CHAlipayHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:_isWX? self.WX:self.Alipay];
    // Do any additional setup after loading the view.
    self.help = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT - 120, MAINWIDTH, 120) Font:10 Text:[NSString stringWithFormat: @"到账时间\n周一至周五9:00-17:30（10分钟内到账）\n17：30以后（次日09:20前到账）\n如急需到账请拨打电话：n%@",[CHConfig hotPhoneNumber]]];
    _help.numberOfLines = 0;
    _help.textAlignment = NSTextAlignmentCenter;
    _help.textColor = UIColorFromRGB(0x999999);
    [self.view addSubview:self.help];
}

- (UIScrollView *)WX{
    if (!_WX) {
        _WX = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        NSArray * arr = @[@"    第一步：保存二维码到手机相册",@"    第二步：手机打微信，识别二维码图片"];
        
        for (int i = 0; i< arr.count; i++) {
            UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(0, i * (30 + 80) , MAINWIDTH, 30) Font:14 Text:arr[i]];
            lb.backgroundColor = UIColorFromRGB(0xdfdfdf);
            [_WX addSubview:lb];
            if (i == 0) {
                UIImageView * vi = [JPMyControl createImageViewWithFrame:CGRectMake(10, lb.y + lb.height + 25, 96, 30) ImageName:@"微信支付logo"];
                UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(vi.x + vi.width +15, vi.y-2., MAINWIDTH - vi.x - vi.width - 45, vi.height) Font:14 Text:[NSString stringWithFormat:@"微信账号：%@",_infoDic[@"account_no"]]];
                lb2.numberOfLines = 2;
                [_WX addSubview:vi];
                [_WX addSubview:lb2];
            }
            if (i == 1) {
                NSArray * imgArr = @[@"微信图标（第一步）",@"第二步",@"第三步",@"第四步",@"第五步"];
                NSArray * textArr = @[@"打开微信",@"右上角加号",@"扫一扫",@"右上角...",@"相册选取"];
                CGFloat h = (MAINWIDTH - 60) / 5.;
                for (int j =0 ; j<imgArr.count; j++) {
                    UIImageView * vi = [JPMyControl createImageViewWithFrame:CGRectMake(10 + (h + 10.) * j , lb.y + lb.height + 20, h , h) ImageName:imgArr[j]];
                    UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(h/2. + h * 2.* j   , vi.y + vi.height + 20, MAINWIDTH/2., 14) Font:12 Text:textArr[j]];
                    lb2.center = CGPointMake(  vi.centerX ,lb2.y + lb2.height/2.);
                    lb2.textAlignment =NSTextAlignmentCenter;
                    [_WX addSubview:vi];
                    [_WX addSubview:lb2];
                    if (j== 1) {
                        UILabel * lb3 = [JPMyControl createLabelWithFrame:CGRectMake(0   , lb2.y + lb2.height, MAINWIDTH, 80) Font:11 Text:@"请在备注中留下您在平台注册的用户名和手机号\n以便财务核对及时入账\n完成后手机登录APP查看账户余额"];
                        lb3.textColor = UIColorFromRGB(0x666666);
                        lb3.numberOfLines = 0;
                        lb3.textAlignment = NSTextAlignmentCenter;
                        [_WX addSubview:lb3];
                        UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(15, lb3.y + lb3.height + 5, MAINWIDTH - 30, 35) Target:self SEL:@selector(copyImg) Title:@"保存二维码到相册" ImageName:@"" bgImage:@"" Tag:0];
                        btn.backgroundColor = [UIColor redColor];
                        btn.layer.masksToBounds = YES;
                        btn.layer.cornerRadius = 6.;
                        [_WX addSubview:btn];
                        _codeVI = [[UIImageView alloc]initWithFrame:CGRectMake(40, btn.y + btn.height + 10, MAINWIDTH - 80, MAINWIDTH - 80)];
                        [_WX addSubview:self.codeVI];
                        [_codeVI sd_setImageWithURL:[NSURL URLWithString:_infoDic[@"pic"]]];
                        _WX.contentSize = CGSizeMake(0, _codeVI.y + _codeVI.height + 120);
                    }
                }
                
            }
        }
        
    }
    
    return _WX;
}

- (UIScrollView *)Alipay{
    if (!_Alipay) {
        _Alipay = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight)];
        NSArray * arr = @[@"    第一步：请复制或者牢记我们的支付宝账号",@"    第二步：手机打开支付宝，快速转账"];
        
        for (int i = 0; i< arr.count; i++) {
            UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(0, i * (30 + 80) , MAINWIDTH, 30) Font:14 Text:arr[i]];
            lb.backgroundColor = UIColorFromRGB(0xdfdfdf);
            [_Alipay addSubview:lb];
            if (i == 0) {
                UIImageView * vi = [JPMyControl createImageViewWithFrame:CGRectMake(10, lb.y + lb.height + 20, 80, 40) ImageName:@"支付宝支付logo"];
                vi.contentMode = UIViewContentModeScaleAspectFit;
                UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(vi.x + vi.width +15, vi.y-2., MAINWIDTH - vi.x - vi.width - 25, vi.height) Font:14 Text:[NSString stringWithFormat:@"支付宝账号：%@\n%@",_infoDic[@"account_no"],_infoDic[@"bank_name"]]];
                lb2.numberOfLines = 2;
                [_Alipay addSubview:vi];
                [_Alipay addSubview:lb2];
            }
            if (i == 1) {
                NSArray * imgArr = @[@"支付宝图标",@"转账icon"];
                NSArray * textArr = @[@"打开手机支付宝",@"选择转账到支付宝账号"];
                CGFloat h = MAINWIDTH/5.;
                for (int j =0 ; j<imgArr.count; j++) {
                    UIImageView * vi = [JPMyControl createImageViewWithFrame:CGRectMake(h + h * j * 2, lb.y + lb.height + 20, h , h) ImageName:imgArr[j]];
                    UILabel * lb2 = [JPMyControl createLabelWithFrame:CGRectMake(h/2. + h * 2.* j   , vi.y + vi.height + 20, MAINWIDTH/2., 14) Font:12 Text:textArr[j]];
                    lb2.center = CGPointMake(  vi.centerX ,lb2.y + lb2.height/2.);
                    lb2.textAlignment =NSTextAlignmentCenter;
                    [_Alipay addSubview:vi];
                    [_Alipay addSubview:lb2];
                    if (j== 1) {
                        UILabel * lb3 = [JPMyControl createLabelWithFrame:CGRectMake(0   , lb2.y + lb2.height, MAINWIDTH, 40) Font:12 Text:@"完成后手机登录APP查看账户余额"];
                        lb3.textAlignment = NSTextAlignmentCenter;
                        [_Alipay addSubview:lb3];
                        UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake(15, lb3.y + lb3.height + 5, MAINWIDTH - 30, 35) Target:self SEL:@selector(copyName) Title:@"复制支付宝账号" ImageName:@"" bgImage:@"" Tag:0];
                        btn.backgroundColor = [UIColor redColor];
                        btn.layer.masksToBounds = YES;
                        btn.layer.cornerRadius = 6.;
                        [_Alipay addSubview:btn];
                    }
                }
                
            }
        }
    }
    return _Alipay;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= _isWX?@"微信扫码支付":@"支付宝转账";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
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

- (void)copyName{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.infoDic[@"account_no"];
    [CNManager showWindowAlert:@"账号复制成功"];
}

- (void)copyImg{
    [self saveImageToPhotos:_codeVI.image];
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
//    NSString *msg = nil ;
    if(error != NULL){
        [CNManager showWindowAlert:@"保存图片失败"] ;
    }else{
        [CNManager showWindowAlert:@"保存图片成功"] ;
    }
    
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
