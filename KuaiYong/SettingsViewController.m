//
//  SettingsViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/28.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIHelper.h"
#import "SettingsTableViewCell.h"
#import "AboutViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface SettingsViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
    
    self.tableView = [[UITableView alloc]  initWithFrame:self.view.frame];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_COMMON_BACKGROUND;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    [self initNavBtn];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SettingsTableViewCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if( indexPath.row == 0 ) {
        cell.titleName = @"使用帮助";
    }
    else if( indexPath.row == 1 ) {
        cell.titleName = @"分享给朋友";
    }
    else if( indexPath.row == 2 ) {
        cell.titleName = @"QQ交流群:458673733";
    }
    else if( indexPath.row == 3 ) {
        cell.titleName = @"好评支持";
    }
    else if( indexPath.row == 4 ) {
        cell.titleName = @"关于我们";
    }

    return cell;
}

- (void)showShareView {
    
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeWeixiSession, ShareTypeWeixiTimeline,ShareTypeWeixiFav,ShareTypeQQ, ShareTypeQQSpace,nil];
    
    UIImage *shareImage = [UIImage imageNamed:@"app_icon.png"];
    
    NSString* strText = [NSString stringWithFormat:@"在通知栏轻轻一按，便与好友打电话，发短信;启动最常用的应用程序，你也来用吧！从这儿%@下载！",URL_APPSTORE_APP];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:strText
                                       defaultContent:strText
                                                image:[ShareSDK pngImageWithImage:shareImage]
                                                title:@"快用-通知栏小工具"
                                                  url:URL_APPSTORE_APP
                                          description:strText
                                            mediaType:SSPublishContentMediaTypeNews];
 
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:strText
                                           title:@"快用-通知栏小工具"
                                             url:URL_APPSTORE_APP
                                           image:[ShareSDK pngImageWithImage:shareImage]
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:strText
                                            title: strText
                                              url:URL_APPSTORE_APP
                                            image:[ShareSDK pngImageWithImage:shareImage]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
        {
            [self showShareView];
        }
            break;
            
        case 2:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"458673733";
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"官方QQ群号已复制，进入QQ可粘贴并查找我们"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"我要进群",nil];
            [alertView show];
        }
            break;
            
        case 3:
        {
            NSURL *url = [NSURL URLWithString:URL_SCORE];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
            
        case 4:
        {
            AboutViewController* aboutVC = [[AboutViewController alloc] init];
            aboutVC.view.frame = self.view.frame;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置选中效果
    UIView* selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    [selectView setBackgroundColor:COLOR(80, 87, 131)];
    [cell setSelectedBackgroundView:selectView];
}

#pragma mark - alertView delegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 更新程序，跳转到appstore
        // NSString *stringURL = [self getAppStoreUpdateUrl];
        NSURL *url = [NSURL URLWithString:@"mqqtribe://"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
