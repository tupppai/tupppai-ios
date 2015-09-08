//
//  ATOMShareViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDShareVC.h"
#import "ATOMShareView.h"
#import "DDDetailPageVC.h"
#import "DDPageVM.h"
#import "DDHomeVC.h"

@interface DDShareVC ()

@property (nonatomic, strong) ATOMShareView *shareView;

@end

@implementation DDShareVC

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"分享";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _shareView = [ATOMShareView new];
    self.view = _shareView;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    DDDetailPageVC *hdvc = [DDDetailPageVC new];
    hdvc.askVM = _askPageViewModel;
    DDHomeVC *hvc = self.navigationController.viewControllers[0];
    [self pushViewController:hdvc animated:YES];
    [self.navigationController setViewControllers:@[hvc, hdvc]];
}









































@end
