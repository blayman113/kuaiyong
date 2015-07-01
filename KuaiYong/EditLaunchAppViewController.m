//
//  EditLaunchAppViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/27.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "EditLaunchAppViewController.h"
#import "UIHelper.h"
#import "AppRecord.h"
#import "LaunchAppMgr.h"

@interface EditLaunchAppViewController ()

@property (nonatomic,strong) UIButton* chkBtn;
@property (nonatomic,strong) UITextField* nameField;
@property (nonatomic,strong) UITextField* valueField;

@end

@implementation EditLaunchAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
    
    self.title = @"编辑启动项";
    
    [self initNavBtn];
    
    UIImageView *itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageName]];
    itemImage.frame = CGRectMake((self.view.frame.size.width-60)/2, 30+60, 60, 60);
    itemImage.layer.cornerRadius = 8;
    itemImage.layer.masksToBounds =YES;
    [self.view addSubview:itemImage];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width-260)/2, 30+60+60+20, 260, 40)];
    self.nameField.font = [UIFont systemFontOfSize:16];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.text = self.name;
    [self.view addSubview:self.nameField];
    
    self.valueField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width-260)/2, 30+60+60+20+40+10, 260, 40)];
    self.valueField.font = [UIFont systemFontOfSize:16];
    self.valueField.borderStyle = UITextBorderStyleRoundedRect;
    self.valueField.backgroundColor = [UIColor whiteColor];
    self.valueField.text = self.value;
    [self.view addSubview:self.valueField];
    /*
    self.chkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chkBtn.adjustsImageWhenHighlighted = NO;
    self.chkBtn.frame = CGRectMake(self.valueField.frame.origin.x, self.valueField.frame.origin.y+self.valueField.frame.size.height+15, 260, 36);
    self.chkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.chkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.chkBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.chkBtn setBackgroundImage:[UIImage imageNamed:@"icon_check_off@3x"] forState:UIControlStateNormal];
    [self.chkBtn setBackgroundImage:[UIImage imageNamed:@"icon_check_on@3x"] forState:UIControlStateSelected];
    self.chkBtn.selected = NO;
    [self.chkBtn addTarget:self action:@selector(selectCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectCheckBtn:(UIGestureRecognizer*) gesture{
    self.chkBtn.selected = !self.chkBtn.selected;
}

- (void)initNavBtn{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 32);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIHelper normalImageForReturnButtonWithSize:@"quc_nav_back_normal.png" toBtnSize:leftButton.frame.size] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton addTarget:self action:@selector(actionTouchBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
    
    //right button
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 32);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
    [rightButton addTarget:self action:@selector(editOK) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)editOK {
    NSString* urlScheme = [NSString stringWithFormat:@"%@%@", self.scheme, self.value];
    AppRecord* record = [AppRecord initAppRecord:self.imageName toName:self.nameField.text toScheme:urlScheme isSystemApp:YES isPrefsRoot:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLauncherItemChangedNotification object:record userInfo:nil];
    [self actionTouchBackButton:nil];
}

- (void) actionTouchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
