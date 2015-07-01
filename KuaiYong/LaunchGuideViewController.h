//
//  LaunchGuideViewController.h
//  KuaiYong
//
//  Created by lijinwei on 15/7/1.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LaunchGuideViewControllerDelegate <NSObject>
- (void) didGuideViewEnded;
@end

@interface LaunchGuideViewController : UIViewController

@property (nonatomic,assign) id<LaunchGuideViewControllerDelegate> delegate;

+ (BOOL)firstTimeStartForCurrentVersion;

@end
