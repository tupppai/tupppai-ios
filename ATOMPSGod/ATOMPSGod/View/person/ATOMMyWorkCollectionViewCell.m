//
//  ATOMMyWorkCollectionViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyWorkCollectionViewCell.h"

@implementation ATOMMyWorkCollectionViewCell

- (UIImageView *)workImageView {
    if (!_workImageView) {
        _workImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _workImageView.layer.borderWidth = 1;
        _workImageView.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
        _workImageView.backgroundColor = [UIColor colorWithHex:0xf9ffff];
        _workImageView.contentMode = UIViewContentModeScaleAspectFill;
        _workImageView.clipsToBounds = YES;
        [self.contentView addSubview:_workImageView];
    }
    return _workImageView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


























@end
