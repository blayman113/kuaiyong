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
