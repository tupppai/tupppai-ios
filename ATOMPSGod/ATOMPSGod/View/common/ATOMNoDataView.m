//
//  ATOMNoDataView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMNoDataView.h"

@interface ATOMNoDataView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ATOMNoDataView

static int padding20 = 20;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 101) / 2, SCREEN_HEIGHT/2-NAV_HEIGHT-101, 101, 101)];
    _imageView.image = [UIImage imageNamed:@"ic_cry"];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame) - padding20, CGRectGetMaxY(_imageView.frame), 101 + 2 * padding20, 80)];
    _label.text = @"这里空空如也...";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:20.f];
    _label.textColor = [UIColor colorWithHex:0xadadad];
    [self addSubview:_label];
}















@end
