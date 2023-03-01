//
//  MXUserSuggestionViewController.m
//  mengX
//
//  Created by bjjl on 15/7/7.
//  Copyright (c) 2015年 金鹏. All rights reserved.
//

#import "MXUserSuggestionViewController.h"
#import "SZTextView.h"
#import "CHConfig.h"

#define kMaxInputLength 200
@interface MXUserSuggestionViewController ()<UITextViewDelegate,UIAlertViewDelegate>{
    SZTextView *_text_SignatureTextView;
    UILabel *lab;
    UIView * redLine;
    NSInteger questNum ;
}
@property (nonatomic, strong)UIView *headerView;
//@property (nonatomic, strong)UIButton * questBtn;
//@property (nonatomic, strong)UIButton * yjBtn;
//@property (nonatomic, strong)UIButton * tsBtn;

@property (nonatomic, strong)UILabel *lab_TipsLabel;
@property (nonatomic, strong)UIButton * sendBtn;
@property (nonatomic, strong)UITextField * phoneTf;

@end

@implementation MXUserSuggestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    questNum = 1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title = @"意见与反馈";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self setupBarButtonItems];
    [self makeUI];
    [self.view addSubview:self.sendBtn];
    // Do any additional setup after loading the view.
}
- (void)setupNav{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"back-btn"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    UIButton * _editBtn2=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick1) Title:@"客服热线" ImageName:@"" bgImage:@"" Tag:0];
    _editBtn2.titleLabel.font=[UIFont systemFontOfSize:14];
    [_editBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*right2=[[UIBarButtonItem alloc]initWithCustomView:_editBtn2];
    //    _editBtn2.hidden=YES;
    right2.style=UIBarButtonItemStylePlain;
//    _editBtn.alpha=.9;
    _editBtn2.alpha=.9;
    self.navigationItem.rightBarButtonItem=right2;
}

- (void)setClick1{
    NSString *allString = [NSString stringWithFormat:@"tel:%@",[CHConfig hotPhoneNumber]];
    
    [[UIApplication sharedApplication] openURL:allString];
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [JPMyControl createButtonWithFrame:CGRectMake(22, _text_SignatureTextView.frame.origin.y + _text_SignatureTextView.frame.size.height + 42 + 65, MAINWIDTH - 44, 42) Target:self SEL:@selector(finishDown) Title:@"提交" ImageName:@"" bgImage:@"" Tag:0];
        _sendBtn.backgroundColor = UIColorFromRGB(0xd3d3d3);
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.layer.masksToBounds = YES;
    }
    return _sendBtn;
}

- (void)setupBarButtonItems {
//    self.title=@"意见反馈";//改为存在本地的用户昵称;
//    self.view.backgroundColor=UIColorFromRGB(0xdfdfdf);
//    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    editButton.frame = CGRectMake(10, 5, 40, 34);
//    [editButton setTitle:@"发送" forState:UIControlStateNormal];
//    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [editButton addTarget:self action:@selector(finishDown) forControlEvents:UIControlEventTouchUpInside];
//    editButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
//    //    editButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:editButton];
//    //    editButton.hidden=YES;
//    right.style=UIBarButtonItemStylePlain;
//    self.navigationItem.rightBarButtonItem=right;
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
//    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [backButton setImage:[UIImage imageNamed:@"photo_title_btn_back"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
//    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    moreItem.style = UIBarButtonItemStylePlain;
//    self.navigationItem.leftBarButtonItem = moreItem;
}

#pragma mark 点击完成的方法
- (void)finishDown{
    
    if (!_text_SignatureTextView.text.length) {
        [CNManager showWindowAlert:@"反馈内容不能为空"];
        return;
    }
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",questNum==1?@"问题咨询":(questNum==2?@"意见反馈":@"投诉")] forKey:@"type"];
    [dataDict setObject:[CNManager loadByKey:USERPHONE] forKey:@"phone"];
    [dataDict setObject:_text_SignatureTextView.text forKey:@"content"];
    
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/feedback/send",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [weakself.tableView.mj_header endRefreshing];
        //        [weakself.tableView.mj_footer endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                
//                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
//                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
//                if ([data length]&&[ref length]&&(data)&&(ref)) {
//                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
//                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
//
//                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                
                    [CNManager showWindowAlert:@"提交成功"];
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        
        //        NSLog(@"error slider");
    }];
    
    [CNManager showWindowAlert:@"提交成功"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}

