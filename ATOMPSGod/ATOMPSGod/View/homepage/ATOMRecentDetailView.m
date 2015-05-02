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
#import "ATOMFaceView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMRecentDetailView () <UIScrollViewDelegate, ATOMFaceViewDelegate>

@property (nonatomic, assign) int lastContentSizeHeight;
@property (nonatomic, assign) BOOL isKeyboardVisible;
@property (nonatomic, assign) BOOL isFaceViewVisible;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGRect currentBottomViewFrame;
@property (nonatomic, strong) NSMutableArray *facesArray;

@end

@implementation ATOMRecentDetailView

static CGFloat faceViewHeight = 200;
static CGFloat pageControlWidth = 150;

- (instancetype)init {
    self = [super init];
    if (self ) {
        _textViewPlaceholder = @"发表你的神回复...";
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self setupFaceArray];
        [self addNotificationToRecentDetailView];
        [self createSubView];
    }
    return self;
}

- (void)setupFaceArray {
    _facesArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSArray *peopleArray = data[@"People"];
    NSArray *natureArray = data[@"Nature"];
    NSArray *placesArray = data[@"Places"];
    for (NSString *str in peopleArray) {
        [_facesArray addObject:str];
    }
    for (NSString *str in natureArray) {
        [_facesArray addObject:str];
    }
    for (NSString *str in placesArray) {
        [_facesArray addObject:str];
    }
}

- (void)createSubView {
    _recentDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 46)];
    _headerView = [ATOMRecentDetailHeaderView new];
    [self addSubview:_recentDetailTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xefefef];
    [self addSubview:_bottomView];
    
    _sendCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGWidth(self.frame) - kPadding15 - 32, 7, 32, 32)];
    //    _sendCommentButton.backgroundColor = [UIColor orangeColor];
    _sendCommentButton.titleLabel.font = [UIFont systemFontOfSize:kFont14];
    [_sendCommentButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendCommentButton setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    [_bottomView addSubview:_sendCommentButton];
    
    _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding15, 9.5, 21, 27)];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"comment_write"] forState:UIControlStateNormal];
    [_faceButton addTarget:self action:@selector(showFaceView) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_faceButton];
    
    _sendCommentView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceButton.frame) + 26, 8, CGRectGetMinX(_sendCommentButton.frame) - 26 * 2 - CGRectGetMaxX(_faceButton.frame), 30)];
    _sendCommentView.text = _textViewPlaceholder;
    _sendCommentView.textColor = [UIColor colorWithHex:0xcbcbcb];
    _sendCommentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_bottomView addSubview:_sendCommentView];
    
    _faceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGHeight(self.frame) - faceViewHeight - 40, SCREEN_WIDTH, faceViewHeight)];
    _faceView.backgroundColor = [UIColor whiteColor];
    [_faceView setShowsVerticalScrollIndicator:NO];
    [_faceView setShowsHorizontalScrollIndicator:NO];
    _faceView.pagingEnabled = YES;
    _faceView.delegate = self;
    _faceView.contentSize = CGSizeMake(SCREEN_WIDTH * 9, faceViewHeight);
    [self addSubview:_faceView];
    [self setupFaceView];
    _faceView.hidden = YES;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - pageControlWidth) / 2, CGRectGetMaxY(_faceView.frame), pageControlWidth, 40)];
    _pageControl.numberOfPages = 9;
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xededed];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x00aedf];
    [_pageControl setCurrentPage:0];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    _pageControl.hidden = YES;
    
}

- (void)setupFaceView {
    for (int i = 0; i < 9; i++) {
        ATOMFaceView *fView = [[ATOMFaceView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, kPadding10 * 2, SCREEN_WIDTH, faceViewHeight)];
        [fView loadFaceView:i Size:CGSizeMake(30, 40) Faces:_facesArray];
        fView.delegate = self;
        [_faceView addSubview:fView];
    }
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _headerView.viewModel = viewModel;
    CGFloat headerHeight = [ATOMRecentDetailHeaderView calculateHeaderViewHeightWith:viewModel];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
    _recentDetailTableView.tableHeaderView = _headerView;
}

#pragma mark - ClickEvent

- (void)changePage:(id)sender {
    NSInteger page = _pageControl.currentPage;
    [_faceView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _pageControl.currentPage = page;
}

#pragma mark - ATOMFaceViewDelegate

- (void)selectFaceView:(NSString *)str {
    NSString *newStr = [NSString stringWithFormat:@"%@%@", _sendCommentView.text, str];
    _sendCommentView.text = newStr;
    [self textDidChange:nil];
}

- (void)addNotificationToRecentDetailView {
    _lastContentSizeHeight = 30;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEnd:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - NSNotification

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
    _currentBottomViewFrame = bottomViewFrame;
    _bottomView.frame = bottomViewFrame;
    _lastContentSizeHeight = contentSize.height;
}

- (void)textDidEnd:(NSNotification *)notification {
    if (_isFaceViewVisible == NO) {
        [self restoreBottomView];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    _isKeyboardVisible = YES;
    [self hideFaceView];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _isKeyboardVisible = NO;
}

#pragma mark - *********************************

- (void)restoreBottomView {
    _lastContentSizeHeight = 30;
    _bottomView.frame = CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46);
    _sendCommentView.frame = CGRectMake(CGRectGetMaxX(_faceButton.frame) + 26, 8, CGRectGetMinX(_sendCommentButton.frame) - 26 * 2 - CGRectGetMaxX(_faceButton.frame), 30);
}

- (void)showFaceView {
    WS(ws);
    _isFaceViewVisible = YES;
    if (_isKeyboardVisible) {
        [_sendCommentView resignFirstResponder];
    } else {
    }
    
    [UIView animateWithDuration:.25 animations:^{
        
        CGRect frame = ws.bottomView.frame;
        frame.origin.y = CGHeight(self.frame) - faceViewHeight - CGHeight(frame) - 40;
        ws.bottomView.frame = frame;
        ws.faceView.hidden = NO;
        ws.pageControl.hidden = NO;
    }];
    
}

- (BOOL)isFaceViewShow {
    return _isFaceViewVisible;
}

- (void)hideFaceView {
    //当键盘显示时隐藏faceView和pageControl
    _faceView.hidden = YES;
    _pageControl.hidden = YES;
    //把键盘显示标记成YES，表情显示标记成NO
    _isFaceViewVisible = NO;
    if (!_isKeyboardVisible) {
        [self restoreBottomView];
    }
}

- (BOOL)isEditingCommentView {
    return _isKeyboardVisible || _isFaceViewVisible;
}


- (void)hideCommentView {
    if (_isKeyboardVisible) {
        [_sendCommentView resignFirstResponder];
    } else if (_isFaceViewVisible) {
        [self hideFaceView];
    }
}































@end
