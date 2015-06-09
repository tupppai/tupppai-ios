//
//  ATOMAskDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "ATOMDetailImageViewModel.h"
@class ATOMHomePageViewModel;

@interface ATOMAskDetailViewController : ATOMBaseViewController

@property (nonatomic, strong) ATOMHomePageViewModel *homePageViewModel;
@property (nonatomic, strong) ATOMDetailImageViewModel *detailImageViewModel;

@end
