//
//  ATOMMainTabBarController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIETabBarController : UITabBarController
@property (nonatomic,copy) UIImage* avatarImage;
- (void)updateTabbarAvatar;

/** 跳转到EliteFollow */
- (void)toggleToEliteFollow;

/** 下拉刷新eliteFollow(like 朋友圈) */
- (void)refreshMoments;

@end
