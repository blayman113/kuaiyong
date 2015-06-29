//
//  AboutViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/29.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "AboutViewController.h"
#import "UIHelper.h"

@interface AboutViewController ()

@property (nonatomic,strong) UILabel *titleNameLabel;
@property (nonatomic,strong) UIImageView* arrowView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于快用";
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
    
    [self initNavBtn];
    
    UIImageView *itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    itemImage.frame = CGRectMake((self.view.frame.size.width-60)/2, 40+60, 60, 60);
    itemImage.layer.cornerRadius = 8;
    itemImage.layer.masksToBounds =YES;
    [self.view addSubview:itemImage];
    
    self.titleNameLabel = [[UILabel alloc]  initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, itemImage.frame.origin.y+itemImage.frame.size.height + 10, 140, 30)];
    self.titleNameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleNameLabel.textColor = [UIColor whiteColor];
    [self.titleNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.titleNameLabel];
    
    NSBundle * mainBoundle = [NSBundle mainBundle];
    NSString * localVersion = [mainBoundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.titleNameLabel.text = [NSString stringWithFormat:@"版本号：V%@", localVersion];
    
    UILabel* titleLabel = [[UILabel alloc]  initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, self.titleNameLabel.frame.origin.y+self.titleNameLabel.frame.size.height + 10, 300, 24)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"通知栏常用工具，轻松启动您喜欢的应用。";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
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
}

- (void) actionTouchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
