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
    _dbImageView.layer.cornerRadius = 6;
    [self.contentView addSubview:_dbImageView];

    self.backgroundColor = COLOR_COMMON_BACKGROUND;
    self.titleName = [[UILabel alloc]  initWithFrame:CGRectMake(72, 10, self.frame.size.width-72 - 72, 42)];
    self.titleName.font = [UIFont systemFontOfSize:14.0f];
    self.titleName.textColor = [UIColor whiteColor];
    [self.titleName setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleName];
    
    CGRect rectFrame = CGRectMake(self.frame.size.width - 72, 15, 52, 30);
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = rectFrame;
    self.rightButton.layer.cornerRadius = 4;
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green1.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(actionTouchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightButton];
}

-(void)actionTouchButton{
    if( self.delegate )
        [self.delegate didTouchCommandButton:self.record];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleName.text = self.record.m_name;
    [_dbImageView setImageWithPath:self.record.m_icon];
    
    if( self.record.m_isOnShow ) {
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green3.png"] forState:UIControlStateNormal];
    }
    else {
        [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"e_green1.png"] forState:UIControlStateNormal];
    }
}


@end
