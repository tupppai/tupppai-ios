//
//  ATOMhomepageSeekHelpTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMHomePageViewModel.h"
@class ATOMBottomCommonButton;

@interface ATOMhomepageSeekHelpTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *psButton;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) ATOMBottomCommonButton *praiseButton;
@property (nonatomic, strong) ATOMBottomCommonButton *shareButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;
@property (nonatomic, strong) UIButton *moreShareButton;
@property (nonatomic, strong) UIImage *userWorkImage;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) UIView *bottomThinView;
@property (nonatomic, strong) ATOMHomePageViewModel *viewModel;

+ (CGFloat)calculateCellHeightWith:(ATOMHomePageViewModel *)viewModel;

@end
