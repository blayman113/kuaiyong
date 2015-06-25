//
//  LaunchAppMgr.h
//  KuaiYong
//
//  Created by lijinwei on 15/6/17.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyLauncherItem.h"

@interface LaunchAppMgr : NSObject

+ (instancetype)sharedManager;

- (void)initalize;

- (NSMutableArray*)getInstallApps;
- (NSMutableArray*)getSaveLauncherItems;
- (NSMutableArray*)getSystemApps;

- (BOOL) launchAppItem:(MyLauncherItem*)item;

- (void)addLauncherItem:(AppRecord*)record;
- (BOOL)deleteLaunchItem:(MyLauncherItem*)item;

- (void)saveLauncherItems:(NSMutableArray*)pages;

@end
