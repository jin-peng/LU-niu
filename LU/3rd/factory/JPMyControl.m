//
//  JPMyControl.m
//  JPSns
//
//  Created by jp on 12-5-5.
//  Copyright (c) 2014年 金鹏. All rights reserved.
//

#import "JPMyControl.h"

@implementation JPMyControl
#pragma mark 创建View
+ (UIView*)createViewWithFrame:(CGRect)frame{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    return view ;
}

+ (UIView*)createViewWithFrame:(CGRect)frame bgColor:(UIColor*)color{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    view.backgroundColor=color;
    return view;
}
#pragma mark 创建Label
+ (UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont systemFontOfSize:font];
    label.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
//    label.lineBreakMode=UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
//    label.numberOfLines=0;
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
//    label.adjustsFontSizeToFitWidth=YES;
    return label;
    
}
#pragma mark 创建button
+ (UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target SEL:(SEL)method Title:(NSString*)title ImageName:(NSString*)imageName bgImage:(NSString*)bgimageName Tag:(NSInteger)tag{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:bgimageName] forState:UIControlStateNormal];
    button.frame=frame;
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    return button;
}
#pragma mark 创建imageView
+ (UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    //用户交互打开
    imageView.userInteractionEnabled=YES;
    
    return imageView;
}

#pragma mark 创建textField
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame Font:(float)font TextColor:(UIColor*)color LeftImageName:(NSString*)leftimageName RightImageName:(NSString*)rightImageName BgImageName:(NSString*)bgImageName{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    textField.font=[UIFont systemFontOfSize:font];
    textField.textColor=color;
//    左侧图片
    UIImage*image=[UIImage imageNamed:leftimageName];
    UIImageView*leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    leftImageView.image=image;
    textField.leftView=leftImageView;
//    [leftImageView release];
    textField.leftViewMode=UITextFieldViewModeAlways;
////    右侧图片
//    UIImage*image1=[UIImage imageNamed:rightImageName];
//    UIImageView*rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image1.size.width, image1.size.height)];
//    rightImageView.image=image1;
//    textField.rightView=rightImageView;
//    [rightImageView release];
//    textField.rightViewMode=UITextFieldViewModeAlways;
    textField.clearButtonMode=YES;
//    密码遮掩
//    textField.secureTextEntry;
//    提示框
//    textField.placeholder;
    return textField;
}

//   适配器 为了适配以前的版本 和现有已经开发的所有功能模块，在原有功能模块基础上进行扩展的方式
+ (UITextField*)createTextFieldWithFrame:(CGRect)frame Font:(float)font TextColor:(UIColor*)color LeftImageName:(NSString*)leftimageName RightImageName:(NSString*)rightImageName BgImageName:(NSString*)bgImageName PlaceHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen{    
    UITextField*textField=[JPMyControl createTextFieldWithFrame:frame Font:font TextColor:color LeftImageName:leftimageName RightImageName:rightImageName BgImageName:bgImageName];
    textField.placeholder=placeHolder;
    textField.secureTextEntry=isOpen;
    return textField;
}

+ (CGSize)autoFitLabel:(UILabel*)label bystr:(NSString*)str font:(UIFont *)fSize{

//    UIFont *font = [UIFont fontWithName:@"Arial" size:fSize];
    CGSize size = CGSizeMake(MAINWIDTH,2000);
    CGRect labelRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fSize} context:nil];
//    label.frame = CGRectMake(MAINWIDTH-labelsize.width-10.0, 51.0, labelsize.width+5, labelsize.height+5 );
//    label.text=str;
    return labelRect.size;
}

+ (CGSize)autoFitWidthBystr:(NSString *)str font:(UIFont *)fSize{
//    UIFont *font = [UIFont systemFontOfSize:fSize];
    CGSize size = CGSizeMake(2000,fSize.lineHeight);
    CGRect labelRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fSize} context:nil];
    //    label.frame = CGRectMake(MAINWIDTH-labelsize.width-10.0, 51.0, labelsize.width+5, labelsize.height+5 );
    //    label.text=str;
    return labelRect.size;
}


+ (CGFloat)autoFitLabelByWidth:(CGFloat)width bystr:(NSString*)str font:(UIFont *)fSize{
//    str=[NSString stringWithFormat:@"%@",str];
//    UIFont *font = [UIFont fontWithName:@"Arial" size:fSize];
    if (!str)
    {
        return 0;
    }
    CGSize size = CGSizeMake(width,2000);
//    CGFloat high = 0.0;
//    NSArray*arr=[str componentsSeparatedByString:@"\n"];
//    for (NSString*tmp in arr) {
        CGRect labelRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fSize} context:nil];
