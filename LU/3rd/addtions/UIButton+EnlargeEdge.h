//
//  UIButton+EnlargeEdge.h
//  AnyRadio
//
//  Created by lidechen on 15/12/13.
//  Copyright © 2015年 AnyRadio.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
