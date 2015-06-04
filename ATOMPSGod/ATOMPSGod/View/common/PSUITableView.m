//
//  PSUITableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PSUITableView.h"

@implementation PSUITableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
        [self addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        self.header.updatedTimeHidden = YES;
        self.header.stateHidden = YES;
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
            [animatedImages addObject:image];
        }
        UIImageView* mascotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 30, -30, 40, 30)];
        mascotImageView.image = [UIImage imageNamed:@"loading_mascot"];
        [self addSubview:mascotImageView];
        [self.gifHeader setImages:animatedImages forState:MJRefreshHeaderStateIdle];
        [self.gifHeader setImages:animatedImages forState:MJRefreshHeaderStateRefreshing];
        self.gifFooter.refreshingImages = animatedImages;
        self.footer.stateHidden = YES;
        
        _noDataView = [ATOMNoDataView new];
        [self insertSubview:_noDataView atIndex:1];
        _noDataView.hidden = true;
    }
    return self;
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

-(void)reloadData {
        [super reloadData];
    if (self) {
        if ([self numberOfRowsInSection:0] <= 0) {
            _noDataView.hidden = false;
        } else {
            _noDataView.hidden = true;
        }
    }
}

@end
