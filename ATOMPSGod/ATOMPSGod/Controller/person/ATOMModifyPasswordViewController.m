//
//  ATOMModifyPasswordViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMModifyPasswordViewController.h"
#import "ATOMModifyPasswordView.h"

@interface ATOMModifyPasswordViewController ()

@property (nonatomic, strong) ATOMModifyPasswordView *modifyPasswordView;

@end

@implementation ATOMModifyPasswordViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)createUI {
    self.title = @"修改密码";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _modifyPasswordView = [ATOMModifyPasswordView new];
    self.view = _modifyPasswordView;
    [_modifyPasswordView.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    
}

- (void)clickForgetPasswordButton:(UIButton *)sender {
    
}

@end
