//
//  ATOMOtherPersonView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonView.h"
#import "ATOMOtherPersonCollectionHeaderView.h"

@interface ATOMOtherPersonView ()


@end

@implementation ATOMOtherPersonView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _uploadHeaderView = [ATOMOtherPersonCollectionHeaderView new];
    [self addSubview:_uploadHeaderView];
    _scrollView = [ATOMPersonPageScrollView new];
    [self addSubview:_scrollView];
}




















@end
