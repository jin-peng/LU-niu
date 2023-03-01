//
//  JPMyControl.h
//  JPSns
//
//  Created by jp on 12-5-5.
//  Copyright (c) 2014年 金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Configure.h"
//#import "LPPopup.h"

//#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7.0&&[[[UIDevice currentDevice] systemVersion]floatValue]<8.0

@interface JPMyControl : NSObject




//使用＋方法进行创建 是工厂模式中的一种
//工厂模式：传入参数，出来控件

#pragma mark 创建View
+ (UIView*)createViewWithFrame:(CGRect)frame;
+ (UIView*)createViewWithFrame:(CGRect)frame bgColor:(UIColor*)color;
#pragma mark 创建Label
+ (UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text;
#pragma mark 创建button
+ (UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target SEL:(SEL)method Title:(NSString*)title ImageName:(NSString*)imageName bgImage:(NSString*)bgimageName Tag:(NSInteger)tag;
#pragma mark 创建imageView
+ (UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark 创建textField
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame Font:(float)font TextColor:(UIColor*)color LeftImageName:(NSString*)leftimageName RightImageName:(NSString*)rightImageName BgImageName:(NSString*)bgImageName;

+ (UITextField*)createTextFieldWithFrame:(CGRect)frame Font:(float)font TextColor:(UIColor*)color LeftImageName:(NSString*)leftimageName RightImageName:(NSString*)rightImageName BgImageName:(NSString*)bgImageName PlaceHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen;

+ (CGSize)autoFitLabel:(UILabel*)label bystr:(NSString*)str font:(UIFont *)fSize;

+ (CGFloat)autoFitLabelByWidth:(CGFloat)width bystr:(NSString*)str font:(UIFont *)fSize;

+ (CGSize)autoFitWidthBystr:(NSString *)str font:(UIFont *)fSize;

+ (CGSize)autoFitWidth:(UILabel*)label bystr:(NSString*)str font:(UIFont *)fSize;

+ (UITableView*)createTableViewWithFrame:(CGRect)frame Target:(id)target UITableViewStyle:(UITableViewStyle)style separatorStyle:(BOOL)isLine;

+ (UICollectionView*)createCollectionViewWithFrame:(CGRect)frame minInteritemSpacing:(CGFloat)minInteritemSpacing minLineSpacing:(CGFloat)minLineSpacing Taget:(id)target itemSize:(CGSize)size byClass:(Class)myClass;

+ (UICollectionView *)createCollectionViewWithFrame:(CGRect)frame minInteritemSpacing:(CGFloat)minInteritemSpacing minLineSpacing:(CGFloat)minLineSpacing Taget:(id)target itemSize:(CGSize)size byClass:(Class)myClass scrollMode:(UICollectionViewScrollDirection)scrollModel;

+ (void)resetLabelFrame :(UILabel * )lb byString:(NSString *)str;

+ (void)resetLabelFrame :(UILabel * )lb;
//+ (void)showAlert:(NSString*)alert :(UIView*)view;
+ (void)resetLabelFrameByWidth:(UILabel *)lb;

@end
