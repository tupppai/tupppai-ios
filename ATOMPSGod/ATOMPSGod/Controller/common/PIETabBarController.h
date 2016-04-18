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

/** 跳转到eliteFollow并且下拉刷新 */
- (void)refreshMoments;

@end
