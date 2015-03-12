//
//  ATOMInviteView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteView.h"
#import "ATOMInviteTableHeaderView.h"

@implementation ATOMInviteView

static int padding1 = 1;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85.5)];
    _topView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:_topView];
    
    _inviteFriendView = [ATOMInviteTableHeaderView new];
    _inviteFriendView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
    _inviteFriendView.titleLabel.text = @"邀请好友";
    [_topView addSubview:_inviteFriendView];
    
    CGFloat centerX = SCREEN_WIDTH / 2;
    _wxFriendCircleInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX - 30 - 55, padding1 + CGRectGetMaxY(_inviteFriendView.frame), 55, 55)];
    [_wxFriendCircleInviteButton setBackgroundImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
    [_topView addSubview:_wxFriendCircleInviteButton];
    
    _wxFriendInviteButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX + 30, padding1 + CGRectGetMaxY(_inviteFriendView.frame), 55, 55)];
    [_wxFriendInviteButton setBackgroundImage:[UIImage imageNamed:@"wechat_logo2"] forState:UIControlStateNormal];
    [_topView addSubview:_wxFriendInviteButton];
    
    _inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, CGHeight(self.frame) - CGHeight(_topView.frame))];
    _inviteTableView.backgroundColor = [UIColor whiteColor];
    _inviteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inviteTableView.tableFooterView = [UIView new];
    [self addSubview:_inviteTableView];
}
































@end
