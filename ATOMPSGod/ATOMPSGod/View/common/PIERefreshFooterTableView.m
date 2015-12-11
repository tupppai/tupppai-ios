//
//  RefreshFooterTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/19/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PIERefreshFooterTableView.h"

@implementation PIERefreshFooterTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
            [animatedImages addObject:image];
        }
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
        
        self.mj_footer = footer;
        self.tableFooterView = [UIView new];
    }
    return self;
}
-(void) loadMoreHotData {
    [_psDelegate didPullRefreshUp:self];
}

@end
