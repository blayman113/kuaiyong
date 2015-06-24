//
//  Tools.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/15.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (BOOL)checkAppInstalled:(NSString*)urlSchemes{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]]){
        return  YES;
    }
    else{
        return  NO;
    }
    return NO;
}

+ (id)retrieveFromUserDefaults:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults)
        return [standardUserDefaults objectForKey:key];
    return nil;
}

+ (void)saveToUserDefaults:(id)object key:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:object forKey:key];
        [standardUserDefaults synchronize];
    }
}

@end
