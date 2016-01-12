//
//  ATOMIntroductionOnFirstLaunchViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDIntroVC.h"
#import "EAIntroView.h"
//#import "PIELaunchViewController.h"
#import "PIELaunchViewController_Black.h"

@interface DDIntroVC ()<EAIntroDelegate>
@property (nonatomic,strong)  EAIntroPage *page1;
@property (nonatomic,strong)  EAIntroPage *page2;
@property (nonatomic,strong)  EAIntroPage *page3;
@property (nonatomic,strong)  EAIntroPage *page4;

@end

@implementation DDIntroVC

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPages];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage     = [UIImage new];
    self.navigationController.navigationBar.translucent     = YES;
    self.navigationController.view.backgroundColor          = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Initial UI setup
-(void)createPages {
    
    // ## Step 1: 设置introPage
    EAIntroView *intro = [[EAIntroView alloc]
                          initWithFrame:self.view.bounds
                          andPages:@[self.page1,self.page2,self.page3,self.page4]];
    intro.skipButton.hidden                         = YES;
    intro.useMotionEffects                          = YES;
    intro.pageControl.hidden                        = NO;
    intro.pageControlY                              = 43;
    intro.pageControl.pageIndicatorTintColor        = [UIColor colorWithHex:0xffffff andAlpha:0.5];
    intro.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0xffffff andAlpha:0.9];
    intro.tapToNext                                 = YES;
    
    
    UIButton* skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    
    [skipButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@29);
        make.height.equalTo(@29);
    }];
    [skipButton setBackgroundImage:[UIImage imageNamed:@"pie_intro_nextStepButton"]
                          forState:UIControlStateNormal];

    intro.skipButton                   = skipButton;
    intro.skipButtonY                  = 55;
    intro.skipButtonSideMargin
    = (SCREEN_WIDTH - CGRectGetWidth(skipButton.frame)) / 2;
    intro.showSkipButtonOnlyOnLastPage = YES;
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:1.0];

}


#pragma mark - EAIntroView delegate
- (void)introDidFinish:(EAIntroView *)introView {
    PIELaunchViewController_Black* lvc        = [PIELaunchViewController_Black new];
    self.navigationController.viewControllers = @[lvc];
}


- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex
{
    if (pageIndex == 3) {
        [UIView animateWithDuration:1.4
                         animations:^{
                             introView.pageControl.hidden = YES;
                         }];
    }else{
        introView.pageControl.hidden = NO;
    }
}

#pragma mark - Lazy loadings

-(EAIntroPage *)page1 {
    if (!_page1) {
        _page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"intro1"];
    }
    return _page1;
}

-(EAIntroPage *)page2 {
    if (!_page2) {
        _page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"intro2"];
    }
    return _page2;
}
-(EAIntroPage *)page3 {
    if (!_page3) {
        _page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"intro3"];
    }
    return _page3;
}

-(EAIntroPage *)page4 {
    if (!_page4) {
        
        _page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"intro4"];

//        _page4 = [EAIntroPage page];
//        _page4.bgColor = [UIColor pieYellowColor];
////        _page4.title = @"一个有想法的图片玩乐社区";
//        _page4.titleColor = [UIColor colorWithHex:0x50484b];
//        _page4.titleFont = [UIFont systemFontOfSize:18];
//        _page4.titlePositionY = SCREEN_HEIGHT*0.75;
//        
//        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 80, 80)];
//        imageView.image = [UIImage imageNamed:@"pie_launch_logo"];
//        _page4.titleIconView = imageView;
//        
//        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200), 200, 50)];
//        label.text = @"进入图派";
//        label.backgroundColor = [UIColor clearColor];
//        label.layer.borderColor = [UIColor blackColor].CGColor;
//        label.layer.borderWidth = 1.0;
//        label.layer.cornerRadius = 6.0;
//        label.clipsToBounds = YES;
//        label.textAlignment = NSTextAlignmentCenter;
//        [label setFont:[UIFont systemFontOfSize:22]];
//        _page4.subviews = @[label];
    }
    return _page4;
}

@end
