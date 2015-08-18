//
//  ZZCommentHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ZZCommentHeaderView.h"

@interface ZZCommentHeaderView ()


@end

@implementation ZZCommentHeaderView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kCommentTableViewHeaderHeight);
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding15, kCommentTableViewHeaderHeight - kPadding10 - kFont14, SCREEN_WIDTH - kPadding15, kFont14)];
    _titleLabel.font = [UIFont systemFontOfSize:kFont14];
    _titleLabel.textColor = [UIColor colorWithHex:0x637685];
    [self addSubview:_titleLabel];
}






























@end
