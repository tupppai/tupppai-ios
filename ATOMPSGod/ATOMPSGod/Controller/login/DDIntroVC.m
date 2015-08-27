//
//  ATOMIntroductionOnFirstLaunchViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDIntroVC.h"
#import "EAIntroView.h"
#import "DDLaunchVC.h"
@interface DDIntroVC ()<EAIntroDelegate>

@end

@implementation DDIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPages];
}

-(void)createPages {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"intro1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intro3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"intro4"];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    intro.skipButton.hidden = YES;
    intro.pageControl.hidden = YES;
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.3];

}
#pragma mark - EAIntroView delegate
- (void)introDidFinish:(EAIntroView *)introView {
    DDLaunchVC* lvc = [DDLaunchVC new];
    self.navigationController.viewControllers = @[lvc];
}


@end
