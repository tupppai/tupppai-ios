//
//  PIEShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareView.h"
#import "AppDelegate.h"
#import "POP.h"
@implementation PIEShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.shareSheetView];
        [self.shareSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.98);
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
    UITapGestureRecognizer* tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes1:)];
    [self.shareSheetView.icon1 addGestureRecognizer:tapGes1];

    UITapGestureRecognizer* tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes2:)];
    [self.shareSheetView.icon2 addGestureRecognizer:tapGes2];
    UITapGestureRecognizer* tapGes3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes3:)];
    [self.shareSheetView.icon3 addGestureRecognizer:tapGes3];
    UITapGestureRecognizer* tapGes4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes4:)];
    [self.shareSheetView.icon4 addGestureRecognizer:tapGes4];
    UITapGestureRecognizer* tapGes5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes5:)];
    [self.shareSheetView.icon5 addGestureRecognizer:tapGes5];
    UITapGestureRecognizer* tapGes6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes6:)];
    [self.shareSheetView.icon6 addGestureRecognizer:tapGes6];
    UITapGestureRecognizer* tapGes7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes7:)];
    [self.shareSheetView.icon7 addGestureRecognizer:tapGes7];
    UITapGestureRecognizer* tapGes8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes8:)];
    [self.shareSheetView.icon8 addGestureRecognizer:tapGes8];
    
    UITapGestureRecognizer* tapGesCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesCancel:)];
    [self.shareSheetView.cancelLabel addGestureRecognizer:tapGesCancel];
    
}
- (void)tapOnSelf:(UIGestureRecognizer*)gesture {
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}
- (void)tapGes1:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare1)]) {
        [_delegate tapShare1];
    }
}
- (void)tapGes2:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare2)]) {
        [_delegate tapShare2];
    }
}
- (void)tapGes3:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare3)]) {
        [_delegate tapShare3];
    }
}
- (void)tapGes4:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare4)]) {
        [_delegate tapShare4];
    }
}
- (void)tapGes5:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare5)]) {
        [_delegate tapShare5];
    }
}
- (void)tapGes6:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare6)]) {
        [_delegate tapShare6];
    }
}
- (void)tapGes7:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare7)]) {
        [_delegate tapShare7];
    }
}
- (void)tapGes8:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShare8)]) {
        [_delegate tapShare8];
    }
}
- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShareCancel)]) {
        [_delegate tapShareCancel];
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
//    [UIView animateWithDuration:0.2 animations:^{
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
//    }];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
                         }];
                     }
     ];
    
//    [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
//    }];

}
-(void)dismiss {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
@end
