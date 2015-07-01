//
//  LaunchAppMgr.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/17.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "LaunchAppMgr.h"
#import "AppRecord.h"

NSString *kUserDefaultGroupID = @"group.360.freewifi";

@interface LaunchAppMgr ()

@property (nonatomic, strong) NSMutableArray* launchAppArrays;
@property (nonatomic, strong) NSMutableArray* systemAppArrays;
@end

@implementation LaunchAppMgr

static LaunchAppMgr *launchAppMgr = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        launchAppMgr = [LaunchAppMgr new];
        
    });
    return launchAppMgr;
}

- (void)initalize {
    self.launchAppArrays = [[NSMutableArray alloc] init];
    self.saveLaunchArrays = [[NSMutableArray alloc] init];
    self.systemAppArrays = [[NSMutableArray alloc] init];
    
    [self loadSaveLanuchItems];
    [self loadAllAppItemFromPlist];
    [self loadSystemAppItemFromPlist];
}

- (BOOL) launchAppItem:(MyLauncherItem*)item {
    BOOL launchSuccess = NO;
    if( item ) {
        NSString* scheme = item.apprecord.m_scheme;
        if( !item.apprecord.m_isPrefsRoot ){
            scheme = [self formatAppUrlScheme:scheme];
        }
        launchSuccess = [Tools checkAppInstalled:scheme];
        if( launchSuccess ){
            if( item.apprecord.m_isSystemApp ) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
            }
        }
    }
    return launchSuccess;
}

- (void) loadAllAppItemFromPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"allapp" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray* arrayList = [data valueForKey:@"launchapp"];
    for( NSInteger index = 0; index< [arrayList count]; index++ ) {
        NSDictionary* dictItem = [arrayList objectAtIndex:index];
        if( dictItem) {
            NSArray* schemeArrays = [dictItem objectForKey:@"schemes"];
            if([schemeArrays count]>0) {
                NSString* scheme = [schemeArrays objectAtIndex:0];
                if( [scheme length]>=3){
                    NSString* name = [dictItem objectForKey:@"name"];
                    NSString* url = [dictItem objectForKey:@"icon"];
                    AppRecord* record = [AppRecord initAppRecord:url toName:name toScheme:scheme isSystemApp:NO isPrefsRoot:NO];
                    [self.launchAppArrays addObject:record];
                }
            }
        }
    }
}

- (void) loadSystemAppItemFromPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SystemAppList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray* arrayList = [data valueForKey:@"data"];
    for( NSInteger index = 0; index< [arrayList count]; index++ ) {
        NSDictionary* dictItem = [arrayList objectAtIndex:index];
        if( dictItem) {
            NSString* scheme = [dictItem objectForKey:@"url"];
            if([scheme length]>3) {
                NSString* name = [dictItem objectForKey:@"displayName"];
                NSString* url = [dictItem objectForKey:@"iconImage"];
                BOOL isPrefsRoot = [[dictItem objectForKey:@"isPrefsRoot"] boolValue];
                AppRecord* record = [AppRecord initAppRecord:url toName:name toScheme:scheme isSystemApp:YES isPrefsRoot:isPrefsRoot];
                [self.systemAppArrays addObject:record];
            }
        }
    }
}

- (NSString*) formatAppUrlScheme:(NSString*)scheme {
    if( [scheme length]>=3){
        NSString* compareScheme = [scheme substringWithRange:NSMakeRange(scheme.length-3, 3)];
        if(![compareScheme isEqualToString:@"://"]) {
            scheme = [scheme stringByAppendingString:@"://"];
        }
    }
    return scheme;
}

- (void)loadSaveLanuchItems {
    NSArray *page = (NSArray *)[Tools retrieveFromUserDefaults:@"myLauncherView"];
    if(page) {
        for(NSDictionary *item in page)
        {
            NSString* title = [item objectForKey:@"title"];
            NSString* image = [item objectForKey:@"image"];
            NSString* targetTitle = [item objectForKey:@"scheme"];
            BOOL isSystemApp = [[item objectForKey:@"isSystemApp"] boolValue];
            BOOL isPrefsRoot = [[item objectForKey:@"isPrefsRoot"] boolValue];
            
            NSString* formatScheme = targetTitle;
            if( !isPrefsRoot ) {
                formatScheme = [self formatAppUrlScheme:targetTitle];
            }
            
            AppRecord* calendarRecord = [AppRecord initAppRecord:image toName:title toScheme:targetTitle isSystemApp:isSystemApp isPrefsRoot:isPrefsRoot];
            MyLauncherItem* calendarItem = [[MyLauncherItem alloc] initWithRecord:calendarRecord];
            if( isSystemApp ) {
                [self.saveLaunchArrays addObject:calendarItem];
            }
            else if([Tools checkAppInstalled:formatScheme]) {
                [self.saveLaunchArrays addObject:calendarItem];
            }
        }
    }
    else {
        AppRecord* calendarRecord = [AppRecord initAppRecord:@"app_calendar.png" toName:@"日历" toScheme:@"calshow" isSystemApp:YES isPrefsRoot:NO];
        MyLauncherItem* calendarItem = [[MyLauncherItem alloc] initWithRecord:calendarRecord];
        [self.saveLaunchArrays addObject:calendarItem];
        
        AppRecord* photoRecord = [AppRecord initAppRecord:@"app_photos.png" toName:@"照片" toScheme:@"photos-redirect" isSystemApp:YES isPrefsRoot:NO];
        MyLauncherItem* photoItem = [[MyLauncherItem alloc] initWithRecord:photoRecord];
        [self.saveLaunchArrays addObject:photoItem];
        
        AppRecord* notesRecord = [AppRecord initAppRecord:@"app_reminders" toName:@"提醒事项" toScheme:@"x-apple-reminder" isSystemApp:YES isPrefsRoot:NO];
        MyLauncherItem* notesItem = [[MyLauncherItem alloc] initWithRecord:notesRecord];
        [self.saveLaunchArrays addObject:notesItem];
        
        AppRecord* weatherRecord = [AppRecord initAppRecord:@"app_safari.png" toName:@"Safari" toScheme:@"http://baidu.com" isSystemApp:YES isPrefsRoot:YES];
        MyLauncherItem* weatherItem = [[MyLauncherItem alloc] initWithRecord:weatherRecord];
        [self.saveLaunchArrays addObject:weatherItem];
        
        [self saveLauncherItems:self.saveLaunchArrays];
    }
}

