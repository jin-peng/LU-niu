//
//  marketView.h
//  LU
//
//  Created by peng jin on 2019/4/16.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface marketView : UIView

@property (nonatomic, strong)UILabel * shang;
@property (nonatomic, strong)UILabel * shen;
@property (nonatomic, strong)UILabel * chuang;
@property (nonatomic, strong)NSArray * stockArray;
@property (nonatomic) CGFloat x;
@property (nonatomic, strong) void (^jumpStock)(NSDictionary *);

- (void)refreshViewByArray:(NSArray *)markArray jumpArr:(NSArray *)arr1;
- (void)setLbbk;
@end

NS_ASSUME_NONNULL_END
