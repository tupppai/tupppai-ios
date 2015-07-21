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

//static float cellWidth;
//static float cellHeight;
//static int collumnNumber = 3;

- (UIImageView *)workImageView {
    if (!_workImageView) {
        _workImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _workImageView.backgroundColor = [UIColor colorWithHex:0xe0e9f0];
        _workImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_workImageView setClipsToBounds:YES];
        [self.contentView addSubview:_workImageView];
    }
    return _workImageView;
}

- (ATOMCollectionViewLabel *)psLabel {
    if (!_psLabel) {
        _psLabel = [[ATOMCollectionViewLabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_workImageView.frame) - 23, self.bounds.size.width, 23)];
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
