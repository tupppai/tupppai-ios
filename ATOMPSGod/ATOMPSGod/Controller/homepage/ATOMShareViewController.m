//
//  ATOMShareViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShareViewController.h"
#import "ATOMShareView.h"

@interface ATOMShareViewController ()

@property (nonatomic, strong) ATOMShareView *shareView;

@end

@implementation ATOMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"分享";
    _shareView = [ATOMShareView new];
    self.view = _shareView;
    
}











































@end
