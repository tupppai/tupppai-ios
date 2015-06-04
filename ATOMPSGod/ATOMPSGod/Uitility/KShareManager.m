//
//  KShareManager.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "KShareManager.h"
@implementation KShareManager
static dispatch_once_t onceToken;
static PSMascotAnimationImageView *mascotAnimator;

+ (PSMascotAnimationImageView *)mascotAnimator {
    dispatch_once(&onceToken, ^{
        mascotAnimator = [PSMascotAnimationImageView new];
    });
    return mascotAnimator;
}

@end
