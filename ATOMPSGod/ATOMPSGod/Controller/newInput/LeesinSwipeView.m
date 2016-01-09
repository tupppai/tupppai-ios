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
}

-(void)reloadData {
    [super reloadData];
    if (self.type == LeesinSwipeViewTypeMission && self.numberOfItems == 0) {
//        NSLog(@"should show empty set");
        //declare delegate in this class to specify no empty if first loading
    }
}
@end
