//
//  ATOMCreateProfileViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseVC.h"
#import "ATOMUserProfileViewModel.h"

@interface DDCreateProfileVC : DDLoginBaseVC
@property (nonatomic, strong) ATOMUserProfileViewModel *userProfileViewModel;
@end
