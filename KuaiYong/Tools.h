//
//  Tools.h
//  KuaiYong
//
//  Created by lijinwei on 15/6/15.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (BOOL)checkAppInstalled:(NSString*)urlSchemes;

+ (id)retrieveFromUserDefaults:(NSString *)key;
+ (void)saveToUserDefaults:(id)object key:(NSString *)key;

@end
