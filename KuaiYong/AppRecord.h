//
//  AppRecord.h
//  KuaiYong
//
//  Created by lijinwei on 15/6/15.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRecord : NSObject

@property(nonatomic, assign) BOOL m_isSystemApp;
@property(nonatomic, assign) BOOL m_isPrefsRoot;
@property(nonatomic, assign) BOOL m_isOnShow;
@property(nonatomic, strong) NSString* m_icon;
@property(nonatomic, strong) NSString* m_name;
@property(nonatomic, strong) NSString* m_scheme;

- (BOOL) initRecord:(NSString*)icon toName:(NSString*)name toScheme:(NSString*)scheme isSystemApp:(BOOL)isSystemApp isPrefsRoot:(BOOL)isPrefsRoot;

+ (AppRecord*) initAppRecord:(NSString*)icon toName:(NSString*)name toScheme:(NSString*)scheme isSystemApp:(BOOL)isSystemApp isPrefsRoot:(BOOL)isPrefsRoot;

@end
