//
//  ATOMLaunchViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLaunchViewController.h"
#import "ATOMLaunchView.h"
#import "ATOMCreateProfileViewController.h"
#import "ATOMLoginViewController.h"

@interface ATOMLaunchViewController ()

@property (nonatomic, strong) ATOMLaunchView *launchView;

@end

@implementation ATOMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)createUI {
    _launchView = [ATOMLaunchView new];
    self.view = _launchView;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backImageView setImage:[UIImage imageNamed:@"ps_bg"]];
    [_launchView addSubview:backImageView];
    [_launchView sendSubviewToBack:backImageView];
    [_launchView.wxRegisterButton addTarget:self action:@selector(clickWXRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_launchView.otherRegisterButton addTarget:self action:@selector(clickOtherRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_launchView.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickWXRegisterButton:(UIButton *)sender {
    
}

- (void)clickOtherRegisterButton:(UIButton *)sender {
    ATOMCreateProfileViewController *cpvc = [ATOMCreateProfileViewController new];
    [self pushViewController:cpvc animated:YES];
}

- (void)clickLoginButton:(UIButton *)sender {
    ATOMLoginViewController *lvc = [ATOMLoginViewController new];
    [self pushViewController:lvc animated:YES];
}






@end
