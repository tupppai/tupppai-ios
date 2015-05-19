//
//  ATOMMyUploadCollectionViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyUploadCollectionViewCell.h"
#import "ATOMCollectionViewLabel.h"

@implementation ATOMMyUploadCollectionViewCell

static float cellWidth;
static float cellHeight;
static int collumnNumber = 3;

- (UIImageView *)workImageView {
    if (!_workImageView) {
        cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) * 6) / 3;
        cellHeight = cellWidth;
        _workImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        _workImageView.backgroundColor = [UIColor colorWithHex:0xe0e9f0];
        _workImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_workImageView];
    }
    return _workImageView;
}

- (ATOMCollectionViewLabel *)psLabel {
    if (!_psLabel) {
        cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) * 6) / 3;
        cellHeight = cellWidth;
        _psLabel = [[ATOMCollectionViewLabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_workImageView.frame) - 23, cellWidth, 23)];
        [_workImageView addSubview:_psLabel];
    }
    return _psLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setTotalPSNumber:(NSString *)totalPSNumber {
    _totalPSNumber = totalPSNumber;
    self.psLabel.number = totalPSNumber;
}

- (void)setColorType:(NSInteger)colorType {
    _colorType = colorType;
    self.psLabel.colorType = colorType;
}

@end
