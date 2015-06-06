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
@property (nonatomic, strong) UITextView *sendCommentView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) NSString *textViewPlaceholder;
/**
 *  表情滚动视图
 */
@property (nonatomic, strong) UIScrollView *faceView;

- (void)hideCommentView;
- (BOOL)isEditingCommentView;

@end
