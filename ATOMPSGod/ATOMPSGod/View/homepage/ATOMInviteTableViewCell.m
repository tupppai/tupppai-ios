//
//  ATOMInviteTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteTableViewCell.h"

@implementation ATOMInviteTableViewCell

static int padding10 = 10;
static float commenWidth;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, 6, 45, 45)];
    _userHeaderButton.backgroundColor = [UIColor greenColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17)];
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, 80, 30)];
    _userNameLabel.text = @"atom";
    [self addSubview:_userNameLabel];
    
    _inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 57, 11.5, 57, 30)];
    _inviteButton.layer.cornerRadius = 5;
    _inviteButton.layer.masksToBounds = YES;
    _inviteButton.backgroundColor = [UIColor colorWithHex:0x838383];
    [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_inviteButton setTitle:@"已邀请" forState:UIControlStateNormal];
    _inviteButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_inviteButton];
    
    commenWidth = (CGOriginX(_inviteButton.frame) - CGRectGetMaxX(_userHeaderButton.frame) - padding10 * 2) / 3;
    
    _fansNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_fansNumberButton WithImage:[UIImage imageNamed:@"fans_num"]];
    _uploadNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_fansNumberButton.frame), CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_uploadNumberButton WithImage:[UIImage imageNamed:@"psask_num"]];
    _workNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_uploadNumberButton.frame), CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_workNumberButton WithImage:[UIImage imageNamed:@"pswork_num"]];
    
}

- (void)setCommonButton:(UIButton *)button WithImage:(UIImage *)image {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [button setTitle:@"1000" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [button setTitleColor:[UIColor colorWithHex:0x7a7a7a] forState:UIControlStateNormal];
    [self addSubview:button];
}


@end
