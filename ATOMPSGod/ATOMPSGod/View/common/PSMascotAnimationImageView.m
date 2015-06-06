//
//  PSMascotAnimationImageView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PSMascotAnimationImageView.h"

@implementation PSMascotAnimationImageView
- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        NSInteger animationImageCount = 3;
        for (int i = 1; i <= animationImageCount; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_center%d", i]]];
        }
        self.frame = CGRectMake(SCREEN_WIDTH/2 - 20, SCREEN_HEIGHT/2 - NAV_HEIGHT, 40, 65);
        self.animationImages = images;
        self.animationDuration = 1;
        self.animationRepeatCount = INFINITY;
        self.hidden = true;
    }
    return self;
}
-(void)show {
    if (self) {
        [self startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden = false;
    }
}
-(void)dismiss {
    if (self) {
        self.hidden = true;
    }
}
@end
