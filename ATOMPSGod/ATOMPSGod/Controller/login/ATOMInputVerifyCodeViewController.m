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
#import "ATOMMainTabBarController.h"
@interface ATOMInputVerifyCodeViewController ()

@property (nonatomic, strong) ATOMInputVerifyCodeView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
//@property (nonatomic, strong) NSDateFormatter *df;
@end

@implementation ATOMInputVerifyCodeViewController

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
    [_inputVerifyView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_inputVerifyView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];
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

- (void)clickRightButtonItem{
    
    if ([_inputVerifyView.verifyCodeTextField.text isEqualToString:_verifyCode]) {
        NSMutableDictionary *param = [[ATOMCurrentUser currentUser] dictionaryFromModel];
        ATOMSubmitUserInformation *submitUserInformation = [ATOMSubmitUserInformation new];
        
        [submitUserInformation SubmitUserInformation:[param copy] withBlock:^(NSError *error) {
            if (!error) {
                [Util TextHud:@"注册成功"];
                [self.navigationController setViewControllers:nil];
                [AppDelegate APP].mainTabBarController = nil;
                [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
            }
        }];
    } else {
        [Util TextHud:@"验证码有误"];
    }
}
- (void)clickLeftButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_verifyTimer invalidate];
    _verifyTimer = nil;
}




@end
