//
//  ATOMInputVerifyCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInputVerifyCodeViewController.h"
#import "ATOMInputVerifyCodeView.h"

@interface ATOMInputVerifyCodeViewController ()

@property (nonatomic, strong) ATOMInputVerifyCodeView *inputVerifyView;
@property (nonatomic, strong) NSTimer *verifyTimer;
@property (nonatomic, strong) NSDateFormatter *df;

@end

@implementation ATOMInputVerifyCodeViewController

- (NSDateFormatter *)df {
    if (!_df) {
        _df = [[NSDateFormatter alloc] init];
        [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _df;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createVerifyTimer];
}

- (void)createUI {
    self.title = @"填写验证码";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _inputVerifyView = [ATOMInputVerifyCodeView new];
    self.view = _inputVerifyView;
    [_inputVerifyView.sendVerifyCodeButton addTarget:self action:@selector(clickVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createVerifyTimer {
    NSDate * currentDate = [NSDate date];
    NSString *verifyTitleString = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyTimer"];
    if (verifyTitleString != nil && ![verifyTitleString isEqualToString:@""]) {
        NSDate *savedDate = [self.df dateFromString:verifyTitleString];
        NSTimeInterval lastSecond = 60 - [currentDate timeIntervalSinceDate:savedDate];
        if ([verifyTitleString isEqualToString:@"invalidTimer"] || lastSecond >= 60 || lastSecond <= 0) {
            lastSecond = 60;
            verifyTitleString = [self.df stringFromDate:currentDate];
            [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _inputVerifyView.lastSecond = lastSecond;
    } else {
        verifyTitleString = [self.df stringFromDate:currentDate];
        _inputVerifyView.lastSecond = 60;
        [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runVerifyTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_verifyTimer forMode:NSDefaultRunLoopMode];
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
}

- (void)runVerifyTimer {
    _inputVerifyView.lastSecond--;
    if (_inputVerifyView.lastSecond<=0) {
        [_verifyTimer invalidate];
        _verifyTimer = nil;
        _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = YES;
        NSString *verifyTitleString = @"invalidTimer";
        [[NSUserDefaults standardUserDefaults] setObject:verifyTitleString forKey:@"verifyTimer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clickVerifyButton:(UIButton *)sender {
    _inputVerifyView.sendVerifyCodeButton.userInteractionEnabled = NO;
    [self createVerifyTimer];
}

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_verifyTimer invalidate];
    _verifyTimer = nil;
}




@end
