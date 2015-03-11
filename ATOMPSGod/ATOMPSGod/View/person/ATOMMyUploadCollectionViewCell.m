//
//  ATOMMyUploadCollectionViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyUploadCollectionViewCell.h"

@implementation ATOMMyUploadCollectionViewCell

static float cellWidth;
static float cellHeight = 150;
static int padding6 = 6;
static int collumnNumber = 3;

- (UIImageView *)workImageView {
    if (!_workImageView) {
        cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
        _workImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        _workImageView.layer.borderWidth = 1;
        _workImageView.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
        _workImageView.backgroundColor = [UIColor colorWithHex:0xf9ffff];
        _workImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_workImageView];
    }
    return _workImageView;
}

- (UILabel *)praiseLabel {
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
        _praiseLabel.backgroundColor = [UIColor blackColor];
        _praiseLabel.alpha = 0.7;
        _praiseLabel.textAlignment = NSTextAlignmentCenter;
        _praiseLabel.textColor = [UIColor whiteColor];
        [self.workImageView addSubview:_praiseLabel];
    }
    return _praiseLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setWorkImage:(UIImage *)workImage {
    _workImage = workImage;
    self.workImageView.image = _workImage;
}

- (void)setPraiseNumber:(NSInteger)praiseNumber {
    _praiseNumber = praiseNumber;
    self.praiseLabel.text = [NSString stringWithFormat:@"%d",(int)_praiseNumber];
}


@end
