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
#import "DDCollectManager.h"

#define height_sheet 251.0f

@implementation PIEShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = [AppDelegate APP].window.bounds;
        [self addSubview:self.dimmingView];
        [self addSubview:self.sheetView];
        [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.965);
            make.height.equalTo(@(height_sheet));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(height_sheet).with.priorityHigh();
        }];
//        self.delegate = self;
        
        [self configClickEvent];
    }
    return self;
}
-(UIVisualEffectView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIVisualEffectView alloc]initWithFrame:self.bounds];
        _dimmingView.alpha = 0.87;
        UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _dimmingView.effect = effect;
    }
    return _dimmingView;
}



- (void)toggleCollectIconStatus:(BOOL)isSelected{
    if (isSelected) {
        self.sheetView.icon8.selected = YES;

    }
    else
    {
        self.sheetView.icon8.selected = NO;
    }
}

-(PIESharesheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [PIESharesheetView new];
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
    UITapGestureRecognizer* tapGes8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes8:)];
    [self.sheetView.icon8 addGestureRecognizer:tapGes8];
    
    UITapGestureRecognizer* tapGesCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesCancel:)];
    [self.sheetView.cancelLabel addGestureRecognizer:tapGesCancel];
    
}
- (void)tapOnSelf:(UIGestureRecognizer*)gesture {
    if ([self.dimmingView hitTest:[gesture locationInView:self.dimmingView] withEvent:nil] == self.dimmingView ) {
        [self dismiss];
    }
}


- (void)tapGes1:(UIGestureRecognizer*)gesture {
    // sina weibo
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shareViewDidShare:socialShareType:)])
    {
        [_delegate shareViewDidShare:self
                     socialShareType:ATOMShareTypeSinaWeibo];
    }
}
- (void)tapGes2:(UIGestureRecognizer*)gesture {
    
    // QQ zone
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shareViewDidShare:socialShareType:)])
    {
        [_delegate shareViewDidShare:self
                     socialShareType:ATOMShareTypeQQZone];
    }
}
- (void)tapGes3:(UIGestureRecognizer*)gesture {
    
    // Wechat Moments
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shareViewDidShare:socialShareType:)])
    {
        [_delegate shareViewDidShare:self
                     socialShareType:ATOMShareTypeWechatMoments];
    }
}
- (void)tapGes4:(UIGestureRecognizer*)gesture {
    
    // Wechat Friends
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shareViewDidShare:socialShareType:)]) {
        [_delegate shareViewDidShare:self
                     socialShareType:ATOMShareTypeWechatFriends];
    }
}
- (void)tapGes5:(UIGestureRecognizer*)gesture {
    
    // QQ Friends
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shareViewDidShare:socialShareType:)]) {
        [_delegate shareViewDidShare:self
                     socialShareType:ATOMShareTypeQQFriends];
    }
}
- (void)tapGes6:(UIGestureRecognizer*)gesture {
    
    // Copy to pasteboards

    // Use DDShareManager here.
    if (_delegate && [_delegate respondsToSelector:@selector(shareViewDidPaste:)]) {
        [_delegate shareViewDidPaste:self];
        
        if (_weakVM != nil) {
            [DDShareManager copy:_weakVM];
        }
    }
    
}
- (void)tapGes7:(UIGestureRecognizer*)gesture {
    
    // report unusual usuage

    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(shareViewDidReportUnusualUsage:)]) {
        [_delegate shareViewDidReportUnusualUsage:self];
        
        if (_weakVM != nil)
        {
            (self.reportActionSheet).vm = _weakVM;
            [self dismiss];
            [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
        }
    }
    
    
}
- (void)tapGes8:(UIGestureRecognizer*)gesture {
    
    // Collect this PageVM
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(shareViewDidCollect:)]) {
        [_delegate shareViewDidCollect:self];
        
        if (_weakVM != nil) {
            NSMutableDictionary *param = [NSMutableDictionary new];
            _weakVM.collected = !_weakVM.collected;
            if (_weakVM.collected) {
                //收藏
                [param setObject:@(1) forKey:@"status"];
            } else {
                //取消收藏
                [param setObject:@(0) forKey:@"status"];
            }
            [DDCollectManager toggleCollect:param
                               withPageType:_weakVM.type
                                     withID:_weakVM.ID withBlock:^(NSError *error) {
                if (!error) {
                    if (  _weakVM.collected) {
                        [Hud textWithLightBackground:@"收藏成功"];
                    } else {
                        [Hud textWithLightBackground:@"取消收藏成功"];
                    }
                    
                }   else {
                    _weakVM.collected = !_weakVM.collected;
                }
                [self toggleCollectIconStatus:_weakVM.collected];
                                         
            }];
        }
    }
}


- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    
    if (_delegate && [_delegate respondsToSelector:@selector(shareViewDidCancel:)])
    {
        [_delegate shareViewDidCancel:self];
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
        make.bottom.equalTo(self).with.offset(height_sheet).with.priorityHigh();
    }];
    [UIView animateWithDuration:0.12 animations:^{
        [self.sheetView layoutIfNeeded];
        self.dimmingView.alpha = 0.2;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.dimmingView.alpha = 0.87;
        }
    }];
}

-(PIEActionSheet_Report *)reportActionSheet {
    if (!_reportActionSheet) {
        _reportActionSheet = [PIEActionSheet_Report new];
    }
    return _reportActionSheet;
}
@end
