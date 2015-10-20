//
//  PIERefreshCollectionView.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/17/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIERefreshCollectionView.h"

@implementation PIERefreshCollectionView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

    }
    return self;
}
-(void)setToRefreshBottom:(BOOL)toRefreshBottom {
    if (toRefreshBottom) {
        [self addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
            [animatedImages addObject:image];
        }
        self.gifFooter.refreshingImages = animatedImages;
        self.footer.stateHidden = YES;
    } else {
        [self.gifFooter removeFromSuperview];
    }

}
- (void)setToRefreshTop:(BOOL)toRefreshTop {
    if (toRefreshTop) {
        [self addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
            [animatedImages addObject:image];
        }
        NSMutableArray *idleImages = [NSMutableArray array];
        for (int i = 1; i<=7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading%d", i]];
            [idleImages addObject:image];
        }
        [self.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
        [self.gifHeader setImages:animatedImages forState:MJRefreshHeaderStateRefreshing];
        self.header.updatedTimeHidden = YES;
        self.header.stateHidden = YES;
    } else {
        [self.gifHeader removeFromSuperview];
    }
 
}
-(void) loadMoreHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullUpCollectionViewBottom:)]) {
        [_psDelegate didPullUpCollectionViewBottom:self];
    }}
-(void) loadNewHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullDownCollectionView:)]) {
        [_psDelegate didPullDownCollectionView:self];
    }
}
@end
