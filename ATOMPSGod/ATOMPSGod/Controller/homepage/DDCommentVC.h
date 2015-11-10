//
//  CommentViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "PIECommentTableHeaderView_Ask.h"
#import "PIECommentTableHeaderView_Reply.h"

@interface DDCommentVC : SLKTextViewController

@property (nonatomic, strong) PIECommentTableHeaderView_Ask *headerView;
@property (nonatomic, strong) PIECommentTableHeaderView_Reply *headerView_reply;

@property (nonatomic, strong) DDPageVM *vm;
//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;
@end
