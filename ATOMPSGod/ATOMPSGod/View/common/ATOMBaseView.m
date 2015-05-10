//
//  ATOMBaseView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@implementation ATOMBaseView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xededed];
//        [self showPlaceHolder];
    }
    return self;
}

+ (double)scaleInView {
    const double wid = [[UIScreen mainScreen] bounds].size.width;
    const double hid = [[UIScreen mainScreen] bounds].size.height;
    
    if (hid < 568) {
        return 0.8;
    } else if ( wid <= 320 ) {
        return 0.8;
    } else if (wid <= 375){
        return 1;
    } else {
        return 1.06;
    }
}


@end
