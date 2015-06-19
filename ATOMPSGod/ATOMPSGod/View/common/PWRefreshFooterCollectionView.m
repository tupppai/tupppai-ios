//
//  PWRefreshFooterCollectionView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/19/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWRefreshFooterCollectionView.h"

@implementation PWRefreshFooterCollectionView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
            [animatedImages addObject:image];
        }
        self.gifFooter.refreshingImages = animatedImages;
        self.footer.stateHidden = YES;
    }
    return self;
}
#pragma mark lazy initilize
- (ATOMNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [ATOMNoDataView new];
        [self addSubview:_noDataView];
    }
    return _noDataView;
}

-(void) loadMoreHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullRefreshUp:)]) {
        [_psDelegate didPullUpCollectionViewBottom];
    }}

-(void)reloadData {
    [super reloadData];
    if (self) {
        for (int i = 0; i < [self numberOfSections]; i++) {
            if ([self numberOfItemsInSection:i] > 0) {
                self.noDataView.hidden = true;
                break;
            }
            self.noDataView.hidden = false;
        }
    }
}

-(void)reloadDataCustom {
    [super reloadData];
}
@end
