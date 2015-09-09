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
}

- (void)popCurrentController {
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) errorEccuredRET {
    [Hud text:@"出现未知错误" inView:self.view];
}
-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    [Hud text:info inView:self.view];
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end