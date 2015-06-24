//
//  UIHelper.h
//  KuaiYong
//
//  Created by lijinwei on 15/6/16.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

// 根据RGB获取UIImage
+ (UIImage*) imageWithColor:(UIColor*)color;
+ (UIImage*) imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIImage*) normalImageForReturnButtonWithSize:(NSString*)imageName toBtnSize:(CGSize)buttonSize;

@end
