//
//  PIEFollowScrollView.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteScrollView.h"

@implementation PIEEliteScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self createSubView];
    }
    return self;
}

- (void)configSelf {
    self.frame = self.superview.bounds;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.type = PIEPageTypeEliteHot;
}

- (void)createSubView {
    [self initTable1];
    [self initTable2];
}

- (void)initTable1 {
    _tableFollow = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_HEIGHT)];
    _tableFollow.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableFollow.backgroundColor = [UIColor clearColor];
    _tableFollow.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableFollow];
}
- (void)initTable2 {
    _tableHot = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_HEIGHT)];
    _tableHot.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableHot.backgroundColor = [UIColor clearColor];
    _tableHot.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableHot];
    _tableHot.tableHeaderView = self.swipeView;
    
}
- (void) onTimer
{
    [self.swipeView scrollByNumberOfItems:1 duration:0.5];
}
-(SMPageControl *)pageControl_swipeView {
    if (!_pageControl_swipeView) {
        _pageControl_swipeView = [[SMPageControl alloc]initWithFrame:CGRectMake(0,0, 200, 20)];
    }
    return _pageControl_swipeView;
}



-(SwipeView *)swipeView {
    if (!_swipeView) {
        CGFloat height = 333.0/750 * SCREEN_WIDTH;
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, _tableHot.bounds.size.width, height)];
        _swipeView.backgroundColor = [UIColor clearColor];
        _swipeView.wrapEnabled = YES;
        [_swipeView addSubview:self.pageControl_swipeView];        
        CGPoint center = self.pageControl_swipeView.center;
        
        center.x = _swipeView.center.x;
        center.y = _swipeView.center.y+69;
        self.pageControl_swipeView.center = center;
        
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    return _swipeView;
}

- (void)toggle {
    if (_type == PIEPageTypeEliteFollow) {
        _type = PIEPageTypeEliteHot;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else {
        _type = PIEPageTypeEliteFollow;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }
}

- (void)toggleWithType:(PIEPageType)type {
    _type = type;
    if (_type == PIEPageTypeEliteFollow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }
}

-(void)toggleType {
    if (_type == PIEPageTypeEliteFollow) {
        _type = PIEPageTypeEliteHot;
    }
    else {
        _type = PIEPageTypeEliteFollow;
    }
}

-(void)setType:(PIEPageType)type {
    _type = type;
    if (type == PIEPageTypeEliteFollow) {
        self.tableFollow.scrollsToTop = YES;
        self.tableHot.scrollsToTop = NO;
    } else if (type == PIEPageTypeEliteHot) {
        self.tableFollow.scrollsToTop = NO;
        self.tableHot.scrollsToTop = YES;
    }
}
@end
