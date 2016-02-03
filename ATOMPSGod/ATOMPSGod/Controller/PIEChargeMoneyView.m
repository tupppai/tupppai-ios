//
//  PIEChargeMoneyView.m
//  TUPAI
//
//  Created by chenpeiwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChargeMoneyView.h"

@interface PIEChargeMoneyView()<UITextFieldDelegate>
@property (nonatomic,strong) PIEChargeMoneyPanelView *panelView;
@property (nonatomic,strong) MASConstraint *panelViewMasConstraintCenterY;

@end

@implementation PIEChargeMoneyView


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
    
    [self addSubview:self.panelView];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 200));
        make.centerX.equalTo(self);
        _panelViewMasConstraintCenterY = make.centerY.equalTo(self).with.offset(-SCREEN_HEIGHT);
    }];
    

    [[self.panelView.confirmButton rac_signalForControlEvents:UIControlEventTouchDown]subscribeNext:^(id x) {
        if (_delegate && [_delegate respondsToSelector:@selector(chargeMoneyView:tapConfirmButtonWithAmount:)]) {
                [_delegate chargeMoneyView:self
                tapConfirmButtonWithAmount:[self.panelView.moneyCountTextField.text doubleValue]];
        }
    }];
    _panelView.moneyCountTextField.delegate = self;
}
-(void)disableConfirmButton {
    self.panelView.confirmButton.enabled = NO;
}
- (void)tapOnSelf:(UITapGestureRecognizer*)recognizer {
    if ([self hitTest:[recognizer locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}
- (void)showWithAmoutToBeCharge:(CGFloat)amount {
    self.panelView.moneyCountTextField.text = [@(amount) stringValue];
    [self.panelView.moneyCountTextField becomeFirstResponder];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[AppDelegate APP].window addSubview:self];
    [self layoutIfNeeded];
    [self.panelViewMasConstraintCenterY setOffset:-60];
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
                         [self.panelView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }
                     }
     ];
}

- (void)show {
    
    [self.panelView.moneyCountTextField becomeFirstResponder];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[AppDelegate APP].window addSubview:self];
    [self layoutIfNeeded];
    [self.panelViewMasConstraintCenterY setOffset:-60];
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
                         [self.panelView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         }
                     }
     ];
}
-(void)dismiss {
    [self.panelViewMasConstraintCenterY setOffset:-SCREEN_HEIGHT];
    [UIView animateWithDuration:0.12 animations:^{
        [self.panelView layoutIfNeeded];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            self.panelView.moneyCountTextField.text = @"";
            [self removeFromSuperview];
            if (_delegate && [_delegate respondsToSelector:@selector(chargeMoneyViewDidDismiss:)]) {
                [_delegate chargeMoneyViewDidDismiss:self];
            }
        }
    }];
}

-(PIEChargeMoneyPanelView *)panelView {
    if (!_panelView) {
        _panelView = [PIEChargeMoneyPanelView chargeMoneyPanel];
        
    }
    return _panelView;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* for backspace */
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            if (newLength <= 6) {
                return YES;
            }
        }
    }
    
    return NO;

}
@end
