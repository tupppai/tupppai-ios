//
//  PWRefreshBaseTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWRefreshBaseTableView.h"

@implementation PWRefreshBaseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configRefresh];
        self.tableFooterView = [UIView new];
        _firstReload = YES;
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
#pragma mark lazy initilize
- (ATOMNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [ATOMNoDataView new];
        [self addSubview:_noDataView];
        _noDataView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.bounds.size.width/4, CGRectGetMidY(self.bounds)-self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
    }
    return _noDataView;
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
    NSLog(@"PWRefreshBaseTableView reloadData");
    NSLog(@"_firstReload %d",_firstReload);
    [super reloadData];
    if (!_firstReload) {

        if (self) {
            for (int i = 0; i < [self numberOfSections]; i++) {
                if ([self numberOfRowsInSection:i] > 0) {
                    self.noDataView.hidden = true;
                    break;
                }
                self.noDataView.hidden = false;
            }
        }
    }
    _firstReload = NO;
}

-(void)reloadDataCustom {
    [super reloadData];
}

@end
