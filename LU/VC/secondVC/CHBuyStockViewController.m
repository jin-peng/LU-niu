//
//  CHBuyStockViewController.m
//  LU
//
//  Created by peng jin on 2019/6/20.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHBuyStockViewController.h"
#import "CHGetStockNum.h"
#import "CHPayPageViewController.h"
#import "CHWebDetailViewController.h"

@interface CHBuyStockViewController () <UITextFieldDelegate> {
    CGFloat buyNum;
    CGFloat buyMoney;
    CGFloat minNum;
    CGFloat zhiyingMax;
    CGFloat zhisunMax;
    NSString * zongji;
    CGFloat buyPrice;
}
@property (nonatomic,strong) UILabel * nameLb;
@property (nonatomic,strong) UILabel * stockNoLb;

@property (nonatomic,strong) UILabel * price;

@property (nonatomic,strong) UILabel * lastMoney;
@property (nonatomic,strong) UILabel * moneyNum;
@property (nonatomic,strong) UIButton * pay;

@property (nonatomic,strong) UILabel * shijiamairu;
@property (nonatomic,strong) UILabel * yuji;

@property (nonatomic,strong) UILabel * shuliangLb;
@property (nonatomic,strong) UITextField * stockNum;
@property (nonatomic,strong) UIButton * addBtn;
@property (nonatomic,strong) UIButton * subBtn;
@property (nonatomic,strong) UIButton * helpBtn;

@property (nonatomic,strong) UILabel * cfzy;
@property (nonatomic,strong) UITextField * setZY;

@property (nonatomic,strong) UITextField * setZS;
@property (nonatomic,strong) UILabel * cfzs;

@property (nonatomic,strong) UILabel * fenCheng;

@property (nonatomic,strong) UILabel * zhonghe;

@property (nonatomic,strong) UILabel * baozhengjin;

@property (nonatomic,strong) UILabel * allPayNum;
@property (nonatomic,strong) UILabel * fudongshuoming;

@property (nonatomic,strong) UIButton * buyBtn;
@property (nonatomic,strong) UIButton * xieyiBtn;
//@property (nonatomic,strong) UILabel * xieyi;


@end

@implementation CHBuyStockViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshAll];
}

- (void)refrshUI{
    _price.text = [NSString stringWithFormat:@"股价  %.2f        涨幅  %.2f        跌涨  %.2f",[_strckPriceDic[@"price"] floatValue],[_strckPriceDic[@"per"] floatValue],[_strckPriceDic[@"change"] floatValue]];
    _moneyNum.text = [NSString stringWithFormat:@"%.2f", _userLastMoney];
    buyNum = 0;
    buyMoney = 0;
    minNum = 0;
    while (buyMoney<[_userPlan[@"cc_min"] floatValue]) {
        minNum++;
        buyMoney = minNum * 100 * [_strckPriceDic[@"price"] floatValue];
    }
    buyNum = minNum;
    [self refreshPrice];
//    _stockNum.text = [NSString stringWithFormat:@"%.0f",minNum * 100];
}

