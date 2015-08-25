//
//  ATOMInviteViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "DDAskPageVM.h"
#import "ATOMRecommendUser.h"

@interface ATOMInviteViewController : ATOMBaseViewController

@property (nonatomic, strong) DDAskPageVM *askPageViewModel;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) BOOL showNext;

@end
