//
//  PIEShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareView.h"
#import "AppDelegate.h"
@implementation PIEShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.blurRadius = 10;
        self.dynamic = YES;
        [self addSubview:self.shareSheetView];
        [self.shareSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.95);
            make.height.equalTo(@240);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
        [self configClickEvent];
    }
    return self;
}

-(PIESharesheetView *)shareSheetView {
    if (!_shareSheetView) {
        _shareSheetView = [PIESharesheetView new];
    }
    return _shareSheetView;
}
-(void)configClickEvent {
    
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
    [self addGestureRecognizer:tapGes];
}
- (void)tapOnSelf:(UIGestureRecognizer*)gesture {
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    self.frame = view.bounds;
    [view addSubview:self];
    self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)show {
    [[AppDelegate APP].window addSubview:self];
    self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
-(void)dismiss {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
@end
