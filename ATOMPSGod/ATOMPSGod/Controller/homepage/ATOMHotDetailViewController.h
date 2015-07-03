//
//  ATOMHotDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "PWPageDetailViewModel.h"
#import "ATOMAskPageViewModel.h"

@interface ATOMHotDetailViewController : ATOMBaseViewController

//fold=0,不需要从服务器获取求P，直接从上一个controller获取。
@property (nonatomic, assign) int fold;

@property (nonatomic, strong) ATOMAskPageViewModel *askPageViewModel;
//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;

@end
