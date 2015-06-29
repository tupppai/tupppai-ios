//
//  ATOMHotDetailTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMHotDetailPageViewModel;
@class ATOMBottomCommonButton;
#import "ATOMAskPageViewModel.h"
@interface ATOMHotDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *psButton;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) ATOMBottomCommonButton *praiseButton;
@property (nonatomic, strong) ATOMBottomCommonButton *shareButton;
@property (nonatomic, strong) ATOMBottomCommonButton *commentButton;
@property (nonatomic, strong) UIButton *moreShareButton;
//@property (nonatomic, strong) UIImage *userWorkImage;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *extralBottomView;
@property (nonatomic, strong) ATOMHotDetailPageViewModel *viewModel;

+ (CGFloat)calculateCellHeightWith:(ATOMHotDetailPageViewModel *)viewModel;
+ (CGFloat)calculateCellHeightWithAsk:(ATOMAskPageViewModel *)viewModel;
@end
