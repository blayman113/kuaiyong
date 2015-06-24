//
//  ViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/13.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "ViewController.h"
#import "MyLauncherItem.h"
#import "ItemViewController.h"
#import "AppRecord.h"
#import "UIHelper.h"
#import "DSNavigationBar.h"

@interface ViewController ()

@end

//com.launcher.kuaiyong

@implementation ViewController

-(void)loadView
{
    [super loadView];
    self.title = @"快用";
    
    [[self appControllers] setObject:[ItemViewController class] forKey:@"ItemViewController"];
  
    //Add your view controllers here to be picked up by the launcher; remember to import them above
    //[[self appControllers] setObject:[MyCustomViewController class] forKey:@"MyCustomViewController"];
    //[[self appControllers] setObject:[MyOtherCustomViewController class] forKey:@"MyOtherCustomViewController"];
    
    if(![self hasSavedLauncherItems])
    {
//        [self.launcherView setPages:[NSMutableArray arrayWithObjects:defaultArray, nil]];

        // Set number of immovable items below; only set it when you are setting the pages as the
        // user may still be able to delete these items and setting this then will cause movable
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
    }
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
//    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
