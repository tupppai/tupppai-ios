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

- (UILabel *)psLabel {
    if (!_psLabel) {
        _psLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
        _psLabel.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
        _psLabel.font = [UIFont systemFontOfSize:12.f];
        _psLabel.textAlignment = NSTextAlignmentCenter;
        _psLabel.textColor = [UIColor whiteColor];
        [self.workImageView addSubview:_psLabel];
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
    self.psLabel.text = totalPSNumber;
}

@end
