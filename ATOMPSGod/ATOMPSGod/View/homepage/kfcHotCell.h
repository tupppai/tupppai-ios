//
//  kfcHotCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMTotalPSView.h"

@class DDAskPageVM;
@class kfcButton;

@interface kfcHotCell : UITableViewCell

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *imageViewMain;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *additionView;
@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *publishTimeLabel;

@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) kfcButton *likeButton;
@property (nonatomic, strong) kfcButton *wechatButton;
@property (nonatomic, strong) kfcButton *commentButton;
@property (nonatomic, strong) ATOMTotalPSView *totalPSLabel;
@property (nonatomic, strong) NSMutableArray *repliers;

- (void)configCell:(DDAskPageVM *)viewModel;
@end
