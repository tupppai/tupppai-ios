//
//  ATOMCommentDetailTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCommentVM;
@class CommentLikeButton;

@interface ATOMCommentDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) CommentLikeButton *likeButton;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) DDCommentVM *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(DDCommentVM *)viewModel;

@end