//        high=high+labelRect.size.height;
//    }
    
    //    label.frame = CGRectMake(MAINWIDTH-labelsize.width-10.0, 51.0, labelsize.width+5, labelsize.height+5 );
//    NSInteger i=(NSInteger)(high-fSize)/fSize;
    return labelRect.size.height;
}

+ (CGSize)autoFitWidth:(UILabel *)label bystr:(NSString *)str font:(UIFont *)fSize{
//    UIFont *font = [UIFont fontWithName:@"Arial" size:fSize];
    CGSize size = CGSizeMake(2000,fSize.lineHeight);
    CGRect labelRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fSize} context:nil];
    //    label.frame = CGRectMake(MAINWIDTH-labelsize.width-10.0, 51.0, labelsize.width+5, labelsize.height+5 );
//    label.text=str;
    return labelRect.size;
}

+ (UITableView*)createTableViewWithFrame:(CGRect)frame Target:(id)target UITableViewStyle:(UITableViewStyle)style separatorStyle:(BOOL)isLine{
    UITableView*tableView=[[UITableView alloc]initWithFrame:frame style:style];
    tableView.delegate=target;
    tableView.dataSource=target;
    tableView.separatorStyle=isLine;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    return tableView;
}

+ (UICollectionView *)createCollectionViewWithFrame:(CGRect)frame minInteritemSpacing:(CGFloat)minInteritemSpacing minLineSpacing:(CGFloat)minLineSpacing Taget:(id)target itemSize:(CGSize)size byClass:(Class)myClass{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = size;
    flowLayout.minimumInteritemSpacing = minInteritemSpacing;
    flowLayout.minimumLineSpacing = minLineSpacing;
    
    UICollectionView * _chengXinCollection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
//    [flowLayout release];
    if (@available(iOS 11.0, *)) {
        _chengXinCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    _chengXinCollection.dataSource=target;
    _chengXinCollection.delegate=target;
    _chengXinCollection.showsHorizontalScrollIndicator=NO;
    _chengXinCollection.backgroundColor=[UIColor clearColor];
    [_chengXinCollection registerClass:myClass forCellWithReuseIdentifier:@"ID"];
    return _chengXinCollection;
}

+ (UICollectionView *)createCollectionViewWithFrame:(CGRect)frame minInteritemSpacing:(CGFloat)minInteritemSpacing minLineSpacing:(CGFloat)minLineSpacing Taget:(id)target itemSize:(CGSize)size byClass:(Class)myClass scrollMode:(UICollectionViewScrollDirection)scrollModel{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:scrollModel];
    flowLayout.itemSize = size;
    flowLayout.minimumInteritemSpacing = minInteritemSpacing;
    flowLayout.minimumLineSpacing = minLineSpacing;
    
    UICollectionView * _chengXinCollection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
//    [flowLayout release];
    if (@available(iOS 11.0, *)) {
        _chengXinCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    _chengXinCollection.dataSource=target;
    _chengXinCollection.delegate=target;
    _chengXinCollection.showsHorizontalScrollIndicator=NO;
    _chengXinCollection.backgroundColor=[UIColor clearColor];
    [_chengXinCollection registerClass:myClass forCellWithReuseIdentifier:@"ID"];
    return _chengXinCollection;
}

+ (void)resetLabelFrame:(UILabel *)lb byString:(NSString *)str{
   NSInteger h = [self autoFitLabelByWidth:lb.frame.size.width bystr:str font:lb.font];
    lb.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, h+1);
}

+ (void)resetLabelFrame:(UILabel *)lb{
    CGFloat h = [self autoFitLabelByWidth:lb.frame.size.width bystr:lb.text font:lb.font];
    lb.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, h);
}

+ (void)resetLabelFrameByWidth:(UILabel *)lb{
    CGFloat w = [self autoFitWidthBystr:lb.text font:lb.font].width;
    
    lb.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y, w, lb.frame.size.height);
}

//+ (void)showAlert:(NSString*)alert :(UIView*)view {
//    LPPopup *popup = [LPPopup popupWithText:alert];
//    [popup showInView:view
//        centerAtPoint:view.center
//             duration:kLPPopupDefaultWaitDuration
//           completion:nil];
//}

@end
