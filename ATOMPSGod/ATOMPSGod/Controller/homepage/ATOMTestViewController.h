//
//  ATOMPageDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "ATOMProductPageViewModel.h"
#import "ATOMViewControllerDelegate.h"
@class ATOMAskPageViewModel;


@interface ATOMTestViewController : ATOMBaseViewController

@property (nonatomic, strong) ATOMAskPageViewModel *askPageViewModel;
@property (nonatomic, strong) ATOMProductPageViewModel *productPageViewModel;

//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;

@end