- (void)refreshPrice{
    if (buyNum<minNum) {
        buyNum =minNum;
    }
    buyPrice = [_strckPriceDic[@"price"] floatValue];
    buyMoney = buyNum * 100 * [_strckPriceDic[@"price"] floatValue];
    _stockNum.text = [NSString stringWithFormat:@"%.0f", buyNum * 100];
    _yuji.text = [NSString stringWithFormat:@"预计买入市值%.2f元",buyMoney];
    zhiyingMax = buyPrice * (1.+[_userPlan[@"zy_max"] floatValue]/100.);
    zhisunMax = buyPrice * (1.-[_userPlan[@"zs_max"] floatValue]/100.);
    _setZY.text = [NSString stringWithFormat:@"%.2f",zhiyingMax];
    _setZS.text = [NSString stringWithFormat:@"%.2f",zhisunMax];
    _zhonghe.text = [NSString stringWithFormat:@"综合管理费        %.2f元",(buyMoney/10000.)*[_userPlan[@"gl_money"] floatValue] * ([_userPlan[@"yj_place"] floatValue]/100.)];
    _fenCheng.text = [NSString stringWithFormat:@"盈利分成            %@%%",_userPlan[@"ylfc"]];
    _baozhengjin.text = [NSString stringWithFormat:@"履约保证金        %.2f元",buyMoney/[_userPlan[@"pry"]floatValue] * ([_userPlan[@"yj_place"] floatValue]/100.)];
    zongji = [NSString stringWithFormat: @"%.2f",(buyMoney/10000.)*[_userPlan[@"gl_money"] floatValue] + buyMoney/[_userPlan[@"pry"]floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"总计     %.2f  元",((buyMoney/10000.)*[_userPlan[@"gl_money"] floatValue] + buyMoney/[_userPlan[@"pry"]floatValue]) * ([_userPlan[@"yj_place"] floatValue]/100.)]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str.length - 4)];
    _allPayNum.attributedText = str;
    NSString * fu= [NSString stringWithFormat:@"-%.2f",buyMoney * ([_userPlan[@"dy_cond"] floatValue]/100.)];
    NSString * dy= [NSString stringWithFormat:@"%.2f",(buyMoney/10000.)*[_userPlan[@"dy_money"] floatValue]];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"浮动盈亏大于%@元自动递延，递延费%@元/天",fu,dy]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, fu.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(15 + fu.length, dy.length)];
    _fudongshuoming.attributedText = str1;
}


- (void)refreshAll{
    WEAKSELF;
    __block NSInteger x = 0;
    [CHGetStockNum getUserPlan:[CNManager loadByKey:USERPHONE] Success:^(NSDictionary * _Nonnull planDic) {
        weakself.userPlan = planDic;
        x++;
        if (x>=3) {
            [weakself refrshUI];
        }
    }];
    [CHGetStockNum getStock:_stockDic[@"request_code"] Success:^(NSDictionary * _Nonnull stockDic) {
        weakself.strckPriceDic = stockDic;
        x++;
        if (x>=3) {
            [weakself refrshUI];
        }
//        [weakself setupUI];
    }];
    [CHGetStockNum getUserInfobyPhone:[CNManager loadByKey:USERPHONE] Success:^(NSDictionary * _Nonnull userDic) {
        weakself.userLastMoney = [userDic[@"money"] floatValue];
        x++;
        if (x>=3) {
            [weakself refrshUI];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    WEAKSELF;
    [CHGetStockNum getStock:_stockDic[@"request_code"] Success:^(NSDictionary * _Nonnull stockDic) {
        weakself.strckPriceDic = stockDic;
        [weakself setupUI];
    }];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [self.view addSubview: self.nameLb];
    [self.view addSubview:self.stockNoLb];
    [self.view addSubview:self.price];
    [self.view addSubview:self.lastMoney];
    [self.view addSubview:self.moneyNum];
    [self.view addSubview:self.pay];
    
    [self.view addSubview:self.shijiamairu];
    [self.view addSubview:self.yuji];
    
    [self.view addSubview:self.shuliangLb];
    [self.view addSubview:self.subBtn];
    
    [self.view addSubview:self.stockNum];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.helpBtn];
    
    [self.view addSubview:self.cfzy];
    [self.view addSubview:self.setZY];
    [self.view addSubview:self.cfzs];
    [self.view addSubview:self.setZS];
    
    [self.view addSubview:self.fenCheng];
    
    [self.view addSubview:self.zhonghe];
    
    [self.view addSubview:self.baozhengjin];
    
    [self.view addSubview:self.allPayNum];
    [self.view addSubview:self.fudongshuoming];
    
    [self.view addSubview:self.buyBtn];
    [self.view addSubview:self.xieyiBtn];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_stockNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_setZY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePassWord) name:UITextFieldTextDidChangeNotification object:_setZS];
}

