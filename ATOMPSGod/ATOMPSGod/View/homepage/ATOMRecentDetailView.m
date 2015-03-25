//
//  ATOMRecentDetailView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailView.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMRecentDetailHeaderView.h"

@interface ATOMRecentDetailView ()

@property (nonatomic, assign) int lastContentSizeHeight;
@property (nonatomic, assign) BOOL isContentSizeOrigin;

@end

@implementation ATOMRecentDetailView

static int padding = 10;

- (instancetype)init {
    self = [super init];
    if (self ) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self addNotificationToRecentDetailView];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _recentDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 46)];
    _headerView = [ATOMRecentDetailHeaderView new];
    [self addSubview:_recentDetailTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xefefef];
    [self addSubview:_bottomView];
    
    _sendCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGWidth(self.frame) - padding - 32, 7, 32, 32)];
    [_sendCommentButton setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    [_bottomView addSubview:_sendCommentButton];
    
    _sendCommentView = [[UITextView alloc] initWithFrame:CGRectMake(46, 8, CGRectGetMinX(_sendCommentButton.frame) - padding - 46, 30)];
    _sendCommentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_bottomView addSubview:_sendCommentView];
    
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _headerView.viewModel = viewModel;
    CGFloat headerHeight = [ATOMRecentDetailHeaderView calculateHeaderViewHeightWith:viewModel];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
    _recentDetailTableView.tableHeaderView = _headerView;
}

- (void)addNotificationToRecentDetailView {
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
