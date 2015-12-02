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
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
            [animatedImages addObject:image];
        }
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
        [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
        self.mj_footer = footer;
    } else {
        [self.mj_footer removeFromSuperview];
    }

}
- (void)setToRefreshTop:(BOOL)toRefreshTop {
    if (toRefreshTop) {
        
        
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
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
        // 设置普通状态的动画图片
        [header setImages:idleImages forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:animatedImages forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:animatedImages forState:MJRefreshStateRefreshing];
        // 设置header
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        self.mj_header = header;
    } else {
        [self.mj_header removeFromSuperview];
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
