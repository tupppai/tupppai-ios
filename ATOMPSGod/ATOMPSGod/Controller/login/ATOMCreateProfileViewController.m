//
//  ATOMCreateProfileViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCreateProfileViewController.h"
#import "ATOMCreateProfileView.h"
#import "ATOMMobileRegisterViewController.h"

@interface ATOMCreateProfileViewController ()

@property (nonatomic, strong) ATOMCreateProfileView *createProfileView;

@end

@implementation ATOMCreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"创建个人资料";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _createProfileView = [ATOMCreateProfileView new];
    self.view = _createProfileView;
}

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    ATOMMobileRegisterViewController *mrvc = [[ATOMMobileRegisterViewController alloc] init];
    [self.navigationController pushViewController:mrvc animated:YES];
}

@end
