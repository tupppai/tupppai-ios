//
//  ATOMHomePageHotTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMHomePageViewModel;

@interface ATOMHomePageHotTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userPublishTimeLabel;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) UIButton *praiseButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *totalPSButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) ATOMHomePageViewModel *viewModel;

+ (CGFloat)calculateCellHeightWith:(ATOMHomePageViewModel *)viewModel;
+ (CGRect)calculateHomePageHotImageViewRectWith:(ATOMHomePageViewModel *)viewModel;

@end
