//
//  AppRecord.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/15.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "AppRecord.h"

@implementation AppRecord

@synthesize m_isSystemApp;
@synthesize m_icon;
@synthesize m_name;
@synthesize m_scheme;
@synthesize m_isOnShow;

- (BOOL) initRecord:(NSString*)icon toName:(NSString*)name toScheme:(NSString*)scheme isSystemApp:(BOOL)isSystemApp isPrefsRoot:(BOOL)isPrefsRoot {
    self.m_icon = icon;
    self.m_name = name;
    self.m_scheme = scheme;
    self.m_isSystemApp = isSystemApp;
    self.m_isPrefsRoot = isPrefsRoot;
    self.m_isOnShow = NO;
    return YES;
}

+ (AppRecord*) initAppRecord:(NSString*)icon toName:(NSString*)name toScheme:(NSString*)scheme isSystemApp:(BOOL)isSystemApp isPrefsRoot:(BOOL)isPrefsRoot {
    AppRecord* record = [[AppRecord alloc] init];
    if( [record initRecord:icon toName:name toScheme:scheme isSystemApp:isSystemApp isPrefsRoot:isPrefsRoot]){
        return record;
    }
    return nil;
}

@end
