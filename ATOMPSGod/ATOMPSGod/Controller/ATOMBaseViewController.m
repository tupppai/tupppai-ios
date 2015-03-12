//
//  BaseViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "ATOMHomepageViewController.h"
#import "ATOMPersonViewController.h"
#import "ATOMMyAttentionViewController.h"
#import "ATOMMyMessageViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMBaseViewController ()

@end

@implementation ATOMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x727272], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 19)];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
//    self.navigationItem.hidesBackButton = YES;
    NSLog(@"%@ DidLoad!!!!!",[self class]);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
    if ([self isKindOfClass:[ATOMHomepageViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMPersonViewController class]]){
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMMyAttentionViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMMyMessageViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)popCurrentController {
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}


@end
