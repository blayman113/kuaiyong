//
//  SettingsTableViewCell.m
//  KuaiYong
//
//  Created by lijinwei on 15/6/28.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "SettingsTableViewCell.h"

@interface SettingsTableViewCell ()

@property (nonatomic,strong) UILabel *titleNameLabel;
@property (nonatomic,strong) UIImageView* arrowView;
@property (nonatomic,strong) UIView* sepLineView;
@end

@implementation SettingsTableViewCell

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
        [self setupCellView];
    }
    return self;
}

-(void) setupCellView{
    self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-32, 22, 12, 12)];
    self.arrowView.image = [UIImage imageNamed:@"icon_arrow_normal"];
    self.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [self.arrowView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.arrowView];
    
    self.backgroundColor = COLOR_COMMON_BACKGROUND;
    self.titleNameLabel = [[UILabel alloc]  initWithFrame:CGRectMake(20, 10, self.frame.size.width-72 - 72, 42)];
    self.titleNameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleNameLabel.textColor = [UIColor whiteColor];
    [self.titleNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleNameLabel];
    
    // 添加分割线
    CGFloat lineHeight = 0.5;
    if ([[UIScreen mainScreen] scale] == 1)
    {
        lineHeight = 1;
    }
    self.sepLineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-lineHeight, self.contentView.frame.size.width, lineHeight)];
    [self.sepLineView setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.sepLineView];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleNameLabel.text = self.titleName;

    CGFloat lineHeight = 0.5;
    if ([[UIScreen mainScreen] scale] == 1)
    {
        lineHeight = 1;
    }
    [self.sepLineView setFrame:CGRectMake(20, self.contentView.frame.size.height-lineHeight, self.contentView.frame.size.width, lineHeight)];
}

@end
