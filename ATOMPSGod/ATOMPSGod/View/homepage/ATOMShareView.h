//
//  ATOMShareView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMInviteTableHeaderView;

@interface ATOMShareView : ATOMBaseView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ATOMInviteTableHeaderView *shareFriendView;
@property (nonatomic, strong) UIButton *wxFriendInviteButton;
@property (nonatomic, strong) UIButton *wxFriendCircleInviteButton;

@property (nonatomic, strong) UITableView *inviteTableView;

@end
