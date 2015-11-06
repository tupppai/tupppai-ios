//
//  ATOMMyConcernTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEFollowViewModel;

@interface PIEFriendFollowingTableCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UILabel *fansNumberLabel;
@property (nonatomic, strong) UILabel *uploadNumberLabel;
@property (nonatomic, strong) UILabel *workNumberLabel;
@property (nonatomic, strong) PIEFollowViewModel *viewModel;


@end
