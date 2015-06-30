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

@property (nonatomic, strong) NSMutableArray* saveLaunchArrays; //添加显示的数组

+ (instancetype)sharedManager;

- (void)initalize;

- (NSMutableArray*)getInstallApps;
- (NSMutableArray*)getSaveLauncherItems;
- (NSMutableArray*)getSystemApps;

- (BOOL) launchAppItem:(MyLauncherItem*)item;

- (void)addLauncherItem:(AppRecord*)record;
- (BOOL)deleteLaunchItem:(MyLauncherItem*)item;
- (BOOL)deleteSaveLaunchItem:(AppRecord*)record;

- (void)saveLauncherItems:(NSMutableArray*)pages;

@end
