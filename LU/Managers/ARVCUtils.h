//
//  ARVCUtils.h
//  ChinaNews
//
//  Created by JinPeng on 2017/3/27.
//  Copyright © 2017年 JinPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARVCUtils : NSObject 

+ (void)handleEvents:(NSDictionary *)dictionary controller:(UIViewController *)viewController fromTag:(NSInteger)fromtag;

@end
