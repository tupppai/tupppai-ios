//
//  ATOMMobileRegisterViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMobileRegisterViewController.h"
#import "ATOMMobileRegisterView.h"
#import "ATOMInputVerifyCodeViewController.h"

@interface ATOMMobileRegisterViewController ()

@property (nonatomic, strong) ATOMMobileRegisterView *mobileRegisterView;

@end

@implementation ATOMMobileRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"手机注册";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _mobileRegisterView = [ATOMMobileRegisterView new];
    self.view = _mobileRegisterView;
}

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [UIAlertView showWithTitle:nil message:@"确认手机号码\n我们将发验证码到此号码" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            NSLog(@"Cancelled");
        } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
            NSLog(@"confirmed");
            ATOMInputVerifyCodeViewController *ivcvc = [ATOMInputVerifyCodeViewController new];
            [self.navigationController pushViewController:ivcvc animated:YES];
        }
    }];
}

@end
