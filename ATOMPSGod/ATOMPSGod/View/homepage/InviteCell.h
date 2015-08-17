//
//  InviteCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMInviteCellViewModel.h"

@interface InviteCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *fansNumberLabel;
@property (nonatomic, strong) UILabel *uploadNumberLabel;
@property (nonatomic, strong) UILabel *workNumberLabel;
@property (nonatomic, strong) UIButton *inviteButton;

@property (nonatomic, strong) ATOMInviteCellViewModel *viewModel;

- (void)toggleInviteButtonAppearance;

@end
