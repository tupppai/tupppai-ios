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
    gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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

    UITapGestureRecognizer * tapLogo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLogo)];
    tapLogo.numberOfTapsRequired = 14;
    _logoView.userInteractionEnabled = YES;
    [_logoView addGestureRecognizer:tapLogo];
}

- (void)tapLogo {
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"baozou"];
    [self.view addSubview:imgView];

    if ([[[DDSessionManager shareHTTPSessionManager].baseURL absoluteString] isEqualToString: baseURLString]) {
        [[NSUserDefaults standardUserDefaults]setObject:baseURLString_Test forKey:@"BASEURL"];
        [Hud activity:@"切换到到测试服测试服测试服测试服"];
        [UIView animateWithDuration:2 animations:^{
            self.view.backgroundColor = [UIColor blackColor];
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.view.alpha = 1.0;
            [imgView removeFromSuperview];
            [Hud dismiss];
            [DDSessionManager resetSharedInstance];
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:baseURLString forKey:@"BASEURL"];
        [Hud activity:@"切换到正式服正式服正式服正式服正式服"];
        [UIView animateWithDuration:2 animations:^{
            self.view.backgroundColor = [UIColor blackColor];
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.view.alpha = 1.0;
            [imgView removeFromSuperview];
            [Hud dismiss];
            [DDSessionManager resetSharedInstance];

        }];
    }
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
}


- (void)login:(ATOMSignUpType)type {
    NSString* typeStr = @"error";
    SSDKPlatformType platformType = SSDKPlatformTypeAny;
    if (type == ATOMSignUpQQ) {
        typeStr = @"qq";
        platformType = SSDKPlatformTypeQQ;
    } else if (type == ATOMSignUpWechat) {
        typeStr = @"weixin";
        platformType = SSDKPlatformTypeWechat;
    } else if (type == ATOMSignUpWeibo) {
        typeStr = @"weibo";
        platformType = SSDKPlatformTypeSinaWeibo;
    } else if (type == ATOMSignUpMobile) {
        
    }
    [DDShareManager authorize2:platformType withBlock:^(SSDKUser *sdkUser) {
        if (sdkUser) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:sdkUser.uid forKey:@"openid"];
                        
            [DDUserManager DD3PartyAuth:param AndType:typeStr withBlock:^(bool isRegistered, NSString *info) {
                if (isRegistered) {
                    [self.navigationController setViewControllers:[NSArray array]];
                    [AppDelegate APP].mainTabBarController = nil;
                    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
                    ;
                } else {
                    [[NSUserDefaults standardUserDefaults]setObject:@(type) forKey:@"SignUpType"];
                    
                    NSMutableDictionary* dic = [NSMutableDictionary new];
                    [dic setObject:sdkUser.uid forKey:@"uid"];
                    [dic setObject:sdkUser.icon forKey:@"icon"];
                    [dic setObject:@(sdkUser.gender) forKey:@"gender"];
                    [dic setObject:sdkUser.nickname forKey:@"nickname"];
                    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"SdkUser"];
                    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
                    [self.navigationController pushViewController:cpvc animated:YES];
                }
            }];
        }
    }];
}
- (void)tap1 {
    [self login:ATOMSignUpWeibo];
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
    

    [self.signUpView dismiss];
    [self login:ATOMSignUpQQ];

}
-(void)tapSignUp2 {
    [self.signUpView dismiss];
    [self login:ATOMSignUpWechat];

}
-(void)tapSignUp3 {
    [self.signUpView dismiss];
    [[NSUserDefaults standardUserDefaults]setObject:@(ATOMSignUpMobile) forKey:@"SignUpType"];

    DDCreateProfileVC *cpvc = [DDCreateProfileVC new];
    [self.navigationController pushViewController:cpvc animated:YES];
}
-(void)tapSignUpClose {
    [self.signUpView dismiss];
}


@end