- (UIButton *)xieyiBtn{
    if (!_xieyiBtn) {
        _xieyiBtn = [JPMyControl createButtonWithFrame:CGRectMake(_nameLb.x, _buyBtn.y+_buyBtn.height, MAINWIDTH - _nameLb.x*2, 20) Target:self SEL:@selector(xieyiClick) Title:@"买入" ImageName:@"" bgImage:@"" Tag:0];
        [_xieyiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_xieyiBtn setTitle:@"发起策略代表您已经充分了解并同意《策略合作协议》相关内容" forState:UIControlStateNormal];
        _xieyiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    return _xieyiBtn;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [JPMyControl createButtonWithFrame:CGRectMake(_nameLb.x, _fudongshuoming.y+_fudongshuoming.height +10, MAINWIDTH - _nameLb.x*2, 40) Target:self SEL:@selector(buyBtnClick) Title:@"买入" ImageName:@"" bgImage:@"" Tag:0];
        _buyBtn.backgroundColor = [UIColor redColor];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 6.;
    }
    return _buyBtn;
}

- (UILabel *)fudongshuoming{
    if (!_fudongshuoming) {
        _fudongshuoming = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _allPayNum.y+_allPayNum.height, MAINWIDTH - 40, 15) Font:10 Text:@"浮动盈亏大于"];
    }
    return _fudongshuoming;
}

- (UILabel *)allPayNum{
    if (!_allPayNum) {
        _allPayNum = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _baozhengjin.y+_baozhengjin.height+5, MAINWIDTH - 40, 30) Font:20 Text:@"总计"];
    }
    return _allPayNum;
}

- (UILabel *)fenCheng{
    if (!_fenCheng) {
        _fenCheng = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _cfzs.y+_cfzs.height+5, MAINWIDTH - 40, 30) Font:16 Text:@"盈利分成"];
//        _fenCheng.textColor = UIColorFromRGB(0x888888);
    }
    return _fenCheng;
}

- (UILabel *)zhonghe{
    if (!_zhonghe) {
        _zhonghe = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _fenCheng.y+_fenCheng.height+5, MAINWIDTH - 40, 30) Font:16 Text:@"综合管理费"];
//        _zhonghe.textColor = UIColorFromRGB(0x888888);
    }
    return _zhonghe;
}
- (UILabel *)baozhengjin{
    if (!_baozhengjin) {
        _baozhengjin = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _zhonghe.y+_zhonghe.height+5, MAINWIDTH - 40, 30) Font:16 Text:@"履约保证金"];
//        _baozhengjin.textColor = UIColorFromRGB(0x888888);
    }
    return _baozhengjin;
}

- (UITextField *)setZY{
    if (!_setZY) {
        _setZY = [JPMyControl createTextFieldWithFrame:CGRectMake(_cfzy.x + _cfzy.width + 25 , _cfzy.y, 140 * MULTIPLE, _subBtn.height) Font:14 TextColor:UIColorFromRGB(0x999999) LeftImageName:@"" RightImageName:@"" BgImageName:@""];
        _setZY.backgroundColor = UIColorFromRGB(0xdfdfdf);
//        _setZY.layer.masksToBounds = YES;
//        _setZY.layer.cornerRadius = 3.;
        _setZY.delegate = self;
        _setZY.keyboardType = UIKeyboardTypeDecimalPad;
        _setZY.textColor = [UIColor redColor];
        _setZY.textAlignment = NSTextAlignmentCenter;
        UILabel *lb =[JPMyControl createLabelWithFrame:CGRectMake(-15, 0, 15, _setZY.height) Font:18 Text:@"+"];
        lb.textColor = [UIColor redColor];
//        [_setZY addSubview:lb];
    }
    return _setZY;
}

