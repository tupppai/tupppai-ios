//
//  ATOMLoginBaseViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/30/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDLoginBaseVC.h"

@implementation DDLoginBaseVC
-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorEccuredRET) name:@"ErrorOccurred" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"ShowInfo" object:nil];
    [self setupNav];
}

- (void)setupNav {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;    //this line make image align to left
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    backButton.imageView.contentMode = UIViewContentModeTopLeft;
    [backButton setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    [backView addSubview:backButton];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItem = barBackButtonItem;
    }
}
-(void) errorEccuredRET {
    [Hud text:@"出现未知错误" inView:self.view];
}
-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    [Hud text:info inView:self.view];
}
-(BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)popCurrentController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
