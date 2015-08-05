//
//  ATOMMyAttentionTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMFollowPageViewModel;
@class ATOMBottomCommonButton;

@interface ATOMMyAttentionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userPublishTimeLabel;
@property (nonatomic, strong) UIButton *psButton;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) ATOMBottomCommonButton *praiseButton;
@property (nonatomic, strong) ATOMBottomCommonButton *shareButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;
@property (nonatomic, strong) UIButton *moreShareButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) UIView *bottomThinView;
@property (nonatomic, strong) ATOMFollowPageViewModel *viewModel;

+ (CGFloat)calculateCellHeightWith:(ATOMFollowPageViewModel *)viewModel;

@end
