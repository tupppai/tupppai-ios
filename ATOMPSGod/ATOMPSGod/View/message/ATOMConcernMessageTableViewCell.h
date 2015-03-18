//
//  ATOMConcernMessageTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMOtherMessageViewModel;

@interface ATOMConcernMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *concernTimeLabel;
@property (nonatomic, strong) ATOMOtherMessageViewModel *viewModel;

@end
