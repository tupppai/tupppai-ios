//
//  PWRefreshBaseTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PIERefreshTableView.h"

@implementation PIERefreshTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
        header.automaticallyChangeAlpha = YES;
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
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
        
        /*BUG FIX: 为了避免因为returnValueCount == 0而让footer一直扯着底部不断死循环加载数据，设置footer要
                   拉高到footer高度的1.4倍的时候再出发loadMore方法。
         */
        footer.triggerAutomaticallyRefreshPercent = 1.4;
        [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
        
        self.mj_footer = footer;
        
        self.tableFooterView = [UIView new];
    }
    return self;
}


-(void) loadNewHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullRefreshDown:)]) {
        __weak typeof(self) weakSelf = self;
        [_psDelegate didPullRefreshDown:weakSelf];
    }
}
-(void) loadMoreHotData {
    if (_psDelegate && [_psDelegate respondsToSelector:@selector(didPullRefreshUp:)]) {
        __weak typeof(self) weakSelf = self;
        [_psDelegate didPullRefreshUp:weakSelf];
    }}


@end
