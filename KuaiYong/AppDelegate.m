//
//  AppDelegate.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/13.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIHelper.h"
#import "DSNavigationBar.h"
#import "LaunchAppMgr.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self initMainView];

    [[LaunchAppMgr sharedManager] initalize];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) initMainView{
    self.navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];

    [self.navigationController setViewControllers:@[[[ViewController alloc] init]]];
    //40,141,255
    UIColor * color = [UIColor colorWithRed:(40/255.0) green:(141/255.0) blue:(255/255) alpha:1.0f];
    [[DSNavigationBar appearance] setNavigationBarWithColor:color];
    [self.window setRootViewController:self.navigationController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
