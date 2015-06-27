//
//  InstalledAppTableViewCell.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/17.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "InstalledAppTableViewCell.h"
#import "DBImageView.h"

@interface InstalledAppTableViewCell ()
{
    DBImageView *_dbImageView;
}
@property (nonatomic,strong) UILabel *titleName;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UISwitch* switchBtn;
@property (nonatomic,strong) UIView* sepLineView;

@end

@implementation InstalledAppTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInstalledAppCellView];
    }
    return self;
}


-(void) setupInstalledAppCellView{
    _dbImageView = [[DBImageView alloc] initWithFrame:CGRectMake(20, 10, 42, 42)];
    _dbImageView.contentMode = UIViewContentModeScaleAspectFit;
    _dbImageView.layer.cornerRadius = 8;
    [_dbImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_dbImageView];

    self.backgroundColor = COLOR_COMMON_BACKGROUND;
    self.titleName = [[UILabel alloc]  initWithFrame:CGRectMake(72, 10, self.frame.size.width-72 - 72, 42)];
    self.titleName.font = [UIFont systemFontOfSize:14.0f];
    self.titleName.textColor = [UIColor whiteColor];
    [self.titleName setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleName];
    
    CGRect rectFrame = CGRectMake(self.frame.size.width - 72, 15, 52, 30);
    self.switchBtn = [[UISwitch alloc] initWithFrame:rectFrame];
//    self.switchBtn.onTintColor=[UIColor greenColor];
//    self.switchBtn.tintColor=[UIColor grayColor];
    self.switchBtn.thumbTintColor=[UIColor whiteColor];
    [self.switchBtn addTarget:self action:@selector(touchSwitchBtn:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchBtn];
    
    // 添加分割线
    CGFloat lineHeight = 0.5;
    if ([[UIScreen mainScreen] scale] == 1)
    {
        lineHeight = 1;
    }
    self.sepLineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-lineHeight, self.contentView.frame.size.width, lineHeight)];
    [self.sepLineView setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.sepLineView];
    /*
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = rectFrame;
    self.rightButton.layer.cornerRadius = 4;
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green1.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(actionTouchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightButton];
     */
}

-(void)touchSwitchBtn:(id)sender {
    UISwitch *switchBtn=(UISwitch *)sender;
    if( self.delegate )
        [self.delegate didTouchCommandButton:self.record isOnShow:switchBtn.isOn];
}

-(void)actionTouchButton{
    if( self.delegate )
        [self.delegate didTouchCommandButton:self.record isOnShow:YES];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleName.text = self.record.m_name;
    if( self.record.m_isSystemApp) {
        [_dbImageView setImage:[UIImage imageNamed:self.record.m_icon]];
    }
    else {
        [_dbImageView setImageWithPath:nil];
        [_dbImageView setImageWithPath:self.record.m_icon];
    }
    
    if( self.record.m_isOnShow ) {
        [self.switchBtn setOn:YES animated:YES];
//        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
//        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green3.png"] forState:UIControlStateNormal];
    }
    else {
        [self.switchBtn setOn:NO animated:YES];
//        [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
//        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green1.png"] forState:UIControlStateNormal];
    }
    
    CGFloat lineHeight = 0.5;
    if ([[UIScreen mainScreen] scale] == 1)
    {
        lineHeight = 1;
    }
    [self.sepLineView setFrame:CGRectMake(20, self.contentView.frame.size.height-lineHeight, self.contentView.frame.size.width, lineHeight)];
}


@end
