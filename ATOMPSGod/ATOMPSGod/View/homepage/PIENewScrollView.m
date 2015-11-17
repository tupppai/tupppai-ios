//
//  kfcHomeScrollView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIENewScrollView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIENewAskCollectionCell.h"
@interface PIENewScrollView ()
@property (nonatomic, strong) UIView* tableheaderView_activity;
@end

@implementation PIENewScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self addSubview:self.tableActivity];
        [self addSubview:self.collectionViewAsk];
        [self addSubview:self.tableReply];
    }
    return self;
}

- (void)configSelf {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.type = PIENewScrollTypeAsk;
}

-(PIERefreshTableView *)tableReply {
    if (!_tableReply) {
        _tableReply = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
        _tableReply.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableReply.backgroundColor = [UIColor clearColor];
        _tableReply.showsVerticalScrollIndicator = NO;
    }
    return _tableReply;
}
-(PIERefreshTableView *)tableActivity {
    if (!_tableActivity) {
        _tableActivity = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
        _tableActivity.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableActivity.backgroundColor = [UIColor clearColor];
        _tableActivity.showsVerticalScrollIndicator = NO;
        _tableActivity.tableHeaderView = self.tableheaderView_activity;
    }
    return _tableActivity;
}

-(PIERefreshCollectionView *)collectionViewAsk {
    if (!_collectionViewAsk) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        layout.minimumColumnSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        _collectionViewAsk = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
        _collectionViewAsk.toRefreshBottom = YES;
        _collectionViewAsk.backgroundColor = [UIColor clearColor];
        _collectionViewAsk.toRefreshTop = YES;
        _collectionViewAsk.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionViewAsk.showsVerticalScrollIndicator = NO;
    }
    return _collectionViewAsk;
}

-(SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, _tableActivity.bounds.size.width, 224)];
        _swipeView.backgroundColor = [UIColor clearColor];
        _swipeView.wrapEnabled = YES;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    return _swipeView;
}
-(UIView *)tableheaderView_activity {
    if (!_tableheaderView_activity) {
        float ratio = 286.0/375.0;
        NSInteger height = ratio*SCREEN_WIDTH;
        _tableheaderView_activity = [[UIView alloc]initWithFrame:CGRectMake(0,0, _tableActivity.bounds.size.width, height)];
        _tableheaderView_activity.backgroundColor = [UIColor whiteColor];
        [_tableheaderView_activity addSubview:self.swipeView];
    }
    return _tableheaderView_activity;
}
- (void) onTimer
{
    [self.swipeView scrollByNumberOfItems:1 duration:0.5];
}

- (void)toggleWithType:(PIENewScrollType)type {
    _type = type;
    if (_type == PIENewScrollTypeActivity) {
        _tableActivity.scrollsToTop = YES;
        _collectionViewAsk.scrollsToTop = NO;
        _tableReply.scrollsToTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }
    else if (_type == PIENewScrollTypeAsk) {
        _tableActivity.scrollsToTop = NO;
        _collectionViewAsk.scrollsToTop = YES;
        _tableReply.scrollsToTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    } else {
        _tableActivity.scrollsToTop = NO;
        _collectionViewAsk.scrollsToTop = NO;
        _tableReply.scrollsToTop = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
        }];
    }
}


@end
