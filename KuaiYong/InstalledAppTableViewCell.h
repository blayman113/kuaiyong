//
//  InstalledAppTableViewCell.h
//  KuaiYong
//
//  Created by lijinwei on 15/6/17.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRecord.h"

@protocol InstalledAppTableViewCellDelegate <NSObject>
- (void)didTouchCommandButton:(AppRecord*)record isOnShow:(BOOL)isOnShow;
@end

@interface InstalledAppTableViewCell : UITableViewCell

@property (nonatomic,strong) AppRecord *record;
@property (nonatomic, weak) id<InstalledAppTableViewCellDelegate> delegate;

@end
