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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EditLaunchAppViewController.h"
#import "SettingsViewController.h"

@interface MyLauncherViewController () <ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>
-(NSMutableArray *)loadLauncherItems;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) CGRect statusBarFrame;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) ABPeoplePickerNavigationController* picker;
@property (nonatomic, assign) BOOL isClickMessage;
@end

@implementation MyLauncherViewController

@synthesize launcherNavigationController = _launcherNavigationController;
@synthesize launcherView = _launcherView;
@synthesize overlayView = _overlayView;
@synthesize currentViewController = _currentViewController;
@synthesize statusBarFrame = _statusBarFrame;

#pragma mark - ViewController lifecycle

-(id)init {
	if((self = [super init])) { 
		self.title = @"快用";
	}
	return self;
}

-(void)loadView {
	[super loadView];
	
	[self setLauncherView:[[MyLauncherView alloc] initWithFrame:self.view.bounds]];
	[self.launcherView setBackgroundColor:COLOR_COMMON_BACKGROUND];
	[self.launcherView setDelegate:self];
	
    [self.launcherView setPages:[self loadLauncherItems]];
    
    [self setStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    self.view = self.launcherView;
    
    self.isEditing = NO;
    
    [self initNavBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(launcherItemChangedNotification:)
                                                 name:kLauncherItemChangedNotification
                                               object:nil];
}

- (void)launcherItemChangedNotification:(NSNotification *)aNotification {
    [self.launcherView addLaunchItem:aNotification.object];
//    [self.launcherView setPages:[self loadLauncherItems]];
//    [self.launcherView performSelector:@selector(launcherItemChanged) withObject:aNotification.object];
}

- (void)initNavBtn{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 60, 32);
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton setBackgroundImage:[UIHelper normalImageForReturnButtonWithSize:@"settings.png" toBtnSize:self.leftButton.frame.size] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
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

    int offsetX = 20;
    int btnHeight = 92;
    int btnWidth = (self.view.frame.size.width - offsetX*4)/3;

    CGRect rectBottom = CGRectMake(0, self.view.frame.size.height - btnHeight, self.view.frame.size.width, btnHeight);
    UIView* bottomView = [[UIView alloc] initWithFrame:rectBottom];
    [bottomView setBackgroundColor:COLOR(81, 89, 133)];
    
    [self.view addSubview:bottomView];

    CGRect rectFrame = CGRectMake(offsetX, bottomView.frame.size.height - btnHeight, btnWidth, btnHeight);

    AppRecord* phoneRecord = [AppRecord initAppRecord:@"app_phone.png" toName:@"添加联系人" toScheme:@"tel" isSystemApp:YES isPrefsRoot:NO];
    MyLauncherItem *phoneItem = [[MyLauncherItem alloc] initWithRecord:phoneRecord];
    phoneItem.frame = rectFrame;
	phoneItem.delegate = self;
//    phoneItem.itemWidth = 40;
    [phoneItem layoutItem];
    [phoneItem addTarget:self action:@selector(addContactApp) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneItem];
    
    rectFrame = CGRectMake(rectFrame.origin.x+rectFrame.size.width+offsetX, bottomView.frame.size.height - btnHeight, btnWidth, btnHeight);
    AppRecord* msgRecord = [AppRecord initAppRecord:@"app_imessage.png" toName:@"添加短信" toScheme:@"sms" isSystemApp:YES isPrefsRoot:NO];
    MyLauncherItem *msgItem = [[MyLauncherItem alloc] initWithRecord:msgRecord];
    msgItem.frame = rectFrame;
    msgItem.delegate = self;
//    msgItem.itemWidth = 40;
    [msgItem layoutItem];
    [msgItem addTarget:self action:@selector(addMessageApp) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:msgItem];
    
    rectFrame = CGRectMake(rectFrame.origin.x+rectFrame.size.width+offsetX, bottomView.frame.size.height - btnHeight, btnWidth, btnHeight);
    AppRecord* appRecord = [AppRecord initAppRecord:@"app_app.png" toName:@"添加应用" toScheme:@"app" isSystemApp:YES isPrefsRoot:NO];
    MyLauncherItem *appItem = [[MyLauncherItem alloc] initWithRecord:appRecord];
    appItem.frame = rectFrame;
    appItem.delegate = self;
//    appItem.itemWidth = 40;
    [appItem layoutItem];
    [appItem addTarget:self action:@selector(addLaunchApp) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.launcherView viewDidAppear:animated];
}

- (void)addContactApp{
    if( self.isEditing){
        [self.launcherView performSelector:@selector(endEditing) withObject:nil];
    }
    
    NSInteger addItemCount = [self.launcherView.pages count];
    if( addItemCount >= 16) {
        [self cannotAddApp];
        return;
    }

    self.isClickMessage = NO;
    self.picker = nil;
    if(!self.picker){
        self.picker = [[ABPeoplePickerNavigationController alloc] init];
        // place the delegate of the picker to the controll
        self.picker.peoplePickerDelegate = self;
        self.picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)cannotAddApp {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加启动器数目已满" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)addMessageApp{
    if( self.isEditing){
        [self.launcherView performSelector:@selector(endEditing) withObject:nil];
    }
    
    NSInteger addItemCount = [self.launcherView.pages count];
    if( addItemCount >= 16) {
        [self cannotAddApp];
        return;
    }
    
    self.isClickMessage = YES;
    self.picker = nil;
    if(!self.picker){
        self.picker = [[ABPeoplePickerNavigationController alloc] init];
        // place the delegate of the picker to the controll
        self.picker.peoplePickerDelegate = self;
        self.picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)addLaunchApp{
    if( self.isEditing){
        [self.launcherView performSelector:@selector(endEditing) withObject:nil];
    }
    
    AddAppLaunchViewController* addAppVC = [[AddAppLaunchViewController alloc] init];
    addAppVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:addAppVC animated:YES];
}

- (void)openSettings {
    SettingsViewController* settingsVC = [[SettingsViewController alloc] init];
    settingsVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:settingsVC animated:YES];
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
    self.leftButton.enabled = NO;
    [self.rightButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
}

-(void)launcherViewDidEndEditing:(id)sender {
    self.isEditing = NO;
    self.leftButton.enabled = YES;
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
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11) {
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (firstName==nil) {
            firstName=@"";
        }
        NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (lastName==nil) {
            lastName=@"";
        }
        NSString* fullName = [NSString stringWithFormat:@"%@%@", firstName, lastName];
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            EditLaunchAppViewController* editAppVC = [[EditLaunchAppViewController alloc] init];
            if( self.isClickMessage ) {
                editAppVC.imageName = @"app_imessage";
                editAppVC.scheme=@"sms://";
            }
            else {
                editAppVC.imageName = @"app_phone";
                editAppVC.scheme=@"tel://";
            }
            editAppVC.name = fullName;
            editAppVC.value = phoneNO;
            [self.navigationController pushViewController:editAppVC animated:YES];
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
