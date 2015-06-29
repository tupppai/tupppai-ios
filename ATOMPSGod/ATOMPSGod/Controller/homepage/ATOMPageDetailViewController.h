//
//  ATOMPageDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "PWPageDetailViewModel.h"
@interface ATOMPageDetailViewController : ATOMBaseViewController

@property (nonatomic, strong) PWPageDetailViewModel *pageDetailViewModel;

//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;

@end