- (NSMutableArray*)getSaveLauncherItems {
    return self.saveLaunchArrays;
}

- (void)saveLauncherItems:(NSMutableArray*)pages {
    NSMutableArray *pagesToSave = [[NSMutableArray alloc] init];
    
    for(MyLauncherItem *item in pages)
    {
        NSMutableDictionary *itemToSave = [[NSMutableDictionary alloc] init];
        [itemToSave setObject:item.apprecord.m_name forKey:@"title"];
        [itemToSave setObject:item.apprecord.m_icon forKey:@"image"];
        [itemToSave setObject:[NSString stringWithFormat:@"%d", item.apprecord.m_isSystemApp] forKey:@"isSystemApp"];
        [itemToSave setObject:[NSString stringWithFormat:@"%d", item.apprecord.m_isPrefsRoot] forKey:@"isPrefsRoot"];
        [itemToSave setObject:item.apprecord.m_scheme forKey:@"scheme"];
        
        [pagesToSave addObject:itemToSave];
    }
    
    [Tools saveToUserDefaults:pagesToSave key:@"myLauncherView"];
    
    NSUserDefaults *shareUserDefault = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroupID];
    [shareUserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:pagesToSave] forKey:@"saveapp"];
    [shareUserDefault synchronize];
}

- (void)addLauncherItem:(MyLauncherItem*)item {
    [self.saveLaunchArrays addObject:item];
    [self saveLauncherItems:self.saveLaunchArrays];
}

- (BOOL)deleteLaunchItem:(MyLauncherItem*)item {
    int i = 0;
    for (MyLauncherItem *aitem in self.saveLaunchArrays)
    {
        if(aitem == item)
        {
            [self.saveLaunchArrays removeObjectAtIndex:i];
            return YES;
        }
        i++;
    }
    return NO;
}

- (BOOL)deleteSaveLaunchItem:(AppRecord*)record {
    record.m_isOnShow = NO;
    
    for( NSInteger kIndex = 0; kIndex< [self.saveLaunchArrays count]; kIndex++ ) {
        MyLauncherItem* saveItem = [self.saveLaunchArrays objectAtIndex:kIndex];
        AppRecord* saveRecord = saveItem.apprecord;
        if( saveRecord && [saveRecord.m_name isEqualToString:record.m_name]
           && [saveRecord.m_scheme isEqualToString:record.m_scheme]) {
            [saveItem closeItem:nil];
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray*)getInstallApps {
    NSMutableArray* installArrays =  [[NSMutableArray alloc] init];
    for( NSInteger index = 0; index< [self.launchAppArrays count]; index++ ) {
        AppRecord* record = [self.launchAppArrays objectAtIndex:index];
        NSString* formatScheme = record.m_scheme;
        if( !record.m_isPrefsRoot ) {
            formatScheme = [self formatAppUrlScheme:record.m_scheme];
        }
        
        BOOL isOnShow = NO;
        if( [self.saveLaunchArrays count]>0 ) {
            for( NSInteger kIndex = 0; kIndex< [self.saveLaunchArrays count]; kIndex++ ) {
                MyLauncherItem* saveItem = [self.saveLaunchArrays objectAtIndex:kIndex];
                AppRecord* saveRecord = saveItem.apprecord;
                if( saveRecord && [saveRecord.m_name isEqualToString:record.m_name]
                   && [saveRecord.m_scheme isEqualToString:record.m_scheme]) {
                    isOnShow = YES;
                    break;
                }
            }
            record.m_isOnShow = isOnShow;
            if( [Tools checkAppInstalled:formatScheme] ) {
                [installArrays addObject:record];
            }
        }
    }
    return installArrays;
}

- (NSMutableArray*)getSystemApps {
    for( NSInteger index = 0; index< [self.systemAppArrays count]; index++ ) {
        AppRecord* record = [self.systemAppArrays objectAtIndex:index];
        NSString* formatScheme = record.m_scheme;
        if( !record.m_isPrefsRoot ) {
            formatScheme = [self formatAppUrlScheme:record.m_scheme];
        }

        BOOL isOnShow = NO;
        if( [self.saveLaunchArrays count]>0 ) {
            for( NSInteger kIndex = 0; kIndex< [self.saveLaunchArrays count]; kIndex++ ) {
                MyLauncherItem* saveItem = [self.saveLaunchArrays objectAtIndex:kIndex];
                AppRecord* saveRecord = saveItem.apprecord;
                if( saveRecord && [saveRecord.m_name isEqualToString:record.m_name]
                   && [saveRecord.m_scheme isEqualToString:record.m_scheme]) {
                    isOnShow = YES;
                    break;
                }
            }
        }
        record.m_isOnShow = isOnShow;
    }
    return self.systemAppArrays;
}

@end
