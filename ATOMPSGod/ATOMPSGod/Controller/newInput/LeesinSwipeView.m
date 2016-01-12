//
//  LeesinSwipeView.m
//  TUPAI
//
//  Created by chenpeiwei on 1/9/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "LeesinSwipeView.h"

@implementation LeesinSwipeView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lsn_commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lsn_commonInit];
    }
    return self;
}

- (void)lsn_commonInit {
    self.scrollEnabled = YES;
    self.alignment = SwipeViewAlignmentEdge;
    self.pagingEnabled = NO;
    self.scrollView.emptyDataSetDelegate = self;
    self.scrollView.emptyDataSetSource = self;
    [self addSubview:self.emptyDisplayLabel];
}

-(void)reloadData {
    [super reloadData];
    if (self.type == LeesinSwipeViewTypeMission && self.numberOfItems == 0) {
        if (_emptyDataSetShouldDisplay) {
            self.emptyDisplayLabel.hidden = NO;
        }
    }
    else {
        self.emptyDisplayLabel.hidden = YES;
    }
}

-(void)setType:(LeesinSwipeViewType)type {
    if (_type == type) {
        return;
    }
    if (type == LeesinSwipeViewTypeMission) {
        _emptyDisplayLabel.text = @"没有任务数据，快去求p区寻找吧";

    } else  if (type == LeesinSwipeViewTypePHAsset) {
        _emptyDisplayLabel.text = @"一张照片都没有";

    }
}

-(UILabel *)emptyDisplayLabel {
    
    if (!_emptyDisplayLabel) {
        _emptyDisplayLabel = [UILabel new];
        _emptyDisplayLabel.text = @"没有任务数据，快去求p区寻找吧";
        _emptyDisplayLabel.font = [UIFont mediumTupaiFontOfSize:17];
        _emptyDisplayLabel.textAlignment  = NSTextAlignmentCenter;
        _emptyDisplayLabel.backgroundColor = [UIColor clearColor];
        _emptyDisplayLabel.hidden = YES;
    }
    return _emptyDisplayLabel;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.emptyDisplayLabel.frame = self.bounds;

}

@end
