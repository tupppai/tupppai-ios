//
//  ATOMRecentDetailView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMHomePageViewModel;
@class ATOMRecentDetailHeaderView;

@interface ATOMRecentDetailView : UIScrollView;

@property (nonatomic, strong) ATOMRecentDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *recentDetailTableView;
@property (nonatomic, strong) UIButton *sendCommentButton;
@property (nonatomic, strong) UITextView *sendCommentView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ATOMHomePageViewModel *viewModel;
@property (nonatomic, copy) NSString *textViewPlaceholder;
@property (nonatomic, strong) UIButton *faceButton;
/**
 *  表情滚动视图
 */
@property (nonatomic, strong) UIScrollView *faceView;

- (void)hideCommentView;
- (BOOL)isEditingCommentView;

@end
