//
//  kfcPageView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHotDetailPageViewModel.h"
#import "kfcPageVM.h"
#import "ATOMBottomCommonButton.h"
@interface kfcPageView : ATOMBaseView


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *psView;

@property (nonatomic, strong) UIImageView *imageViewMain;

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) ATOMBottomCommonButton *likeButton;
@property (nonatomic, strong) ATOMBottomCommonButton *wechatButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;


@property (nonatomic, strong) kfcPageVM *vm;

//+ (CGFloat)calculateHeaderViewHeight:(kfcPageVM *)viewModel;

@end
