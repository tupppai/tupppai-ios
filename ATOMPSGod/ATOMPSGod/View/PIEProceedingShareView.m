//
//  PIEProceedingShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingShareView.h"
#import "AppDelegate.h"
#import "POP.h"

@implementation PIEProceedingShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.3];
        [self addSubview:self.sheetView];
        [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.98);
            make.height.equalTo(@240);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(240).with.priorityHigh();
        }];
        [self configClickEvent];
    }
    return self;
}

-(void)setHideDeleteButton:(BOOL)hideDeleteButton {
    _hideDeleteButton = hideDeleteButton;
    if (hideDeleteButton) {
        self.sheetView.icon7.hidden = YES;
    } else {
        self.sheetView.icon7.hidden = NO;
    }
}
-(PIEProceedingShareSheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [PIEProceedingShareSheetView new];
    }
    return _sheetView;
}
-(void)configClickEvent {
    
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
    [self addGestureRecognizer:tapGes];
    UITapGestureRecognizer* tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes1:)];
    [self.sheetView.icon1 addGestureRecognizer:tapGes1];
    
    UITapGestureRecognizer* tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes2:)];
    [self.sheetView.icon2 addGestureRecognizer:tapGes2];
    UITapGestureRecognizer* tapGes3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes3:)];
    [self.sheetView.icon3 addGestureRecognizer:tapGes3];
    UITapGestureRecognizer* tapGes4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes4:)];
    [self.sheetView.icon4 addGestureRecognizer:tapGes4];
    UITapGestureRecognizer* tapGes5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes5:)];
    [self.sheetView.icon5 addGestureRecognizer:tapGes5];
    UITapGestureRecognizer* tapGes6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes6:)];
    [self.sheetView.icon6 addGestureRecognizer:tapGes6];
    UITapGestureRecognizer* tapGes7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes7:)];
    [self.sheetView.icon7 addGestureRecognizer:tapGes7];

    
    UITapGestureRecognizer* tapGesCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesCancel:)];
    [self.sheetView.cancelLabel addGestureRecognizer:tapGesCancel];
    
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

- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapShareCancel)]) {
        [_delegate tapShareCancel];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    [self layoutIfNeeded];
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0).with.priorityHigh();
    }];
    
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }
                     }
     ];
}

- (void)show {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.frame = [AppDelegate APP].window.bounds;
    [[AppDelegate APP].window addSubview:self];
    [self layoutIfNeeded];
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0).with.priorityHigh();
    }];
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }
                     }
     ];
    
    
}
-(void)dismiss {
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(240).with.priorityHigh();
    }];
    [UIView animateWithDuration:0.20 animations:^{
        [self.sheetView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
