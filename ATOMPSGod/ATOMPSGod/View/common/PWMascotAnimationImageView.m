//
//  PWMascotAnimationImageView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWMascotAnimationImageView.h"

@implementation PWMascotAnimationView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,NAV_HEIGHT , SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:0xF7F7F7 andAlpha:0.95] CGColor], (id)[[UIColor colorWithHex:0xD7D7D7 andAlpha:0.95] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:1];
        [self createMascotImageView];
    }
    return self;
}

-(void)createMascotImageView{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSInteger animationImageCount = 3;
    for (int i = 1; i <= animationImageCount; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_center%d", i]]];
    }
    _mascotImageView = [UIImageView new];
    _mascotImageView.frame = CGRectMake(SCREEN_WIDTH/2 - 20, (SCREEN_HEIGHT - NAV_HEIGHT-TAB_HEIGHT)/2, 40, 65);
    _mascotImageView.animationImages = images;
    _mascotImageView.animationDuration = 1;
    _mascotImageView.animationRepeatCount = INFINITY;
    [self addSubview:_mascotImageView];
}

-(void)show {
    if (self) {
        NSLog(@"show PWMascotAnimationView");
        [_mascotImageView startAnimating];
        self.alpha = 1.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    } else {
    }
}
-(void)dismiss {
    if (self) {
        NSLog(@"dismiss PWMascotAnimationImageView");
         [UIView animateWithDuration:2 animations:^{
             self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