- (UITextField *)setZS{
    if (!_setZS) {
        _setZS = [JPMyControl createTextFieldWithFrame:CGRectMake(_cfzs.x + _cfzs.width + 25 , _cfzs.y, 140 * MULTIPLE, _subBtn.height) Font:14 TextColor:UIColorFromRGB(0x999999) LeftImageName:@"" RightImageName:@"" BgImageName:@""];
        _setZS.backgroundColor = UIColorFromRGB(0xdfdfdf);
//        _setZS.layer.masksToBounds = YES;
//        _setZS.layer.cornerRadius = 3.;
        _setZS.delegate = self;
        _setZS.keyboardType = UIKeyboardTypeDecimalPad;
        _setZS.textColor = [UIColor redColor];
        _setZS.textAlignment = NSTextAlignmentCenter;
        UILabel *lb =[JPMyControl createLabelWithFrame:CGRectMake(-15, 0, 15, _setZY.height) Font:18 Text:@"-"];
        lb.textColor = [UIColor redColor];
//        [_setZS addSubview:lb];
    }
    return _setZS;
}

- (UILabel *)cfzs{
    if (!_cfzs) {
        _cfzs = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _cfzy.y+_cfzy.height + 10, 80, 30) Font:16 Text:@"触发止损"];
    }
    return _cfzs;
}

- (UILabel *)cfzy{
    if (!_cfzy) {
        _cfzy = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _shuliangLb.y+_shuliangLb.height + 10, 80, 30) Font:16 Text:@"触发止盈"];
    }
    return _cfzy;
}


- (UILabel *)shuliangLb{
    if (!_shuliangLb) {
        _shuliangLb = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _shijiamairu.y+_shijiamairu.height + 20, 50, 30) Font:16 Text:@"数量"];
    }
    return _shuliangLb;
}

- (UITextField *)stockNum{
    if (!_stockNum) {
        _stockNum = [JPMyControl createTextFieldWithFrame:CGRectMake(_subBtn.x + _subBtn.width + 5 , _subBtn.y, 120 * MULTIPLE, _subBtn.height) Font:14 TextColor:UIColorFromRGB(0x999999) LeftImageName:@"" RightImageName:@"" BgImageName:@""];
        _stockNum.delegate = self;
        _stockNum.backgroundColor = UIColorFromRGB(0xdfdfdf);
        _stockNum.layer.masksToBounds = YES;
        _stockNum.layer.cornerRadius = 3.;
        _stockNum.keyboardType = UIKeyboardTypeNumberPad;
        _stockNum.textAlignment = NSTextAlignmentCenter;
    }
    return _stockNum;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [JPMyControl createButtonWithFrame:CGRectMake(_stockNum.x + _stockNum.width + 5, _subBtn.y, _subBtn.width, _subBtn.height) Target:self SEL:@selector(subBtnClick:) Title:@"+" ImageName:@"" bgImage:@"" Tag:101];
        _addBtn.backgroundColor = UIColorFromRGB(0xdfdfdf);
        [_addBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 3.;
    }
    return _addBtn;
}

- (UIButton *)helpBtn{
    if (!_helpBtn) {
        _helpBtn = [JPMyControl createButtonWithFrame:CGRectMake(_addBtn.x + _addBtn.width + 5, _addBtn.y + 3, 20, 20) Target:self SEL:@selector(helpBtnClick) Title:@"?" ImageName:@"" bgImage:@"" Tag:101];
        _helpBtn.backgroundColor = UIColorFromRGB(0xcfcfcf);
        [_helpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _helpBtn.layer.masksToBounds = YES;
        _helpBtn.layer.cornerRadius = _helpBtn.width/2.;
    }
    return _helpBtn;
}

- (UIButton *)subBtn{
    if (!_subBtn) {
        _subBtn = [JPMyControl createButtonWithFrame:CGRectMake(_shuliangLb.x + _shuliangLb.width, _shuliangLb.y, 30, 30) Target:self SEL:@selector(subBtnClick:) Title:@"-" ImageName:@"" bgImage:@"" Tag:100];
        _subBtn.backgroundColor = UIColorFromRGB(0xdfdfdf);
        [_subBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        _subBtn.layer.masksToBounds = YES;
        _subBtn.layer.cornerRadius = 3.;
    }
    return _subBtn;
}

- (UILabel *)shijiamairu{
    if (!_shijiamairu) {
        _shijiamairu = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _lastMoney.y+_lastMoney.height + 30, 100, 20) Font:16 Text:@"市价买入"];
    }
    return _shijiamairu;
}

