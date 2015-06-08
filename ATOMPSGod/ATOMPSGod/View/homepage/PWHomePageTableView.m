//
//  PWHomePageTableView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWHomePageTableView.h"

@implementation PWHomePageTableView

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
        _noDataViewCustom.hidden = true;
        [self addSubview:_noDataViewCustom];
    }
    return _noDataViewCustom;
}

-(void)reloadData {
    [super reloadDataCustom];
    if (self) {
        for (int i = 0; i < [self numberOfSections]; i++) {
            if ([self numberOfRowsInSection:i] > 0) {
                self.noDataViewCustom.hidden = true;
                break;
            }
            
            NSLog(@"PWHomePageTableView.h reloadData hidden = false");
            self.noDataViewCustom.hidden = false;
        }
    }
}

@end
