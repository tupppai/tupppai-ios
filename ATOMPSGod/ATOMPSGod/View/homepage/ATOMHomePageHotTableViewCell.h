//
//  ATOMHomePageHotTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMAskPageViewModel;
@class ATOMBottomCommonButton;

@interface ATOMHomePageHotTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *publishTimeLabel;
@property (nonatomic, strong) UIImageView *imageViewMain;
@property (nonatomic, strong) ATOMBottomCommonButton *likeButton;
@property (nonatomic, strong) ATOMBottomCommonButton *wechatButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *additionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *gapView;

- (void)configCell:(ATOMAskPageViewModel *)viewModel;
@end
