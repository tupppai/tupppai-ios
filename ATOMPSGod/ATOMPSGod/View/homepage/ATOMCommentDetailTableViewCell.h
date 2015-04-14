//
//  ATOMCommentDetailTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMCommentDetailViewModel;

@interface ATOMCommentDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) UIButton *praiseButton;
@property (nonatomic, strong) ATOMCommentDetailViewModel *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentDetailViewModel *)viewModel;

@end
