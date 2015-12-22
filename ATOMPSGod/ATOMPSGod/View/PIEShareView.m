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
#import "PIECellIconStatusChangedNotificationKey.h"

#define height_sheet 251.0f
@interface PIEShareView ()
@property (nonatomic,weak)  PIEPageVM* weakVM;
@property (nonnull, strong, nonatomic) PIESharesheetView     *sheetView;
@property (nonnull, strong, nonatomic) UIVisualEffectView    *dimmingView;
@property (nonnull, nonatomic, strong) PIEActionSheet_Report * reportActionSheet;
@end
@implementation PIEShareView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
        self.frame = [AppDelegate APP].window.bounds;
//        [self addSubview:self.dimmingView];
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
-(UIVisualEffectView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIVisualEffectView alloc]initWithFrame:self.bounds];
        _dimmingView.alpha = 0.87;
        UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _dimmingView.effect = effect;
    }
    return _dimmingView;
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
    [self postShareType:ATOMShareTypeSinaWeibo
      selectedViewModel:_weakVM];
    
}
- (void)tapGes2:(UIGestureRecognizer*)gesture {
    
    // QQ zone
    [self postShareType:ATOMShareTypeQQZone
      selectedViewModel:_weakVM];
    
}
- (void)tapGes3:(UIGestureRecognizer*)gesture {
    
    // Wechat Moments
    [self postShareType:ATOMShareTypeWechatMoments
      selectedViewModel:_weakVM];
}
- (void)tapGes4:(UIGestureRecognizer*)gesture {
    
    // Wechat Friends
    [self postShareType:ATOMShareTypeWechatFriends
      selectedViewModel:_weakVM];
}
- (void)tapGes5:(UIGestureRecognizer*)gesture {
    
    // QQ Friends
    
   [self postShareType:ATOMShareTypeQQFriends
     selectedViewModel:_weakVM];
}
- (void)tapGes6:(UIGestureRecognizer*)gesture {
    
    // Copy to pasteboards
    [DDShareManager copy:_weakVM];
}
- (void)tapGes7:(UIGestureRecognizer*)gesture {
    // report unusual usuage
    
    // ASSUMPTION: _weakVM is no nil.
    
    (self.reportActionSheet).vm = _weakVM;
    // dismiss shareView while reportActionSheet shows up
    [self dismiss];
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
    
}
- (void)tapGes8:(UIGestureRecognizer*)gesture {
    // Collect this PageVM
    
    // ASSUMPTION: _weakVM is not nil
    [self collectPageViewModel:_weakVM];

}


- (void)tapGesCancel:(UIGestureRecognizer*)gesture {
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(shareViewDidCancel:)])
    {
        [_delegate shareViewDidCancel:self];
    }
}

#pragma mark - public methods
- (void)showInView:(UIView *)view animated:(BOOL)animated pageViewModel:(PIEPageVM *)pageVM
{
    self.weakVM = pageVM;
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
    self.weakVM = pageVM;
    [self toggleCollectIconStatus:self.weakVM.collected];
    
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



#pragma mark - helper methods
- (void)postShareType:(ATOMShareType)shareType
    selectedViewModel:(PIEPageVM *)selectedVM
{
    // ASSUMPTION: selectedVM is not nil
    [DDShareManager
     postSocialShare2:selectedVM
     withSocialShareType:shareType
     block:^(BOOL success) {
         
         if (success) {
             
             /* No more delegate methods */
//             if (_delegate != nil &&
//                 [_delegate respondsToSelector:@selector(shareViewDidShare:)])
//             {
//                 [_delegate shareViewDidShare:self];
//             }
             
             
             // 将对_selectedVM的副作用全部集中在shareView之中。
            selectedVM.shareCount =
             [NSString stringWithFormat:@"%zd",[selectedVM.shareCount integerValue]+1];
             
             // 这里是通知PIESharedIconStatusChangedNotification 唯一发布的地方
             [[NSNotificationCenter defaultCenter]
              postNotificationName:PIESharedIconStatusChangedNotification
              object:nil
              userInfo:@{PIESharedIconSharedCountKey: selectedVM.shareCount}];
             
         }
         else
         {
             /* evoke a network error prompt message to user. */
         }
         
     }];
}

- (void)collectPageViewModel:(PIEPageVM *)pageViewModel
{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (pageViewModel.collected) {
        //如果之前已经收藏，那么就取消收藏
        [param setObject:@(0) forKey:@"status"];
    } else {
        //反之，收藏
        [param setObject:@(1) forKey:@"status"];
    }
    
    [DDCollectManager
     toggleCollect:param
     withPageType:pageViewModel.type
     withID:pageViewModel.ID withBlock:^(NSError *error) {
         if (error == nil) {
             // 成功返回数据，代表切换收藏这个状态已经被服务器承认，这个时候再切换状态(只有这里一次会对pageViewModel产生副作用！)
             pageViewModel.collected = !pageViewModel.collected;
             NSInteger collectedCount = [pageViewModel.collectCount integerValue];
             
             if (pageViewModel.collected) {
                 [Hud textWithLightBackground:@"收藏成功"];
                 collectedCount += 1;

             } else {
                 [Hud textWithLightBackground:@"取消收藏成功"];
                 collectedCount -= 1;
             }
             pageViewModel.collectCount = [NSString stringWithFormat:@"%zd", collectedCount];


             // ============================================================================ //
             
             /* 
              收藏成功，需要刷新三个地方的UI元素：
                - 自己shareView的收藏Icon(星星：实心 < -- > 空心) 这个是toggleCollectionIconStatus搞定；
                - 触发shareView的controller自己页面的replyCell, askCell的收藏（仅在EliteHomeVC里面的Cell自带星星，其他的controller中的cell是没有收藏Icon了。使用代理回调）
                - (最蛋痛)EliteHomeVC -> Carousel_ItemView -> PIECommentVC, 假如是在PIECommentVC点开了
                    shareview点击了收藏，那么得通知到两级以上的EliteHomeVC中的Cell去更新星星的icon。可选方案：
                    KVO，Notification。(观察者模式)
              */
             
             // 刷新UI-1
             [self toggleCollectIconStatus:pageViewModel.collected];
             
             // 刷新UI-2
             if (_delegate != nil &&
                 [_delegate respondsToSelector:@selector(shareViewDidCollect:)]) {
                 
                 // 很遗憾，使用代理刷新UI，只能影响上一层的viewController。
                 [_delegate shareViewDidCollect:self];
             }
             
             // 刷新UI-3: 发通知(匿名): (PIECellIconStatusChangedNotification.h)
             [[NSNotificationCenter defaultCenter]
              postNotificationName:PIECollectedIconStatusChangedNotification
              object:nil
              userInfo:@{PIECollectedIconIsCollectedKey:@(pageViewModel.collected),
                         PIECollectedIconCollectedCountKey:pageViewModel.collectCount}];;
             
         }   else {
             // error occur on networking, do not toggle _weakVM.collected.
             [Hud textWithLightBackground:@"服务器不鸟你，你点收藏也没用～"];
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

@end
