//
//  marketView.m
//  LU
//
//  Created by peng jin on 2019/4/16.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "marketView.h"

@implementation marketView

- (void)refreshViewByArray:(NSArray *)markArray jumpArr:(NSArray *)arr1{
//    if (markArray.count<3) {
//        return;
//    }
    UILabel *lb;
    NSString * title;
    if (arr1.count>=3) {
        self.stockArray = arr1;
    }
        for (int i = 0; i<markArray.count; i++) {
        
                //▲▲▼▼
                NSArray *arr = markArray[i];
        if (arr.count<4) {
            return;
        }
        
//                BOOL up = true;
        if (i==0) {
            lb = _shang;
//            title = @"上证指数";
        }else if(i == 1){
            lb = _shen;
//            title = @"深证成指";
        }else if(i == 2){
            lb = _chuang;
//            title = @"创业板指";
        }
            UIButton * btn = [JPMyControl createButtonWithFrame:lb.frame Target:self SEL:@selector(btnClick:) Title:@"" ImageName:@"" bgImage:@"" Tag:100+i];
            [self addSubview:btn];
        title = arr[0];
        
        NSString * s1= [CNManager resetFormat:arr[1] digit:2];
        NSString * s2= [CNManager resetFormatWithPlus:arr[2] digit:2];
        NSString * s3= [NSString stringWithFormat:@"%@%%",[CNManager resetFormatWithPlus:arr[3] digit:2]];
                BOOL up = ([arr[2] floatValue]>=0);
                lb.textColor = up?[UIColor redColor]:UIColorFromRGB(0x247f00);
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@\n%@ %@\n%@  %@",title,up?@"▲":@"▼",s1, s2 ,s3]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
                
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(0 , title.length)];
                
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10]range:NSMakeRange(title.length +1 , 1)];
        [str addAttributes:@{NSBaselineOffsetAttributeName:@(up?-4:-6)} range:(NSRange){title.length + 1,1}];
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16]range:NSMakeRange(title.length + 2 , s1.length+1)];
                [str addAttributes:@{NSBaselineOffsetAttributeName:@(-8)} range:(NSRange){title.length + 2,s1.length+1}];
                
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10]range:NSMakeRange(title.length + 2 + s1.length+1 , s2.length + s3.length + 3)];
                
        [str addAttributes:@{NSBaselineOffsetAttributeName:@(-7)} range:(NSRange){title.length + 2 +s1.length +1 , s2.length + s3.length + 3}];
                
        
                lb.attributedText = str;
    }
    
    
}

- (void)btnClick:(UIButton *)btn{
    if (_stockArray.count>=3) {
        WEAKSELF
        if (self.jumpStock) {
            weakself.jumpStock(weakself.stockArray[btn.tag - 100]);
        }
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.x=(MAINWIDTH - 20.)/3.;
        [self addSubview:self.shang];
        [self addSubview:self.shen];
        [self addSubview:self.chuang];
        
    }
    return self;
}

- (void)setLbbk{
    _shang.backgroundColor = [UIColor clearColor];
    _shen.backgroundColor = [UIColor clearColor];
    _chuang.backgroundColor = [UIColor clearColor];
    for (int i = 1 ; i< 3; i++) {
        UIView * x = [JPMyControl createViewWithFrame:CGRectMake(2.5 + (5 + _x) * i, 10, .5, self.height - 20.) bgColor:[UIColor grayColor]];
        UIView * y = [JPMyControl createViewWithFrame:CGRectMake(10, 0, MAINWIDTH - 20., .5) bgColor:[UIColor grayColor]];
        if ( i == 2) {
            UIView * z = [JPMyControl createViewWithFrame:CGRectMake(10, self.height - .5, MAINWIDTH - 20., .5) bgColor:[UIColor grayColor]];
            [self addSubview:z];
        }
        [self addSubview:x];
        [self addSubview:y];
    }
}

- (UILabel *)shang{
    if (!_shang) {
        _shang = [JPMyControl createLabelWithFrame:CGRectMake(5, 5, _x, self.frame.size.height-12) Font:12 Text:@""];
        _shang.numberOfLines = 0;
        _shang.textAlignment = NSTextAlignmentCenter;
        _shang.backgroundColor = [UIColor blackColor];
        _shang.layer.cornerRadius = 5.;
        _shang.layer.masksToBounds = YES;
    }
    return _shang;
}

- (UILabel *)shen {
    if (!_shen) {
        _shen = [JPMyControl createLabelWithFrame:CGRectMake( _x + 10., 5, _x, self.frame.size.height-12) Font:12 Text:@""];
        _shen.numberOfLines = 0;
        _shen.textAlignment = NSTextAlignmentCenter;
        _shen.backgroundColor = [UIColor blackColor];
        _shen.layer.cornerRadius = 5.;
        _shen.layer.masksToBounds = YES;
    }
    return _shen;
}

- (UILabel *)chuang{
    if (!_chuang) {
        _chuang = [JPMyControl createLabelWithFrame:CGRectMake(_x * 2. + 15, 5, _x, self.frame.size.height-12) Font:12 Text:@""];
        _chuang.numberOfLines = 0;
        _chuang.textAlignment = NSTextAlignmentCenter;
        _chuang.backgroundColor = [UIColor blackColor];
        _chuang.layer.cornerRadius = 5.;
        _chuang.layer.masksToBounds = YES;
    }
    return _chuang;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
