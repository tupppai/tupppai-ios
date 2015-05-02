//
//  ATOMRecentDetailHeaderView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
#import "ATOMHomePageViewModel.h"
@class ATOMBottomCommonButton;

@interface ATOMRecentDetailHeaderView : ATOMBaseView

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *psButton;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) ATOMBottomCommonButton *praiseButton;
@property (nonatomic, strong) ATOMBottomCommonButton *shareButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;
@property (nonatomic, strong) UIButton *moreShareButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImage *userWorkImage;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) ATOMHomePageViewModel *viewModel;

+ (CGFloat)calculateHeaderViewHeightWith:(ATOMHomePageViewModel *)viewModel;

@end
