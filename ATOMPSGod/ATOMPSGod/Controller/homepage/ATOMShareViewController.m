//
//  ATOMShareViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShareViewController.h"
#import "ATOMShareView.h"
#import "HotDetailViewController.h"
#import "DDAskPageVM.h"
#import "HomeViewController.h"

@interface ATOMShareViewController ()

@property (nonatomic, strong) ATOMShareView *shareView;

@end

@implementation ATOMShareViewController

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
    HotDetailViewController *hdvc = [HotDetailViewController new];
    hdvc.askVM = _askPageViewModel;
    HomeViewController *hvc = self.navigationController.viewControllers[0];
    [self pushViewController:hdvc animated:YES];
    [self.navigationController setViewControllers:@[hvc, hdvc]];
}









































@end
