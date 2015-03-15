//
//  ATOMInviteMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteMessageTableViewCell.h"

@implementation ATOMInviteMessageTableViewCell

static int padding20 = 20;
static int padding10 = 10;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.backgroundColor = [UIColor redColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    [self addSubview:_userNameLabel];
    
    _inviteContentLabel = [UILabel new];
    _inviteContentLabel.text = @"邀请你帮忙P图";
    _inviteContentLabel.textColor = [UIColor colorWithHex:0x828282];
    _inviteContentLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:_inviteContentLabel];
    
    _inviteTimeLabel = [UILabel new];
    _inviteTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _inviteTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_inviteTimeLabel];
    
    _workImageView = [UIImageView new];
    _workImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_workImageView];
    
    [self test];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding10, padding20, 45, 45);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 16, CGRectGetMaxY(_userHeaderButton.frame) - 16, 17, 17);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding20, SCREEN_WIDTH - padding10 * 4 - 75 - 45, 20);
    _inviteContentLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), SCREEN_WIDTH - padding10 * 4 - 75 - 45, 30);
    _inviteTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_inviteContentLabel.frame), 80, 15);
    _workImageView.frame = CGRectMake(SCREEN_WIDTH - padding10 - 75, padding10, 75, 75);
}

- (void)test {
    _userNameLabel.text = @"atom";
    _inviteTimeLabel.text = @"10月12号 11:00";
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    [self setNeedsLayout];
}



@end
