//
//  ATOMIntroductionOnFirstLaunchViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDIntroVC.h"
#import "EAIntroView.h"
#import "PIELaunchViewController.h"
@interface DDIntroVC ()<EAIntroDelegate>
@property (nonatomic,strong)  EAIntroPage *page1;
@property (nonatomic,strong)  EAIntroPage *page2;
@property (nonatomic,strong)  EAIntroPage *page3;
@property (nonatomic,strong)  EAIntroPage *page4;

@end

@implementation DDIntroVC

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
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

-(void)createPages {
        
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[self.page1,self.page2,self.page3,self.page4]];
    intro.skipButton.hidden = YES;
    intro.useMotionEffects = YES;
    intro.pageControl.hidden = NO;
    intro.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    intro.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

    intro.tapToNext = YES;
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.3];

}


#pragma mark - EAIntroView delegate
- (void)introDidFinish:(EAIntroView *)introView {
    PIELaunchViewController* lvc = [PIELaunchViewController new];
    self.navigationController.viewControllers = @[lvc];
}

-(EAIntroPage *)page1 {
    if (!_page1) {
        _page1 = [EAIntroPage page];
        _page1.bgColor = [UIColor pieYellowColor];
        _page1.title = @"PS玩家云集";
        _page1.desc = @"搞定你千奇百怪的P图需求";
        _page1.titleColor = [UIColor blackColor];
        _page1.titleFont = [UIFont boldSystemFontOfSize:34];
        _page1.titlePositionY = SCREEN_HEIGHT*0.8;
        _page1.descColor = [UIColor colorWithHex:0x50484b];
        _page1.descFont = [UIFont systemFontOfSize:18];
        _page1.descPositionY = SCREEN_HEIGHT*0.7;
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-350), 250, 350)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"intro1"];
        _page1.subviews = @[imageView];
    }
    return _page1;
}

-(EAIntroPage *)page2 {
    if (!_page2) {
        _page2 = [EAIntroPage page];
        _page2.bgColor = [UIColor pieYellowColor];
        _page2.title = @"小白进阶 高手练成";
        _page2.desc = @"我们陪你成长 陪你走上热门榜";
        _page2.titleColor = [UIColor blackColor];
        _page2.titleFont = [UIFont boldSystemFontOfSize:34];
        _page2.descColor = [UIColor colorWithHex:0x50484b];
        _page2.descFont = [UIFont systemFontOfSize:18];
        _page2.titlePositionY = SCREEN_HEIGHT*0.8;
        _page2.descPositionY = SCREEN_HEIGHT*0.7;

        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-350), 250, 350)];
        imageView.image = [UIImage imageNamed:@"intro2"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _page2.subviews = @[imageView];
    }
    return _page2;
}
-(EAIntroPage *)page3 {
    if (!_page3) {
        _page3 = [EAIntroPage page];
        _page3.bgColor = [UIColor pieYellowColor];
        _page3.title = @"社区活动 交友切磋";
        _page3.desc = @"你喜欢的 他们可能也喜欢";
        _page3.titleColor = [UIColor blackColor];
        _page3.titleFont = [UIFont boldSystemFontOfSize:34];
        _page3.titlePositionY = SCREEN_HEIGHT*0.8;
        _page3.descColor = [UIColor colorWithHex:0x50484b];
        _page3.descFont = [UIFont systemFontOfSize:18];
        _page3.descPositionY = SCREEN_HEIGHT*0.7;

        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-350), 250, 350)];
        imageView.image = [UIImage imageNamed:@"intro3"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _page3.subviews = @[imageView];
    }
    return _page3;
}

-(EAIntroPage *)page4 {
    if (!_page4) {
        _page4 = [EAIntroPage page];
        _page4.bgColor = [UIColor pieYellowColor];
        _page4.title = @"一个有想法的图片玩乐社区";
        _page4.titleColor = [UIColor colorWithHex:0x50484b];
        _page4.titleFont = [UIFont systemFontOfSize:18];
        _page4.titlePositionY = SCREEN_HEIGHT*0.75;
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 80, 80)];
        imageView.image = [UIImage imageNamed:@"pie_launch_logo"];
        _page4.titleIconView = imageView;
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, (SCREEN_HEIGHT-200), 200, 50)];
        label.text = @"进入图派";
        label.backgroundColor = [UIColor clearColor];
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1.0;
        label.layer.cornerRadius = 6.0;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:22]];
        _page4.subviews = @[label];
    }
    return _page4;
}

@end
