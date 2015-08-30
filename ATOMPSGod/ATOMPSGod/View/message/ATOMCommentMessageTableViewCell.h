//
//  ATOMCommentMessageTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCommentMsgVM;

@interface ATOMCommentMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *replyContentLabel;
@property (nonatomic, strong) UILabel *replyTimeLabel;
@property (nonatomic, strong) UIImageView *workImageView;

@property (nonatomic, strong) DDCommentMsgVM *commentMessageViewModel;

+ (CGFloat)calculateCellHeightWithModel:(DDCommentMsgVM *)viewModel;


@end
