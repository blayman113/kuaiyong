//
//  MyLauncherItem.h
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

#import <UIKit/UIKit.h>
#import "AppRecord.h"

@protocol MyLauncherItemDelegate <NSObject>
-(void)didDeleteItem:(id)item;
-(void)itemTouchedUpInside:(id)item;
-(void)itemTouchedUpOutside:(id)item;
-(void)itemTouchedDown:(id)item;
-(void)itemTouchCancelled:(id)item;
@end

@interface MyLauncherItem : UIControl {	
	BOOL dragging;
	BOOL deletable;
    BOOL titleBoundToBottom;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *iPadImage;
@property (nonatomic, retain) NSString *controllerStr;
@property (nonatomic, retain) NSString *controllerTitle;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, strong) AppRecord* apprecord;


-(id)initWithRecord:(AppRecord*)record;
-(id)initWithTitle:(NSString *)title image:(NSString *)image target:(NSString *)targetControllerStr deletable:(BOOL)_deletable;
-(id)initWithTitle:(NSString *)title iPhoneImage:(NSString *)image iPadImage:(NSString *)iPadImage target:(NSString *)targetControllerStr targetTitle:(NSString *)targetTitle deletable:(BOOL)_deletable;
-(void)layoutItem;
-(void)setDragging:(BOOL)flag;
-(BOOL)dragging;
-(BOOL)deletable;

-(BOOL)titleBoundToBottom;
-(void)setTitleBoundToBottom:(BOOL)bind;

@end