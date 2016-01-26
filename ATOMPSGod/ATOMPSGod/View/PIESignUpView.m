//
//  PIESignUpView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESignUpView.h"

#import "POP.h"
@implementation PIESignUpView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.3];
        [self addSubview:self.sheetView];
        [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.98);
            make.height.equalTo(@180);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(240).with.priorityHigh();
        }];
        [self configClickEvent];
    }
    return self;
}

-(PIESignUpSheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [PIESignUpSheetView new];
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
    
    UITapGestureRecognizer* tapGesCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesCancel:)];
    [self.sheetView.closeView addGestureRecognizer:tapGesCancel];
    
}
- (void)tapOnSelf:(UIGestureRecognizer*)gesture {
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}
- (void)tapGes1:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUp1)]) {
        [_delegate tapSignUp1];
    }
}
- (void)tapGes2:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUp2)]) {
        [_delegate tapSignUp2];
    }
}
- (void)tapGes3:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUp3)]) {
        [_delegate tapSignUp3];
    }
}

- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(tapSignUpClose)]) {
        [_delegate tapSignUpClose];
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
        make.bottom.equalTo(self).with.offset(180).with.priorityHigh();
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [self.sheetView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end