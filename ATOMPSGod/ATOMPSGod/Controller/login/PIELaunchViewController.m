//
//  PIELaunchViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/18/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchViewController.h"
#import "DDCreateProfileVC.h"
#import "PIELoginViewController.h"
#import "AppDelegate.h"
#import "DDShareSDKManager.h"
#import "PIESignUpView.h"
@interface PIELaunchViewController ()<PIESignUpViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *weiboContainerView;
@property (weak, nonatomic) IBOutlet UILabel *weiboSignUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasAccountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (nonatomic,strong) PIESignUpView* signUpView;
@end

@implementation PIELaunchViewController
-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(PIESignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [PIESignUpView new];
        _signUpView.delegate = self;
    }
    return _signUpView;
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
//    _hasAccountLabel.layer.borderWidth = 0.5;
    
    _weiboContainerView.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
    _otherWayLabel.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
//    _hasAccountLabel.layer.borderColor = [UIColor colorWithHex:0x50484B].CGColor;
    _hasAccountLabel.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.7];
    _hasAccountLabel.clipsToBounds = YES;
    
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(50).with.priorityHigh();
//    }];
//    [UIView animateWithDuration:2 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}
- (void)tap1 {
    [DDShareSDKManager authorize:SSDKPlatformTypeSinaWeibo withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openID = sourceData[@"idstr"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openID forKey:@"openid"];
            [DDUserManager DD3PartyAuth:param AndType:@"weibo" withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [Hud activity:@"" inView:self.view];
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else {
                    [DDUserManager currentUser].signUpType = ATOMSignUpWeibo;
                    [DDUserManager currentUser].sourceData = sourceData;
                    ATOMUserProfileViewModel* ipvm = [ATOMUserProfileViewModel new];
                    ipvm.nickName = sourceData[@"name"];
                    ipvm.province = sourceData[@"province"];
                    ipvm.city = sourceData[@"city"];
                    ipvm.avatarURL = sourceData[@"avatar_large"];
                    if ([(NSString*)sourceData[@"gender"] isEqualToString:@"m"]) {
                        ipvm.gender = @"男";
                    } else {
                        ipvm.gender = @"女";
                    }
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
                    cpvc.userProfileViewModel = ipvm;
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
                
            }];
        }
        else {
            NSLog(@"获取不到第三平台的数据");
        }
    }];
}
- (void)tap2 {
    [self.signUpView show];
}

- (void)tap3 {
    PIELoginViewController *lvc = [PIELoginViewController new];
    [self.navigationController pushViewController:lvc animated:YES];
}
- (void)clickLoginButton:(UIButton *)sender {
    PIELoginViewController *lvc = [PIELoginViewController new];
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)tapSignUp1 {
    
}
-(void)tapSignUp2 {
    [self.signUpView dismiss];
    [DDShareSDKManager authorize:SSDKPlatformTypeWechat withBlock:^(NSDictionary *sourceData) {
        if (sourceData) {
            NSString* openid = sourceData[@"openid"];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:openid forKey:@"openid"];
            
            [DDUserManager DD3PartyAuth:param AndType:@"weixin" withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                } else  {
                    [DDUserManager currentUser].signUpType = ATOMSignUpWechat;
                    [DDUserManager currentUser].sourceData = sourceData;
                    ATOMUserProfileViewModel* ipvm = [ATOMUserProfileViewModel new];
                    ipvm.nickName = sourceData[@"nickname"];
                    ipvm.province = sourceData[@"province"];
                    ipvm.city = sourceData[@"city"];
                    ipvm.avatarURL = sourceData[@"headimgurl"];
                    if ((BOOL)sourceData[@"sex"] == YES) {
                        ipvm.gender = @"男";
                    } else {
                        ipvm.gender = @"女";
                    }
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
                    cpvc.userProfileViewModel = ipvm;
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
            }];
        }
        else {
            NSLog(@"获取不到第三平台的数据");
        }
    }];
}
-(void)tapSignUp3 {
    [self.signUpView dismiss];
    [DDUserManager currentUser].signUpType = ATOMSignUpMobile;
    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
    [self.navigationController pushViewController:cpvc animated:YES];
}
-(void)tapSignUpClose {
    [self.signUpView dismiss];
}


@end
