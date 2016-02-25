//
//  PIEShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareView.h"

#import "DDCollectManager.h"

#define height_sheet 251.0f
@interface PIEShareView ()
@property (nonatomic,strong)  PIEPageVM* pageViewModel;
@property (nonnull, strong, nonatomic) PIESharesheetView     *sheetView;
//@property (nonnull, strong, nonatomic) UIVisualEffectView    *dimmingView;
@property (nonnull, nonatomic, strong) PIEActionSheet_Report * reportActionSheet;
@end
@implementation PIEShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
        self.frame = [AppDelegate APP].window.bounds;
        [self addSubview:self.sheetView];
        [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.multipliedBy(0.965);
            make.height.equalTo(@(height_sheet));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(height_sheet).with.priorityHigh();
        }];
        
        [self configClickEvent];
    }
    return self;
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
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self ) {
        [self dismiss];
    }
}


- (void)tapGes1:(UIGestureRecognizer*)gesture {
    // sina weibo
    [self postShareType:ATOMShareTypeSinaWeibo
      selectedViewModel:_pageViewModel];
    
}
- (void)tapGes2:(UIGestureRecognizer*)gesture {
    
    // QQ zone
    [self postShareType:ATOMShareTypeQQZone
      selectedViewModel:_pageViewModel];
    
}
- (void)tapGes3:(UIGestureRecognizer*)gesture {
    
    // Wechat Moments
    [self postShareType:ATOMShareTypeWechatMoments
      selectedViewModel:_pageViewModel];
}
- (void)tapGes4:(UIGestureRecognizer*)gesture {
    
    // Wechat Friends
    [self postShareType:ATOMShareTypeWechatFriends
      selectedViewModel:_pageViewModel];
}
- (void)tapGes5:(UIGestureRecognizer*)gesture {
    
    // QQ Friends
    
   [self postShareType:ATOMShareTypeQQFriends
     selectedViewModel:_pageViewModel];
}
- (void)tapGes6:(UIGestureRecognizer*)gesture {
    
    // Copy to pasteboards
    [DDShareManager copy:_pageViewModel];
}
- (void)tapGes7:(UIGestureRecognizer*)gesture {
  
    
    (self.reportActionSheet).vm = _pageViewModel;
    [self dismiss];
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
    
}
- (void)tapGes8:(UIGestureRecognizer*)gesture {
   
    [self collect];

}


- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    
    [self dismiss];
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(shareViewDidCancel:)])
    {
        [_delegate shareViewDidCancel:self];
    }
    
}

#pragma mark - public methods
- (void)showInView:(UIView *)view animated:(BOOL)animated pageViewModel:(PIEPageVM *)pageVM
{
    [self allocPageViewModel:pageVM];
    [self toggleCollectIconStatus:self.pageViewModel.collected];

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

- (void)show:(PIEPageVM *)pageVM
{
    [self allocPageViewModel:pageVM];
    
    [self toggleCollectIconStatus:self.pageViewModel.collected];
    
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

- (void)allocPageViewModel:(PIEPageVM *)pageVM {
    self.pageViewModel = pageVM;
    [self addObserverToViewModel:pageVM];
}

- (void)deallocPageViewModel {
    [self removeObserverToViewModel:self.pageViewModel];
    self.pageViewModel = nil;
}

- (void)addObserverToViewModel:(PIEPageVM*)viewModel {
    [viewModel addObserver:self forKeyPath:@"collected" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObserverToViewModel:(PIEPageVM*)viewModel {
    [viewModel removeObserver:self forKeyPath:@"collected"];
}
-(void)dismiss {
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(height_sheet).with.priorityHigh();
    }];
    [UIView animateWithDuration:0.12 animations:^{
        [self.sheetView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self deallocPageViewModel];
        }
    }];
}



#pragma mark - helper methods
- (void)postShareType:(ATOMShareType)shareType
    selectedViewModel:(PIEPageVM *)selectedVM
{
    @weakify(self);
    [DDShareManager
     postSocialShare2:selectedVM
     withSocialShareType:shareType
     block:^(BOOL success) {
         if (success) {
             @strongify(self);
             selectedVM.model.totalShareNumber++;
             if (_delegate != nil &&
                 [_delegate respondsToSelector:@selector(shareView:didShareWithType:)]) {
                 [_delegate shareView:self didShareWithType:shareType];
             }
             [self dismiss];

         }
     }];
}

- (void)collect
{
    [self.pageViewModel collect:^(BOOL success) {
        if (success) {
            if (_delegate != nil &&[_delegate respondsToSelector:@selector(shareViewDidCollect:)]) {
                [_delegate shareViewDidCollect:self];
            }
        }
    }];
  
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

#pragma mark - lazy loadings
-(PIEActionSheet_Report *)reportActionSheet {
    if (!_reportActionSheet) {
        _reportActionSheet = [PIEActionSheet_Report new];
    }
    return _reportActionSheet;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
      if ([keyPath isEqualToString:@"collected"]) {
        BOOL value = [[change objectForKey:@"new"]boolValue];
        self.sheetView.icon8.selected = value;
    }
}
@end
