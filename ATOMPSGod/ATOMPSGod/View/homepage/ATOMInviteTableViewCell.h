//
//  ATOMInviteTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMInviteTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *fansNumberLabel;
@property (nonatomic, strong) UILabel *uploadNumberLabel;
@property (nonatomic, strong) UILabel *workNumberLabel;
@property (nonatomic, strong) UIButton *inviteButton;

- (void)changeInviteButtonStatus;

@end
