//
//  CommentCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCommentVM;
@class CommentLikeButton;

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIButton *userNameButton;
//@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userCommentDetailLabel;
@property (nonatomic, strong) CommentLikeButton *likeButton;

@property (nonatomic, strong) DDCommentVM *viewModel;

+ (CGFloat)calculateCellHeightWithModel:(DDCommentVM *)viewModel;

@end
