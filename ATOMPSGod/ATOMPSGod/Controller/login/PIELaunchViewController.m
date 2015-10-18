//
//  PIELaunchViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/18/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchViewController.h"
#import "DDCreateProfileVC.h"
#import "DDLoginVC.h"
#import "AppDelegate.h"
#import "DDShareSDKManager.h"

@interface PIELaunchViewController ()
@property (weak, nonatomic) IBOutlet UIView *weiboContainerView;
@property (weak, nonatomic) IBOutlet UILabel *weiboSignUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasAccountLabel;

@end

@implementation PIELaunchViewController
-(BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, - NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:0xFFF00D] CGColor], (id)[[UIColor colorWithHex:0xFFEF00] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    _weiboSignUpLabel.textColor = [UIColor colorWithHex:0x50484B];
    _otherWayLabel.textColor = [UIColor colorWithHex:0x50484B];
    _hasAccountLabel.textColor = [UIColor colorWithHex:0x50484B];
    
    _weiboContainerView.layer.cornerRadius = 24;
    _otherWayLabel.layer.cornerRadius = 24;
    _hasAccountLabel.layer.cornerRadius = 24;
    
    _weiboContainerView.layer.borderWidth = 0.5;
    _otherWayLabel.layer.borderWidth = 0.5;
    _hasAccountLabel.layer.borderWidth = 0.5;
    
    _weiboContainerView.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
    _otherWayLabel.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
    _hasAccountLabel.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
    
    _otherWayLabel.highlightedTextColor = [UIColor whiteColor];
    _hasAccountLabel.highlightedTextColor = [UIColor whiteColor];
    _weiboSignUpLabel.highlightedTextColor = [UIColor whiteColor];
    
    _weiboContainerView.userInteractionEnabled = YES;
    _otherWayLabel.userInteractionEnabled = YES;
    _hasAccountLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3)];

    [_weiboContainerView addGestureRecognizer:tap1];
    [_otherWayLabel addGestureRecognizer:tap2];
    [_hasAccountLabel addGestureRecognizer:tap3];
    

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

- (void)tap1 {
    
}
- (void)tap2 {
    [DDUserManager currentUser].signUpType = ATOMSignUpMobile;
    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
    [self.navigationController pushViewController:cpvc animated:YES];
}

- (void)tap3 {
    DDLoginVC *lvc = [DDLoginVC new];
    [self.navigationController pushViewController:lvc animated:YES];
}
- (void)clickLoginButton:(UIButton *)sender {
    DDLoginVC *lvc = [DDLoginVC new];
    [self.navigationController pushViewController:lvc animated:YES];
}

@end
