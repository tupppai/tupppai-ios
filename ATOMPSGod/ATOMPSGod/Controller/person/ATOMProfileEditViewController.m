//
//  ATOMProfileEditViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProfileEditViewController.h"
#import "ATOMProfileEditView.h"

@interface ATOMProfileEditViewController ()

@property (nonatomic, strong) ATOMProfileEditView *proifileEditView;

@end

@implementation ATOMProfileEditViewController

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
    self.title = @"资料编辑";
    _proifileEditView = [ATOMProfileEditView new];
    self.view = _proifileEditView;
}












































@end
