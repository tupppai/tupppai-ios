//
//  ATOMCommentDetailView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMCommentDetailView : UIScrollView

@property (nonatomic, strong) UITableView *commentDetailTableView;

@property (nonatomic, strong) UIButton *sendCommentButton;

@property (nonatomic, strong) UITextView *sendCommentView;

@property (nonatomic, strong) UIView *bottomView;

@end
