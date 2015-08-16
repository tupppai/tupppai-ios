//
//  ATOMCommentTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentVM;
@class CommentLikeButton;

@interface ATOMCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIButton *userNameButton;
//@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) CommentLikeButton *praiseButton;

@property (nonatomic, strong) CommentVM *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(CommentVM *)viewModel;

@end
