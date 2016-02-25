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
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorOccuredRET) name:@"NetworkErrorCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"NetworkShowInfoCall" object:nil];
    

}

- (void)setupNav {
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    //    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    _negativeSpacer.width = 0;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItems = @[ barBackButtonItem];
    }
}

-(void) errorOccuredRET {
    [Hud text:@"网路好像有点问题～" inView:self.view];
}

-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    NSString *prompt = [NSString stringWithFormat:@"%@", info];
    [Hud text:prompt inView:self.view];
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)popCurrentController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorOccuredRET) name:@"NetworkErrorCall" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"NetworkShowInfoCall" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NetworkErrorCall"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NetworkShowInfoCall"
                                                  object:nil];
}

@end
