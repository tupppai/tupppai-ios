//
//  ATOMCommentDetailView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailView.h"
#import "ATOMFaceView.h"



@interface ATOMCommentDetailView () <UIScrollViewDelegate>

@property (nonatomic, assign) int lastContentSizeHeight;
@property (nonatomic, assign) BOOL isKeyboardVisible;
@property (nonatomic, assign) BOOL isFaceViewVisible;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGRect currentBottomViewFrame;
@property (nonatomic, strong) NSMutableArray *facesArray;
@end

@implementation ATOMCommentDetailView

static CGFloat faceViewHeight = 200;
static CGFloat pageControlWidth = 150;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.scrollEnabled = NO;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self setupFaceArray];
        [self addNotificationToCommentDetailView];
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
    _commentDetailTableView = [[RefreshFooterTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 46)];
    _commentDetailTableView.tableFooterView = [UIView new];
    _commentDetailTableView.rowHeight = 70;
    _commentDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _commentDetailTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag|UIScrollViewKeyboardDismissModeInteractive;
    [self addSubview:_commentDetailTableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _bottomView.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [_bottomView.layer addSublayer:TopBorder];
    
    _sendCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGWidth(self.frame) - kPadding15 - 32, 7, 32, 32)];
    _sendCommentButton.titleLabel.font = [UIFont systemFontOfSize:kFont15];
    [_sendCommentButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendCommentButton setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    [_bottomView addSubview:_sendCommentButton];
    [_sendCommentButton addTarget:self action:@selector(tapSendCommentButton) forControlEvents:UIControlEventTouchUpInside];
    _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding15, 9.5, 21, 27)];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"comment_write"] forState:UIControlStateNormal];
    [_faceButton addTarget:self action:@selector(showFaceView) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_faceButton];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceButton.frame) + 26, 8, CGRectGetMinX(_sendCommentButton.frame) - 26 * 2 - CGRectGetMaxX(_faceButton.frame), 30)];
    _commentTextView.textColor = [UIColor blackColor];
    _commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_bottomView addSubview:_commentTextView];
    _commentText = @"";
    
    _placeholderString = @"发表你的神回复..";
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 30)];
    _placeHolderLabel.text = _placeholderString;
    _placeHolderLabel.textColor = [UIColor colorWithHex:0xcbcbcb];
    [_commentTextView addSubview:_placeHolderLabel];
    _placeHolderLabel.font = [UIFont systemFontOfSize:kFont14];

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

-(void)tapSendCommentButton {
    _commentText = _commentTextView.text;
    _commentTextView.text = @"";
    [self toggleSendCommentView];
}

- (void)setupFaceView {
    for (int i = 0; i < 9; i++) {
        ATOMFaceView *fView = [[ATOMFaceView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, kPadding10 * 2, SCREEN_WIDTH, faceViewHeight)];
        [fView loadFaceView:i Size:CGSizeMake(30, 40) Faces:_facesArray];
//        fView.delegate = self;
        [_faceView addSubview:fView];
    }
}

- (void)addNotificationToCommentDetailView {
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
-(void)toggleSendCommentView {
    if ([_commentTextView.text isEqualToString:@""]) {
        _sendCommentButton.enabled = NO;
        _placeHolderLabel.hidden = NO;
        [_sendCommentButton setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    } else {
        _sendCommentButton.enabled = YES;
        _placeHolderLabel.hidden = YES;
        [_sendCommentButton setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    }
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
    NSString *newStr = [NSString stringWithFormat:@"%@%@", _commentTextView.text, str];
    _commentTextView.text = newStr;
    [self textDidChange:nil];
}

#pragma mark - NSNotification

- (void)textDidChange:(NSNotification *)notification {
    CGSize contentSize = _commentTextView.contentSize;
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
    
    [self toggleSendCommentView];
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
    NSLog(@"_commentTextView.text %@",_commentTextView.text);
}

#pragma mark - *********************************

- (void)restoreBottomView {
    _lastContentSizeHeight = 30;
    _bottomView.frame = CGRectMake(0, CGHeight(self.frame) - 46, SCREEN_WIDTH, 46);
    _commentTextView.frame = CGRectMake(CGRectGetMaxX(_faceButton.frame) + 26, 8, CGRectGetMinX(_sendCommentButton.frame) - 26 * 2 - CGRectGetMaxX(_faceButton.frame), 30);
}

- (void)showFaceView {
    WS(ws);
    _isFaceViewVisible = YES;
    if (_isKeyboardVisible) {
        [_commentTextView resignFirstResponder];
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
        [_commentTextView resignFirstResponder];
    } else if (_isFaceViewVisible) {
        [self hideFaceView];
    }
}




@end
