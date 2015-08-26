//
//  ATOMInviteView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteView.h"
#import "DDCommentHeaderView.h"

@implementation ATOMInviteView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    _inviteFriendView = [DDCommentHeaderView new];
    _inviteFriendView.titleLabel.text = @"微信邀请";
    [_topView addSubview:_inviteFriendView];
    
    
    _wxFriendInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding15, kPadding15 + CGRectGetMaxY(_inviteFriendView.frame), 48, 48)];
    [_wxFriendInviteButton setBackgroundImage:[UIImage imageNamed:@"wechat-1"] forState:UIControlStateNormal];
    [_topView addSubview:_wxFriendInviteButton];
    
    _wxFriendCircleInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding20 + CGRectGetMaxX(_wxFriendInviteButton.frame), kPadding15 + CGRectGetMaxY(_inviteFriendView.frame), 48, 48)];
    [_wxFriendCircleInviteButton setBackgroundImage:[UIImage imageNamed:@"moment"] forState:UIControlStateNormal];
    [_topView addSubview:_wxFriendCircleInviteButton];
    
    _inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, CGHeight(self.frame) - CGHeight(_topView.frame))];
    _inviteTableView.backgroundColor = [UIColor whiteColor];
//    _inviteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inviteTableView.tableFooterView = [UIView new];
    [self addSubview:_inviteTableView];
}
































@end
