//
//  TodayViewController.m
//  kuaiyongToday
//
//  Created by lijinwei on 15/6/25.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AppRecord.h"
#import "MyLauncherItem.h"

NSString *kUserDefaultGroupID = @"group.360.freewifi";

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) NSMutableArray* saveLaunchArrays;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadSaveAppData];
    
    [self layoutItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

-(void)layoutItems
{
    int itemsCount = 1;
    int nScreenWidth = self.view.frame.size.width;
    int offsetX = (nScreenWidth - 76*4)/5;
    CGFloat x = offsetX;
    CGFloat y = 0;
    for (MyLauncherItem *item in self.saveLaunchArrays)
    {
        item.frame = CGRectMake(x, y, 76, 92);
        item.delegate = self;
        [item layoutItem];
        [item addTarget:self action:@selector(itemTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:item];
        
        item.closeButton.hidden = YES;
        x += 76 + offsetX;
        
        if ( itemsCount % 4 == 0)
        {
            y += 92;
            x = offsetX;
        }
        
        itemsCount++;
    }
    
    itemsCount--;
    
    NSInteger curRowCount = (itemsCount%4==0)?itemsCount/4:(itemsCount/4+1);
    
    CGRect rectBtn = CGRectMake((nScreenWidth-130)/2, curRowCount*92 + (92-36)/2-6, 130, 36);
    UIButton* editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = rectBtn;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"widget_btn_gray_empty"] forState:UIControlStateNormal];
    editBtn.backgroundColor = [UIColor clearColor];
    [editBtn addTarget:self action:@selector(actionTouchEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    //使用preferredContentSize设置大小 且只用设置高度就好了
    NSInteger preferredHeight = curRowCount*92+92;
    self.preferredContentSize = CGSizeMake(0, preferredHeight);
}

- (IBAction)actionTouchEditBtn:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"kuaiyong://"] completionHandler:nil];
}

- (BOOL) launchAppItem:(MyLauncherItem*)item {
    BOOL launchSuccess = NO;
    if( item ) {
        NSString* scheme = item.apprecord.m_scheme;
        if( !item.apprecord.m_isPrefsRoot ){
            scheme = [self formatAppUrlScheme:scheme];
        }
        launchSuccess = [self checkAppInstalled:scheme];
        if( launchSuccess ){
            if( item.apprecord.m_isSystemApp ) {
                [self.extensionContext openURL:[NSURL URLWithString:scheme] completionHandler:nil];
            }
            else {
                [self.extensionContext openURL:[NSURL URLWithString:scheme] completionHandler:nil];
            }
        }
    }
    return launchSuccess;
}

-(void)itemTouchedUpInside:(MyLauncherItem *)item
{
    BOOL launchSuccess = [self launchAppItem:item];
    if( !launchSuccess ) {
        NSString* strMsg = [NSString stringWithFormat:@"尚未载入此URL:\r\n%@", item.apprecord.m_scheme];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"不被支持的URL" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
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

- (BOOL)checkAppInstalled:(NSString*)urlSchemes{
    return YES;
/*
    if ([self.extensionContext canOpenURL:[NSURL URLWithString:urlSchemes]]){
        return  YES;
    }
    else{
        return  NO;
    }
    return NO;
 */
}

- (void)loadSaveAppData {
    self.saveLaunchArrays = [[NSMutableArray alloc] init];
    
    NSUserDefaults *shareUserDefault = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroupID];
    NSMutableArray *mutableArray =[NSKeyedUnarchiver unarchiveObjectWithData:[shareUserDefault objectForKey:@"saveapp"]];
    if( mutableArray ) {
        NSMutableArray *savedPage = [[NSMutableArray alloc] init];
        for (NSDictionary *item in mutableArray)
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
            else if([self checkAppInstalled:formatScheme]) {
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
    }
}

@end
