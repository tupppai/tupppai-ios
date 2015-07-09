//
//  KCommentDetailTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWCommentDetailTableView.h"

@implementation PWCommentDetailTableView

@synthesize noDataViewCustom = _noDataViewCustom;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

#pragma mark lazy initilize
- (ATOMNoDataView *)noDataViewCustom {
    if (!_noDataViewCustom) {
        _noDataViewCustom = [ATOMNoDataView new];
        [self addSubview:_noDataViewCustom];
        [_noDataViewCustom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width/2, self.bounds.size.width/2));
        }];
    }
    return _noDataViewCustom;
}

-(void)reloadData {
    [super reloadDataCustom];
    if (self) {
        for (int i = 0; i < [self numberOfSections]; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                self.noDataViewCustom.hidden = YES;
                break;
            }
            self.noDataViewCustom.hidden = NO;
        }
    }
}

@end
