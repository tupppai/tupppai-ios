//
//  PIEShareView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIESharesheetView.h"
#import "PIEActionSheet_Report.h"

@class PIEShareView;
@class PIEPageVM;

@protocol PIEShareViewDelegate <NSObject>


@required
- (void)shareViewDidShare:(PIEShareView *)shareView;
- (void)shareViewDidPaste:(PIEShareView *)shareView pageVM:(PIEPageVM *)pageVM;
- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView pageVM:(PIEPageVM *)pageVM;
- (void)shareViewDidCollect:(PIEShareView *)shareView pageVM:(PIEPageVM *)pageVM;
- (void)shareViewDidCancel:(PIEShareView *)shareView;

@end

@interface PIEShareView:UIView
@property (strong, nonatomic) PIESharesheetView *sheetView;
@property (strong, nonatomic) UIVisualEffectView *dimmingView;
@property (nonatomic, strong)  PIEActionSheet_Report * reportActionSheet;

@property (nonatomic, weak) id<PIEShareViewDelegate> delegate;
@property (nonatomic,strong) PIEPageVM* vm;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)show;
-(void)dismiss;
@end
