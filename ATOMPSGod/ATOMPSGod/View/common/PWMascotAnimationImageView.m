//
//  PWMascotAnimationImageView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PWMascotAnimationImageView.h"
#import "AppDelegate.h"
@implementation PWMascotAnimationView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:0xF7F7F7 andAlpha:0.95] CGColor], (id)[[UIColor colorWithHex:0xD7D7D7 andAlpha:0.95] CGColor], nil];
//        [self.layer insertSublayer:gradient atIndex:1];
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
        [_mascotImageView startAnimating];
        self.alpha = 1.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];

        //time out
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismiss];
        });

    }
    
}
-(void)dismiss {
    if (self) {
         [UIView animateWithDuration:0.5 animations:^{
             self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