- (UILabel *)yuji{
    if (!_yuji) {
        _yuji = [JPMyControl createLabelWithFrame:CGRectMake(_lastMoney.x+_lastMoney.width, _shijiamairu.y, MAINWIDTH - _lastMoney.x - _lastMoney.width - 20, 20) Font:14 Text:[NSString stringWithFormat:@"预计买入市值0元"]];
        _yuji.textColor = [UIColor redColor];
    }
    return _yuji;
}

- (UIButton *)pay{
    if (!_pay) {
        _pay = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH - 90, _lastMoney.y, 70, 20) Target:self SEL:@selector(payClick) Title:@"充值" ImageName:@"" bgImage:@"" Tag:0];
        _pay.backgroundColor = [UIColor redColor];
        _pay.titleLabel.font = [UIFont systemFontOfSize:14];
        _pay.layer.masksToBounds = YES;
        _pay.layer.cornerRadius = 3.;
    }
    return _pay;
}

- (UILabel *)moneyNum{
    if (!_moneyNum) {
        _moneyNum = [JPMyControl createLabelWithFrame:CGRectMake(_lastMoney.x+_lastMoney.width, _lastMoney.y, MAINWIDTH - _lastMoney.x - _lastMoney.width - 90, 20) Font:17 Text:[NSString stringWithFormat:@"%.2f",[[CNManager loadByKey:MONEY] floatValue]]];
        _moneyNum.textColor = [UIColor redColor];
    }
    return _moneyNum;
}

- (UILabel *)lastMoney{
    if (!_lastMoney) {
        _lastMoney = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _price.y+_price.height + 20, 100, 20) Font:16 Text:@"账户余额"];
    }
    return _lastMoney;
}

- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [JPMyControl createLabelWithFrame:CGRectMake(15, StatusBarAndNavigationBarHeight + 5, 120, 20) Font:20 Text:_strckPriceDic[@"name"]];
    }
    return _nameLb;
}

- (UILabel *)stockNoLb{
    if (!_stockNoLb) {
        _stockNoLb = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x + _nameLb.width , _nameLb.y + 5, 120, 14) Font:14 Text:_stockDic[@"code"]];
        _stockNoLb.textColor = UIColorFromRGB(0x999999);
    }
    return _stockNoLb;
}

