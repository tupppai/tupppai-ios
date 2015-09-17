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
        for (int i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
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