- (void)timerFired{
    lab.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回的方法
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)phoneTf{
    if (!_phoneTf) {
        _phoneTf = [JPMyControl createTextFieldWithFrame:CGRectMake(15, StatusBarAndNavigationBarHeight + 10 + 157 + 63 + 9, MAINWIDTH -30, 35) Font:13 TextColor:UIColorFromRGB(0x929292) LeftImageName:@"" RightImageName:@"" BgImageName:@"" PlaceHolder:@"留下您的手机/QQ/邮箱，方便我们联系（选填）" sucureTextEntry:NO];
//        UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(0, _phoneTf.frame.origin.y + _phoneTf.frame.size.height + 12, MAINWIDTH, 10) Font:10 Text:@"您的联系方式有助于我们沟通和解决方案,仅工作人员可见"];
//        lb.textAlignment = NSTextAlignmentCenter;
//        lb.textColor = UIColorFromRGB(0xbfbfbf);
//        [self.view addSubview:lb];
        
        UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, _phoneTf.frame.origin.y , MAINWIDTH, _phoneTf.frame.size.height) bgColor:UIColorFromRGB(0xffffff)];
        [self.view addSubview:line];
        
    }
    return _phoneTf;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+5, MAINWIDTH, 30) bgColor:[UIColor whiteColor]];
        NSArray * arr = @[@"问题咨询",@"意见反馈",@"投诉"];
        for (int i = 0 ; i<3; i++) {
            UIButton * btn = [JPMyControl createButtonWithFrame:CGRectMake( i * MAINWIDTH/3., 0, MAINWIDTH/3., _headerView.height) Target:self SEL:@selector(headerClick:) Title:arr[i] ImageName:@"" bgImage:@"" Tag:100+i];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            if (i == 0) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [_headerView addSubview:btn];
        }
        redLine = [JPMyControl createViewWithFrame:CGRectMake(MAINWIDTH/12., _headerView.height - 3., MAINWIDTH/6., 3.) bgColor:[UIColor redColor]];
        [_headerView addSubview:redLine];
        
    }
    return _headerView;
}

- (void)makeUI{
    [self.view addSubview:self.headerView];
    UIView * bak = [JPMyControl createViewWithFrame:CGRectMake(0 , StatusBarAndNavigationBarHeight + 10 + _headerView.height , self.view.frame.size.width, 157 + 63) bgColor:[UIColor whiteColor]];
    [self.view addSubview:bak];
    _text_SignatureTextView = [SZTextView new];
    _text_SignatureTextView.bounces = NO;
    _text_SignatureTextView.scrollsToTop = YES;
    _text_SignatureTextView.scrollEnabled = YES;
    _text_SignatureTextView.delegate = self;
    _text_SignatureTextView.returnKeyType = UIReturnKeyDone;
    _text_SignatureTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _text_SignatureTextView.textAlignment = NSTextAlignmentLeft;
    _text_SignatureTextView.frame = CGRectMake(10 , bak.y , self.view.frame.size.width-20, 195);
    _text_SignatureTextView.backgroundColor = UIColorFromRGB(0xffffff);
    _text_SignatureTextView.placeholder = @"请填写你的意见或建议，我们将为你不断改进（必填）";
    _text_SignatureTextView.placeholderTextColor = [UIColor lightGrayColor];
    _text_SignatureTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
//    UIView * line = [JPMyControl createViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 8 , MAINWIDTH, 145) bgColor:UIColorFromRGB(0xffffff)];
//    [self.view addSubview:line];
    [self.view addSubview:_text_SignatureTextView];
    
    
//    UIView * line1 = [JPMyControl createViewWithFrame:CGRectMake(0, _text_SignatureTextView.frame.origin.y - 2, MAINWIDTH, .5) bgColor:UIColorFromRGB(0xb0b0b0)];
//    [self.view addSubview:line1];
    
    _lab_TipsLabel = [[UILabel alloc] init];
    _lab_TipsLabel.textAlignment = NSTextAlignmentRight;
    _lab_TipsLabel.textColor = [UIColor grayColor];
    CGFloat tWidth = 70;
    CGFloat tMarginLeft = 10;
    CGFloat tMarginTop = (_text_SignatureTextView.frame.origin.y + _text_SignatureTextView.frame.size.height);
    _lab_TipsLabel.frame = CGRectMake(tMarginLeft, tMarginTop, tWidth, 20);
    [self.view addSubview:_lab_TipsLabel];
    
//    [self.view addSubview:self.phoneTf];
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _lab_TipsLabel.text = [NSString stringWithFormat:@"%d/%d", _text_SignatureTextView.text.length,kMaxInputLength];
}

-(void)textViewDidChange:(UITextView *)obj
{
    UITextView *textField = (UITextView *)obj;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > kMaxInputLength) {
                textField.text = [toBeString substringToIndex:kMaxInputLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxInputLength){
            textField.text = [toBeString substringToIndex:kMaxInputLength];
        }
    }
    if (toBeString.length > kMaxInputLength) {
//        NSLog(@"%@",[NSString stringWithFormat:@"还能输入0个字"]);
        _lab_TipsLabel.text = @"200/200";
    }else{
        //        NSLog(@"%@",[NSString stringWithFormat:@"还能输入%d个字",kMaxInputLength-toBeString.length]);
        _lab_TipsLabel.text = [NSString stringWithFormat:@"%d/%d", _text_SignatureTextView.text.length,kMaxInputLength];
    }
    if (toBeString.length) {
        _sendBtn.backgroundColor = ARUITintColor;
    }else{
        _sendBtn.backgroundColor = UIColorFromRGB(0xd3d3d3);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self finishDown];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)headerClick:(UIButton *)btn{
    if (questNum == btn.tag - 99) {
        return;
    }
    questNum = btn.tag - 99;
    for (int i = 0; i < 3; i++) {
        UIButton * newBtn = (UIButton *)[_headerView viewWithTag:100+i];
        if (i == btn.tag - 100) {
            [newBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:.3 animations:^{
                self->redLine.frame=CGRectMake(MAINWIDTH/12.+ MAINWIDTH/3.* i, self->redLine.y  ,self->redLine.width, self->redLine.height);
            }];
        }else{
            [newBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