- (UILabel *)price{
    if (!_price) {
        _price = [JPMyControl createLabelWithFrame:CGRectMake(_nameLb.x, _nameLb.y+_nameLb.height+ 5, MAINWIDTH - 40, 20) Font:12 Text:[NSString stringWithFormat:@"股价  %.2f        涨幅  %.2f        跌涨  %.2f",[_strckPriceDic[@"price"] floatValue],[_strckPriceDic[@"per"] floatValue],[_strckPriceDic[@"change"] floatValue]]];
        _price.textColor = UIColorFromRGB(0x999999);
    }
    return _price;
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    self.title= @"T+1策略确认";
    
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

- (void)payClick{
    CHPayPageViewController * vc = [[CHPayPageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)subBtnClick:(UIButton *)btn{
    if (btn.tag - 100) {
        buyNum ++;
        while (_userLastMoney < buyNum * 100 * [_strckPriceDic[@"price"] floatValue]) {
            buyNum--;
        }
    }else{
        buyNum --;
    }
    
    [self refreshPrice];
}


- (void)helpBtnClick{
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最低1万元市值起买，默认数量为所选股需要购入的最少数量，可手动增加+号点一次增加100股，也可直接输入数量，数量必须为100的整数倍。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [al show];
}

- (void)judgePassWord1{
    self.stockNum.text=[self.stockNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger x = [_stockNum.text integerValue]/100;
    if (x < minNum) {
        buyNum = minNum;
        [CNManager showWindowAlert:[NSString stringWithFormat: @"最小点买总价不能小于10000元,最少买入%.0f股",minNum * 100]];
    }else{
        buyNum = (CGFloat)x;
    }
    [self refreshPrice];
}

- (void)judgePassWord{
    //先去掉两端的空格
//    self.stockNum.text=[self.stockNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.setZS.text=[self.setZS.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.setZY.text=[self.setZY.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    if(_setZY.text.length==0){
//        _setZY.text = @"0";
//    }
//    if(_setZS.text.length==0){
//        _setZS.text = @"0";
//    }
    
}

- (void)buyBtnClick{
    NSInteger x = [_stockNum.text integerValue]/100;
    if (x < minNum) {
        buyNum = minNum;
        [CNManager showWindowAlert:@"您的输入的数量有误，请重新输入"];
        [self refreshPrice];
        return;
    }else if([_stockNum.text integerValue]!=x*100){
        buyNum = (CGFloat)x;
        [CNManager showWindowAlert:@"您的输入的数量有误，请重新输入"];
        [self refreshPrice];
        return;
    }
    
    if ([_setZY.text floatValue]>=zhiyingMax + 0.01 ||[_setZY.text floatValue] < buyPrice ) {
        _setZY.text = [NSString stringWithFormat:@"%.2f",zhiyingMax];
        [CNManager showWindowAlert:[NSString stringWithFormat:@"止盈设置范围在%.2f～%.2f之间",buyPrice,zhiyingMax]];
        return;
    }
    if ([_setZS.text floatValue]<=zhisunMax - 0.01 ||[_setZS.text floatValue] > buyPrice) {
        _setZS.text = [NSString stringWithFormat:@"%.2f",zhisunMax];
        [CNManager showWindowAlert:[NSString stringWithFormat:@"止损设置范围在%.2f～%.2f之间",zhisunMax,buyPrice]];
        return;
    }
    
    _buyBtn.userInteractionEnabled = NO;
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    //其中 必填项为：uid(用户ID)， phone(用户手机号),code(请求第三方接口的 股票代码前面带字母的那个 股票代码), name(股票名称), price(股票单价), count(股票数量), rid(执行默认策略ID)，, 以上参数,都放入到 data 加密后传入后台。
    [dataDict setObject:[CNManager loadByKey:USERPHONE] forKey:@"phone"];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"uid"];
    [dataDict setObject:_stockDic[@"request_code"] forKey:@"code"];
    [dataDict setObject:_strckPriceDic[@"name"] forKey:@"name"];
    [dataDict setObject:_strckPriceDic[@"price"] forKey:@"price"];
//    [dataDict setObject:[NSString stringWithFormat:@"%.2f", buyMoney] forKey:@"market_value"];
    [dataDict setObject:_stockNum.text forKey:@"count"];
    [dataDict setObject:_userPlan[@"id"] forKey:@"rid"];
//    [dataDict setObject:zongji forKey:@"total_price"];
//    [dataDict setObject:_setZY.text forKey:@"stop_profit"];
//    [dataDict setObject:_setZS.text forKey:@"stop_loss"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/order/saveOrder",
                          [NewSettingsManager applicationServerURL]];//手动交易
//    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/xtp/submit",
//                          [NewSettingsManager applicationServerURL]];//自动交易

    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
        WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                 [CNManager showWindowAlert:responseObject[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    NSLog(@"%@",dic);
                   
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
                 weakself.buyBtn.userInteractionEnabled = YES;
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        weakself.buyBtn.userInteractionEnabled = YES;
//        NSLog(@"error slider");
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _stockNum) {
        [self judgePassWord1];
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)xieyiClick{
    CHWebDetailViewController * vc =[[CHWebDetailViewController alloc]init];
    vc.chTitile = @"长牛财富策略合作协议";
    vc.urlString = [NSString stringWithFormat: @"http://39.100.77.204/zwtp/xianguan.html?phone=%@",[CNManager loadByKey:USERPHONE]];
    vc.hidesBottomBarWhenPushed = YES;
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
