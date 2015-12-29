//
//  ATOMMyConcernTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEUserViewModel.h"

@interface PIEFriendFollowingTableCell : UITableViewCell

@property (nonatomic, strong) PIEUserViewModel *viewModel;

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UILabel *fansNumberLabel;
@property (nonatomic, strong) UILabel *uploadNumberLabel;
@property (nonatomic, strong) UILabel *workNumberLabel;


@end
