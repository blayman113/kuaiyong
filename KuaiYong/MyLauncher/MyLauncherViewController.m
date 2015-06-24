//
//  MyLauncherViewController.m
//  @rigoneri
//  
//  Copyright 2010 Rodrigo Neri
//  Copyright 2011 David Jarrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MyLauncherViewController.h"
#import "UIHelper.h"
#import "AddAppLaunchViewController.h"
#import "LaunchAppMgr.h"

@interface MyLauncherViewController ()
-(NSMutableArray *)loadLauncherItems;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) CGRect statusBarFrame;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) BOOL isEditing;
@end

@implementation MyLauncherViewController

@synthesize launcherNavigationController = _launcherNavigationController;
@synthesize launcherView = _launcherView;
@synthesize appControllers = _appControllers;
@synthesize overlayView = _overlayView;
@synthesize currentViewController = _currentViewController;
@synthesize statusBarFrame = _statusBarFrame;

#pragma mark - ViewController lifecycle

-(id)init {
	if((self = [super init])) { 
		self.title = @"myLauncher";
	}
	return self;
}

-(void)loadView {
	[super loadView];
	
	[self setLauncherView:[[MyLauncherView alloc] initWithFrame:self.view.bounds]];
	[self.launcherView setBackgroundColor:COLOR(234,237,250)];
	[self.launcherView setDelegate:self];
	self.view = self.launcherView;
	
    [self.launcherView setPages:[self loadLauncherItems]];
    [self.launcherView setNumberOfImmovableItems:[(NSNumber *)[Tools retrieveFromUserDefaults:@"myLauncherViewImmovable"] intValue]];
    
    [self setAppControllers:[[NSMutableDictionary alloc] init]];
    [self setStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    
    self.isEditing = NO;
    
    [self initNavBtn];
}

- (void)initNavBtn{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 32);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIHelper normalImageForReturnButtonWithSize:@"settings.png" toBtnSize:leftButton.frame.size] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 60, 32);
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
    
    [self.rightButton addTarget:self action:@selector(enterEditing) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect rectFrame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.frame = rectFrame;
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 1, 0);
    [rightButton setTitle:@"添加应用" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
    [rightButton addTarget:self action:@selector(addLaunchApp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.launcherView viewDidAppear:animated];
}

- (void)addLaunchApp{
    AddAppLaunchViewController* addAppVC = [[AddAppLaunchViewController alloc] init];
    addAppVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:addAppVC animated:YES];
}

- (void)openSettings {
    
}

- (void)enterEditing {
    if( self.isEditing){
        [self.launcherView performSelector:@selector(endEditing) withObject:nil];
    }
    else{
        [self.launcherView performSelector:@selector(beginEditing) withObject:nil];
    }
}

- (void)viewWillLayoutSubviews {
    if (!CGRectEqualToRect(self.statusBarFrame, [[UIApplication sharedApplication] statusBarFrame])) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        if (self.launcherNavigationController) {
            CGRect navConFrame = self.launcherNavigationController.view.bounds;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect navBarFrame = self.launcherNavigationController.navigationBar.frame;
                [self.launcherNavigationController.navigationBar setFrame:CGRectMake(navBarFrame.origin.x, statusBarFrame.size.height, navBarFrame.size.width, navBarFrame.size.height)];                
                [self.launcherNavigationController.view setFrame:CGRectMake(navConFrame.origin.x, navConFrame.origin.y, navConFrame.size.width, navConFrame.size.height)];
            } completion:^(BOOL finished){
                [self.launcherNavigationController.view setNeedsLayout];
            }];
        }
        [self setStatusBarFrame:statusBarFrame];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.launcherView setCurrentOrientation:toInterfaceOrientation];
    if (self.launcherNavigationController) {
        [self.launcherNavigationController setNavigationBarHidden:YES];
        [self.launcherNavigationController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if(self.launcherNavigationController) {
        [self.launcherNavigationController setNavigationBarHidden:NO];
        [self.launcherNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
	
	self.overlayView.frame = self.launcherView.frame;
	[self.launcherView layoutLauncher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - MyLauncherItem management

-(BOOL)hasSavedLauncherItems {
    return ([Tools retrieveFromUserDefaults:@"myLauncherView"] != nil);
}

-(void)launcherViewItemSelected:(MyLauncherItem*)item {
    BOOL launchSuccess = [[LaunchAppMgr sharedManager] launchAppItem:item];
    if( !launchSuccess ) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"该启动项无法在软件内打开，请前往通知栏中点击打开"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)launcherViewDidBeginEditing:(id)sender {
    self.isEditing = YES;
    [self.rightButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
}

-(void)launcherViewDidEndEditing:(id)sender {
    self.isEditing = NO;
    [self.rightButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
}

- (void)closeView {
    UIView *viewToClose = [[self.launcherNavigationController topViewController] view];
    if (!viewToClose)
        return;
    
	viewToClose.transform = CGAffineTransformIdentity;
    
	[UIView animateWithDuration:0.3 
						  delay:0 
						options:UIViewAnimationOptionCurveEaseOut 
					 animations:^{
						 viewToClose.alpha = 0;		
						 viewToClose.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
						 self.overlayView.alpha = 0;
					 }
					 completion:^(BOOL finished){
                         if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0) {
                             [[self.launcherNavigationController topViewController] viewWillDisappear:NO];
                         }
                         [[self.launcherNavigationController view] removeFromSuperview];
                         if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0) {
                             [[self.launcherNavigationController topViewController] viewDidDisappear:NO];
                         }
                         [self.launcherNavigationController setDelegate:nil];
                         [self setLauncherNavigationController:nil];
                         [self setCurrentViewController:nil];
						 [self.parentViewController viewWillAppear:NO];
						 [self.parentViewController viewDidAppear:NO];
					 }];
}

#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0) {
        if (self.currentViewController) {
            [self.currentViewController viewWillDisappear:animated];
        }
        [viewController viewWillAppear:animated];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 5.0) {
        if (self.currentViewController) {
            [self.currentViewController viewDidDisappear:animated];
        }
        [viewController viewDidAppear:animated];
    }
    [self setCurrentViewController:viewController];
}

#pragma mark - myLauncher caching

-(NSMutableArray *)loadLauncherItems {
    NSMutableArray *savedLauncherItems = [[LaunchAppMgr sharedManager] getSaveLauncherItems];
	if(savedLauncherItems) {
        return savedLauncherItems;
    }
	return nil;
}

-(void)clearSavedLauncherItems {
    [Tools saveToUserDefaults:nil key:@"myLauncherView"];
    [Tools saveToUserDefaults:nil key:@"myLauncherViewImmovable"];
}

@end
