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
static float cellHeight = 150;
static int collumnNumber = 3;

- (UIImageView *)workImageView {
    if (!_workImageView) {
        cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *kPadding5) / 3;
        _workImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight - 25)];
        _workImageView.layer.borderWidth = 1;
        _workImageView.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
        _workImageView.backgroundColor = [UIColor colorWithHex:0xf9ffff];
        _workImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_workImageView];
    }
    return _workImageView;
}

- (ATOMCollectionViewLabel *)psLabel {
    if (!_psLabel) {
        cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *kPadding5) / 3;
        _psLabel = [[ATOMCollectionViewLabel alloc] initWithFrame:CGRectMake(0, cellHeight - 25, cellWidth, 25)];
        [self addSubview:_psLabel];
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
