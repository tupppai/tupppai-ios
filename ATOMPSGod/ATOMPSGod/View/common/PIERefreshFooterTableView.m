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
        [self addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
        NSMutableArray *animatedImages = [NSMutableArray array];
        for (int i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
            [animatedImages addObject:image];
        }
      self.gifFooter.refreshingImages = animatedImages;
        self.footer.stateHidden = YES;
        self.tableFooterView = [UIView new];
    }
    return self;
}
-(void) loadMoreHotData {
    [_psDelegate didPullRefreshUp:self];
}

@end
