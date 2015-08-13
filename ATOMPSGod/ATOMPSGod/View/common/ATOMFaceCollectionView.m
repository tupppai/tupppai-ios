//
//  ATOMFaceCollectionView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/12/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMFaceCollectionView.h"
@interface ATOMFaceCollectionView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *faceScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *facesArray;
@end
@implementation ATOMFaceCollectionView
static const CGFloat faceViewHeight = 200;
static const CGFloat pageControlHeight = 40;
static CGFloat pageControlWidth = 150;

//255
- (instancetype)init {
    self = [super init];
    if (self ) {
        _faceScrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, faceViewHeight)];;
        [_faceScrollView setShowsVerticalScrollIndicator:NO];
        [_faceScrollView setShowsHorizontalScrollIndicator:NO];
        _faceScrollView.pagingEnabled = YES;
        _faceScrollView.delegate = self;
        _faceScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 9, faceViewHeight);
//        _faceScrollView.hidden = YES;
        
        [self addSubview:_faceScrollView];
        [self setupFaceResouce];
        [self addFaceView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_faceScrollView.frame)+5, pageControlWidth, pageControlHeight)];
        _pageControl.numberOfPages = 9;
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xededed];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x00aedf];
        [_pageControl setCurrentPage:0];
        [_pageControl addTarget:self action:@selector(swipeFaceScrollView:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];

    }
    return self;
}

- (void)setupFaceResouce {
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

- (void)addFaceView {
    for (int i = 0; i < 9; i++) {
        ATOMFaceView *fView = [[ATOMFaceView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, kPadding10 * 2, SCREEN_WIDTH, faceViewHeight)];
        [fView loadFaceView:i Size:CGSizeMake(30, 40) Faces:_facesArray];
//        fView.delegate = self;
        [_faceScrollView addSubview:fView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _pageControl.currentPage = page;
}

- (void)swipeFaceScrollView:(id)sender {
    NSInteger page = _pageControl.currentPage;
    [_faceScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}

@end
