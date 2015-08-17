//
//  kfcFollowCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class kfcFollowVM;
@class ATOMBottomCommonButton;
#import "kfcViews.h"

@interface kfcFollowCell : UITableViewCell

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *additionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *publishTimeLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *psView;

@property (nonatomic, strong) UIImageView *imageViewMain;

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) ATOMBottomCommonButton *likeButton;
@property (nonatomic, strong) ATOMBottomCommonButton *wechatButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;

@property (nonatomic, strong) kfcPublishTypeLabel *publishTypeLabel;
@property (nonatomic, strong) kfcCommentLabel *commentLabel1;
@property (nonatomic, strong) kfcCommentLabel *commentLabel2;
@property (nonatomic, strong) UIImageView *commentView;

- (void)configCell:(kfcFollowVM *)viewModel;

@end
