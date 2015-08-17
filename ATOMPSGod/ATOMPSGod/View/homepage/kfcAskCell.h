//
//  kfcAskCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMAskPageViewModel.h"
@class ATOMBottomCommonButton;

@interface kfcAskCell : UITableViewCell

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *psView;

@property (nonatomic, strong) UIImageView *imageViewMain;

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) ATOMBottomCommonButton *likeButton;
@property (nonatomic, strong) ATOMBottomCommonButton *wechatButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;

- (void)configCell:(ATOMAskPageViewModel *)viewModel;

@end
