//
//  UIHelper.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/16.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (UIImage*) imageWithColor:(UIColor*)color
{
    CGSize imageSize = CGSizeMake(10, 10);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

+ (UIImage*) imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    CGSize imageSize = CGSizeMake(10, 10);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

// “返回”按钮normal状态的image
+ (UIImage*) normalImageForReturnButtonWithSize:(NSString*)imageName toBtnSize:(CGSize)buttonSize
{
    UIGraphicsBeginImageContextWithOptions(buttonSize, 0, [UIScreen mainScreen].scale);
    
    // 画箭头
    UIImage* image = [UIImage imageNamed:imageName];
    [image drawInRect:CGRectMake(0, (buttonSize.height - image.size.height)/2, image.size.width, image.size.height)];
    
    // 存储image
    UIImage* normalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束
    UIGraphicsEndImageContext();
    
    return normalImage;
}

@end
