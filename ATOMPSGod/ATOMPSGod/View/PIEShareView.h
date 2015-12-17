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

- (void)shareViewDidShare:(nonnull PIEShareView *)shareView;
- (void)shareViewDidCancel:(nonnull PIEShareView *)shareView;

@end

@interface PIEShareView:UIView
@property (nonnull, strong, nonatomic) PIESharesheetView *sheetView;
@property (nonnull, strong, nonatomic) UIVisualEffectView *dimmingView;
@property (nonnull, nonatomic, strong)  PIEActionSheet_Report * reportActionSheet;

@property (nonatomic, weak) id<PIEShareViewDelegate> delegate;

//- (void)showInView:(UIView *)view animated:(BOOL)animated;
//- (void)show;

/* 替换版本 */
- (void)showInView:(nonnull UIView *)view
          animated:(BOOL)animated
     pageViewModel:(nonnull PIEPageVM *)pageVM;

- (void)show:(nonnull PIEPageVM *)pageVM;
-(void)dismiss;
@end
