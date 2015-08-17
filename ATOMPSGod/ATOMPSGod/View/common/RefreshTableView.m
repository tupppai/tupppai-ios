//
//  RefreshTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "RefreshTableView.h"
@implementation RefreshTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configRefresh];
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (void) configRefresh {
    [self addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
    [self addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
        [animatedImages addObject:image];
    }
    UIImageView* mascotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 30, -30, 40, 30)];
    mascotImageView.image = [UIImage imageNamed:@"loading_mascot"];
    [self addSubview:mascotImageView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHex:0xf5f5f5 andAlpha:0.8];
    [self addSubview:line];
    [self.gifHeader setImages:animatedImages forState:MJRefreshHeaderStateIdle];
    [self.gifHeader setImages:animatedImages forState:MJRefreshHeaderStateRefreshing];
    self.header.updatedTimeHidden = YES;
    self.header.stateHidden = YES;
    self.gifFooter.refreshingImages = animatedImages;
    self.footer.stateHidden = YES;
}

-(void) loadNewHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullRefreshDown:)]) {
        [_psDelegate didPullRefreshDown:self];
    }
}
-(void) loadMoreHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullRefreshUp:)]) {
        [_psDelegate didPullRefreshUp:self];
    }}

@end
