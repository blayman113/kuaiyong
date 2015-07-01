//
//  LaunchGuideViewController.m
//  KuaiYong
//
//  Created by lijinwei on 15/7/1.
//  Copyright (c) 2015年 lijinwei. All rights reserved.
//

#import "LaunchGuideViewController.h"

const int PAGECOUNT = 3;

@interface LaunchGuideViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton* closeBtn;

@end

@implementation LaunchGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_COMMON_BACKGROUND;
    
    // 根据屏幕设置scrollView的frame
    CGRect bgFrame = [UIScreen mainScreen].bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:bgFrame];
    [self.scrollView setContentSize:CGSizeMake(bgFrame.size.width*PAGECOUNT, bgFrame.size.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator  = YES;
    self.scrollView.bounces = NO;
    self.scrollView .bouncesZoom = NO;
    [self.view addSubview:self.scrollView];
    
    // 添加image
    for (int i=0; i<PAGECOUNT; i++)
    {
        CGRect frame = bgFrame;
        frame.origin.x = bgFrame.size.width*i;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString* imageName = nil;
        if (IS_IPHONE_FOUR) {
            imageName = [NSString stringWithFormat:@"guide_page_small_%d", i];
        }else {
            imageName = [NSString stringWithFormat:@"guide_page_%d@3x", i];
        }
        
        imageView.image = [UIImage imageNamed:imageName];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 添加button
    UIColor* greenColor = COLOR(81, 89, 133);
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [_closeBtn addTarget:self
                  action:@selector(actionTouchCloseButton)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets insets = {2,20,2,20};
    
    if (IS_IPHONE_FOUR) {
        insets = UIEdgeInsetsMake(2,20,2,20);
    }
    UIImage* leftImage = [UIImage imageNamed:@"ocr_result_btn_white.png"];
    
    leftImage = [leftImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    UIImage* highlightedImage = [UIImage imageNamed:@"ocr_result_btn_white_empty.png"];
    highlightedImage = [highlightedImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [_closeBtn setBackgroundImage:leftImage forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [_closeBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    CGFloat height = IS_IPHONE_FOUR ? 90:110;
    [_closeBtn setFrame:CGRectMake((self.scrollView.frame.size.width-130)/2+self.scrollView.frame.size.width*2, self.scrollView.frame.size.height-height, 130, 38)];
    
    [self.scrollView addSubview:_closeBtn];

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

- (void) actionTouchCloseButton
{
    //保存已向用户展示的引导页版本号
    // 获取当前的版本号
    NSBundle * mainBoundle = [NSBundle mainBundle];
    NSString * localVersion = [mainBoundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:localVersion forKey:@"CFBundleShortVersionString"];
    
    if([self.delegate respondsToSelector:@selector(didGuideViewEnded)])
    {
        [self.delegate didGuideViewEnded];
    }
}


// 是否是第一次启动该版本程序
+ (BOOL)firstTimeStartForCurrentVersion
{
    //已向用户展示的引导页的版本号
    NSString* oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    
    BOOL res;
    NSBundle * mainBoundle = [NSBundle mainBundle];
    NSString * localVersion = [mainBoundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![localVersion isEqualToString:oldVersion])
    {
        res = YES;
    }
    else
    {
        res = NO;
    }
    
    return res;
}

@end
