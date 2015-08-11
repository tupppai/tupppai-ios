//
//  ATOMCommentTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMCommentDetailViewModel;
@class ATOMPraiseButton;

@interface ATOMCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) ATOMPraiseButton *praiseButton;

@property (nonatomic, strong) ATOMCommentDetailViewModel *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentDetailViewModel *)viewModel;

@end
