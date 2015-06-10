//
//  ATOMAskDetailView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMAskPageViewModel;
@class ATOMAskDetailHeaderView;
@class ATOMProductPageViewModel;
@interface ATOMAskDetailView : UIScrollView;

@property (nonatomic, strong) ATOMAskDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *recentDetailTableView;
@property (nonatomic, strong) UIButton *sendCommentButton;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ATOMAskPageViewModel *askPageViewModel;
@property (nonatomic, strong) ATOMProductPageViewModel *productPageViewModel;

//@property (nonatomic, copy) NSString *textViewPlaceholder;
@property (nonatomic, copy) NSString *placeholderString;
@property (nonatomic, strong) UIButton *faceButton;
/**
 *  表情滚动视图
 */
@property (nonatomic, strong) UIScrollView *faceView;
- (void)toggleSendCommentView;
- (void)hideCommentView;
- (BOOL)isEditingCommentView;

@end
