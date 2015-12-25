//
//  kfcPageView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

//评论VC的Header
#import "PIEPageButton.h"
#import "PIEBangView.h"
#import "PIELoveButton.h"
#import "PIETextView_linkDetection.h"

#import "PIEAvatarImageView.h"


@interface PIECommentTableHeaderView_Ask : UIView

@property (nonatomic, strong) PIEAvatarImageView *avatarView;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageViewMain;
@property (nonatomic, strong) PIETextView_linkDetection *textView_content;
@property (nonatomic, strong) UIImageView *imageViewBlur;

@property (nonatomic, strong) PIEPageButton *commentButton;
@property (nonatomic, strong) PIEPageButton *shareButton;
@property (nonatomic, strong) PIEBangView *bangView;
@property (nonatomic, strong) PIEPageVM *vm;


@end
