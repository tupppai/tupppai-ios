//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "ATOMPageDetailViewModel.h"
#import "ATOMPageDetailHeaderView.h"
@interface MessageViewController : SLKTextViewController

@property (nonatomic, strong) ATOMPageDetailHeaderView *headerView;
@property (nonatomic, strong) ATOMPageDetailViewModel *pageDetailViewModel;
//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;

@end
