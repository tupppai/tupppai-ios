//
//  ATOMIntroductionOnFirstLaunchViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/6/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMIntroductionOnFirstLaunchViewController.h"
#import "EAIntroView.h"

@interface ATOMIntroductionOnFirstLaunchViewController ()<EAIntroDelegate>

@end

@implementation ATOMIntroductionOnFirstLaunchViewController

- (void)viewDidLoad {
    NSLog(@"ATOMIntroductionOnFirstLaunchViewController.h viewDidLoad");
    self.title = @"介绍页面";
    [super viewDidLoad];
    [self createPages];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"ATOMIntroductionOnFirstLaunchViewController.h viewWillAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createPages {
    NSLog(@"createPages");
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.bgImage = [UIImage imageNamed:@"psps"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.bgImage = [UIImage imageNamed:@""];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"love you";
    page3.bgImage = [UIImage imageNamed:@"back"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.bgImage = [UIImage imageNamed:@"intro4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    intro.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"self %@",NSStringFromCGRect(self.view.bounds));

    NSLog(@"intro%@",NSStringFromCGRect(intro.bounds));

    [intro showInView:self.view animateDuration:0.3];

}


@end
