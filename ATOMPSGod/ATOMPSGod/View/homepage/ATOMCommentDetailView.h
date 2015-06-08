//
//  ATOMCommentDetailView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCommentDetailTableView.h"
@interface ATOMCommentDetailView : UIScrollView

@property (nonatomic, strong) PWCommentDetailTableView* commentDetailTableView;
@property (nonatomic, strong) UIButton *sendCommentButton;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, copy) NSString *commentText;

@property (nonatomic, copy) NSString *placeholderString;
/**
 *  表情滚动视图
 */
@property (nonatomic, strong) UIScrollView *faceView;

- (void)hideCommentView;
- (BOOL)isEditingCommentView;
- (void)toggleSendCommentButton;
@end
