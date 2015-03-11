//
//  ATOMCommentDetailView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailView.h"

@interface ATOMCommentDetailView ()

@property (nonatomic, assign) int lastContentSizeHeight;
@property (nonatomic, assign) BOOL isContentSizeOrigin;

@end

@implementation ATOMCommentDetailView

static int padding = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self addNotificationToCommentDetailView];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _commentDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 46)];
    _commentDetailTableView.tableFooterView = [UIView new];
    _commentDetailTableView.rowHeight = 70;
    [self addSubview:_commentDetailTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xefefef];
    [self addSubview:_bottomView];
    
    _sendCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGWidth(self.frame) - padding - 32, 7, 32, 32)];
    _sendCommentButton.backgroundColor = [UIColor blueColor];
    [_bottomView addSubview:_sendCommentButton];
    
    _sendCommentView = [[UITextView alloc] initWithFrame:CGRectMake(46, 8, CGRectGetMinX(_sendCommentButton.frame) - padding - 46, 30)];
    _sendCommentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_bottomView addSubview:_sendCommentView];
}

- (void)addNotificationToCommentDetailView {
    _lastContentSizeHeight = 30;
    _isContentSizeOrigin = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textDidChange:(NSNotification *)notification {
    CGSize contentSize = _sendCommentView.contentSize;
    if (contentSize.height >= 30 + 14 * 10) {
        return ;
    }
    int increaseHeight = contentSize.height - _lastContentSizeHeight;
    CGFloat bottomViewHeight = CGHeight(_bottomView.frame) + increaseHeight;
    CGFloat bottomViewOriginY = CGRectGetMaxY(_bottomView.frame) - bottomViewHeight;
    CGRect bottomViewFrame = _bottomView.frame;
    bottomViewFrame.origin.y = bottomViewOriginY;
    bottomViewFrame.size.height = bottomViewHeight;
    _bottomView.frame = bottomViewFrame;
    _lastContentSizeHeight = contentSize.height;
}
















@end
