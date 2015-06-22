//
//  ATOMInputVerifyCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInputVerifyCodeViewController.h"
#import "ATOMInputVerifyCodeView.h"
#import "ATOMSubmitUserInfomation.h"
#import "AppDelegate.h"
#import "ATOMLoginViewController.h"

@interface ATOMInputVerifyCodeViewController ()

@property (nonatomic, strong) ATOMInputVerifyCodeView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
@property (nonatomic, strong) NSDateFormatter *df;

@end

@implementation ATOMInputVerifyCodeViewController

//- (NSDateFormatter *)df {
//    if (!_df) {
//        _df = [[NSDateFormatter alloc] init];
//        [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    }
//    return _df;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createVerifyTimer];
}

- (void)createUI {
    self.title = @"填写验证码";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    rightButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _inputVerifyView = [ATOMInputVerifyCodeView new];
    self.view = _inputVerifyView;
    [_inputVerifyView.sendVerifyCodeButton addTarget:self action:@selector(clickVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.verifyCodeTextField becomeFirstResponder];
}

- (void)createVerifyTimer {
//    NSDate * currentDate = [NSDate date];
//    NSString *verifyTitleString = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyTimer"];
//    if (verifyTitleString != nil && ![verifyTitleString isEqualToString:@""]) {
//        NSDate *savedDate = [self.df dateFromString:verifyTitleString];
//        NSTimeInterval lastSecond = 60 - [currentDate timeIntervalSinceDate:savedDate];
//        if ([verifyTitleString isEqualToString:@"invalidTimer"] || lastSecond >= 60 || lastSecond <= 0) {
//            lastSecond = 60;
//            verifyTitleString = [self.df stringFromDate:currentDate];
//            [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        _inputVerifyView.lastSecond = lastSecond;
//    } else {
//        verifyTitleString = [self.df stringFromDate:currentDate];
//        _inputVerifyView.lastSecond = 60;
//        [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
            _inputVerifyView.lastSecond = 60;

    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runVerifyTimer) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_verifyTimer forMode:NSDefaultRunLoopMode];
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
}

- (void)runVerifyTimer {
    _inputVerifyView.lastSecond--;
    if (_inputVerifyView.lastSecond<=0) {
        [_verifyTimer invalidate];
        _verifyTimer = nil;
        _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = YES;
        
//        NSString *verifyTitleString = @"invalidTimer";
//        [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clickVerifyButton:(UIButton *)sender {
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
    [self createVerifyTimer];
}

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    
    if ([_inputVerifyView.verifyCodeTextField.text isEqualToString:_verifyCode]) {
        NSMutableDictionary *param = [[ATOMCurrentUser currentUser] dictionaryFromModel];
        ATOMSubmitUserInformation *submitUserInformation = [ATOMSubmitUserInformation new];
        NSString* signUpType;
        switch ([ATOMCurrentUser currentUser].signUpType) {
            case ATOMSignUpWeixin:
                NSLog(@"ATOMSignUpWeixin");
                signUpType = @"weixin";
                [param setObject:[ATOMCurrentUser currentUser].sourceData[@"openid"] forKey:@"openid"];
                [param setObject:[ATOMCurrentUser currentUser].sourceData[@"headimgurl"] forKey:@"avatar_url"];
                break;
            case ATOMSignUpWeibo:
                [param setObject:[ATOMCurrentUser currentUser].sourceData[@"idstr"] forKey:@"openid"];
                [param setObject:[ATOMCurrentUser currentUser].sourceData[@"avatar_hd"] forKey:@"avatar_url"];
                NSLog(@"ATOMSignUpWeibo");
                signUpType = @"weibo";
                break;
            case ATOMSignUpMobile:
                NSLog(@"ATOMSignUpMobile");
                signUpType = @"mobile";
                break;
            default:
                NSLog(@"case default");
                signUpType = @"weixin";
                break;
        }
            
        [submitUserInformation SubmitUserInformation:[param copy] AndType:signUpType withBlock:^(NSError *error) {
            if (!error) {
                [Util TextHud:@"注册成功"];
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTarBarController];
                //保存user,调到首页
            }
        }];
    } else {
        [Util TextHud:@"验证码有误"];
    }
}

    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_verifyTimer invalidate];
    _verifyTimer = nil;
}




@end
