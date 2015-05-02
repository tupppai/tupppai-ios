//
//  ATOMInviteView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMMyConcernTableHeaderView;

@interface ATOMInviteView : ATOMBaseView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ATOMMyConcernTableHeaderView *inviteFriendView;
@property (nonatomic, strong) UIButton *wxFriendInviteButton;
@property (nonatomic, strong) UIButton *wxFriendCircleInviteButton;

@property (nonatomic, strong) UITableView *inviteTableView;

@end
