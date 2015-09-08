//
//  kfcPageView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

//评论VC的Header
#import "ATOMBaseView.h"
#import "DDPageVM.h"
#import "DDHotDetailPageVM.h"
#import "DDCommentPageVM.h"
#import "kfcButton.h"
@interface kfcPageView : ATOMBaseView


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *psView;

@property (nonatomic, strong) UIImageView *imageViewMain;

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) kfcButton *likeButton;
@property (nonatomic, strong) kfcButton *wechatButton;
@property (nonatomic, strong) kfcButton *commentButton;


@property (nonatomic, strong) DDCommentPageVM *vm;

//+ (CGFloat)calculateHeaderViewHeight:(kfcPageVM *)viewModel;

@end
