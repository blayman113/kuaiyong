//
//  AddAppLaunchViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/17.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "AddAppLaunchViewController.h"
#import "UIHelper.h"
#import "InstalledAppTableViewCell.h"
#import "LaunchAppMgr.h"

@interface AddAppLaunchViewController () <UITableViewDataSource,UITableViewDelegate,InstalledAppTableViewCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* appArrays;
@end

@implementation AddAppLaunchViewController

-(void)loadView {
    [super loadView];
    
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *buttonNames = [NSArray arrayWithObjects:@"安装应用", @"系统应用", nil];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
    
    _segmentedControl.frame =  CGRectMake(0, 0, 200, 30);
    _segmentedControl.selectedSegmentIndex=0;
    
    [_segmentedControl setTintColor:[UIColor whiteColor]];
    
    [self switchSegment:_segmentedControl.selectedSegmentIndex];
    
    //添加事件
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_segmentedControl];
    self.navigationItem.titleView = _segmentedControl;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self initNavBtn];
    
    self.appArrays = [[LaunchAppMgr sharedManager] getInstallApps];
    
    self.tableView = [[UITableView alloc]  initWithFrame:self.view.frame];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_COMMON_BACKGROUND;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
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
}

- (void)switchSegment:(NSInteger)index {
    
}

-(void)segmentAction:(UISegmentedControl *)Seg {
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Seg.selectedSegmentIndex:%ld",(long)Index);
    [self switchSegment:Index];
}

- (void) actionTouchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.appArrays count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"installedAppCell";
    InstalledAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[InstalledAppTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setDelegate:self];
    }
    AppRecord *record = [self.appArrays objectAtIndex:indexPath.row];
    cell.record = record;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    // 设置选中效果
//    UIView* selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, cell.bounds.size.width, cell.bounds.size.height-2)];
//    [selectView setBackgroundColor:COLOR(240, 240, 240)];
//    [cell setSelectedBackgroundView:selectView];
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didTouchCommandButton:(AppRecord*)record {
    if( record.m_isOnShow ) {
        
    }
    else {
        [[LaunchAppMgr sharedManager] addLauncherItem:record];
        [self actionTouchBackButton:nil];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
