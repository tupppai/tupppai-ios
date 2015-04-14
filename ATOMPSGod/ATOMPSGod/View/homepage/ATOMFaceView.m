//
//  ATOMFaceView.m
//  ATOMPSGod
//
//  Created by atom on 15/4/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFaceView.h"

@interface ATOMFaceView ()
{
    CGFloat horizontalInterval;
}

@end

@implementation ATOMFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)loadFaceView:(NSInteger)page Size:(CGSize)size Faces:(NSMutableArray *)arr{
    horizontalInterval = (CGWidth(self.frame) - 9 * size.width) / 10;
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            button.frame = CGRectMake(column * size.width + horizontalInterval * (column + 1), row * size.height, size.width, size.height);
            button.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:29.f];
            [button setTitle:arr[column + row * 9 + page * 36] forState:UIControlStateNormal];
            button.tag = column + row * 9 + page * 36;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

- (void)clickButton:(UIButton *)sender {
    NSString *str = sender.titleLabel.text;
    if ([_delegate respondsToSelector:@selector(selectFaceView:)]) {
        [_delegate selectFaceView:str];
    }
}


















@end
