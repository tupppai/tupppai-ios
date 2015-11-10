//
//  kfcPageView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

//评论VC的Header
#import "ATOMBaseView.h"

//#import "DDHotDetailPageVM.h"
////
////
#import "PIEPageButton.h"
#import "PIEBangView.h"
#import "PIEPageLikeButton.h"
@interface PIECommentTableHeaderView_Ask : ATOMBaseView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageViewMain;
@property (nonatomic, strong) UIImageView *imageViewRight;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PIEPageButton *commentButton;
@property (nonatomic, strong) PIEPageButton *shareButton;
@property (nonatomic, strong) PIEBangView *bangView;
@property (nonatomic, strong) DDPageVM *vm;

//+ (CGFloat)calculateHeaderViewHeight:(kfcPageVM *)viewModel;

@end
