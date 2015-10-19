//
//  KShareManager.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "KShareManager.h"
#import "AppDelegate.h"
@implementation KShareManager
static dispatch_once_t onceToken;
static dispatch_once_t onceToken2;

static PWMascotAnimationView *mascotAnimator;
static SIAlertView *signOutAlertView;

+ (PWMascotAnimationView *)mascotAnimator {
    dispatch_once(&onceToken, ^{
        mascotAnimator = [PWMascotAnimationView new];
    });
    return mascotAnimator;
}
+ (SIAlertView *)signOutAlertView {
    dispatch_once(&onceToken2, ^{
        signOutAlertView = [[SIAlertView alloc] initWithTitle:@"大神来通知" andMessage:@"为了更好为你服务，请重新登录"];
    });
    return signOutAlertView;
}

@end
