//
//  PIEChooseChargeSourceView.m
//  TUPAI
//
//  Created by chenpeiwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChooseChargeSourceView.h"
#import "PIEChooseChargeSourceActionSheet.h"


@interface PIEChooseChargeSourceView()
@property (nonatomic,strong) PIEChooseChargeSourceActionSheet *actionSheet;
@property (nonatomic,strong) MASConstraint *actionSheetMasConstraintCenterY;
@end


@implementation PIEChooseChargeSourceView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
        
    }
    return self;
}
- (void)commonInit {
    
    self.frame = [AppDelegate APP].window.bounds;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
    [self addGestureRecognizer:recognizer];
    
    [self addSubview:self.actionSheet];
    [self.actionSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self);
        make.height.equalTo(@150);
        _actionSheetMasConstraintCenterY = make.bottom.equalTo(self).with.offset(150);
    }];
    
    [[_actionSheet.zhifubaoButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseChargeSourceView:tapButtonOfIndex:)]) {
            [_delegate chooseChargeSourceView:self tapButtonOfIndex:0];
        }
    }];
    [[_actionSheet.wechatButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseChargeSourceView:tapButtonOfIndex:)]) {
            [_delegate chooseChargeSourceView:self tapButtonOfIndex:1];
        }
    }];
    [[_actionSheet.cancelButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseChargeSourceView:tapButtonOfIndex:)]) {
            [_delegate chooseChargeSourceView:self tapButtonOfIndex:2];
        }
    }];
    
}

- (void)tapOnSelf:(UITapGestureRecognizer*)recognizer {
    if ([self hitTest:[recognizer locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}
- (void)show {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[AppDelegate APP].window addSubview:self];
    [self layoutIfNeeded];
    [self.actionSheetMasConstraintCenterY setOffset:0];
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
                         [self.actionSheet layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }
                     }
     ];
}


-(void)dismiss {
    [self.actionSheetMasConstraintCenterY setOffset:150];
    [UIView animateWithDuration:0.12 animations:^{
        [self.actionSheet layoutIfNeeded];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
//            if (_delegate && [_delegate respondsToSelector:@selector(chargeMoneyViewDidDismiss:)]) {
//                [_delegate chargeMoneyViewDidDismiss:self];
//            }
        }
    }];
}

-(PIEChooseChargeSourceActionSheet *)actionSheet {
    if (_actionSheet == nil) {
        _actionSheet = [PIEChooseChargeSourceActionSheet actionSheet];
    }
    return _actionSheet;
}


@end
