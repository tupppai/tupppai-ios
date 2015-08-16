//
//  ATOMCommentDetailTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentVM;
@class CommentLikeButton;

@interface ATOMCommentDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) CommentLikeButton *praiseButton;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) CommentVM *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(CommentVM *)viewModel;

@end
