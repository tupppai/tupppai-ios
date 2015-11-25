//
//  PIEProceedingShareView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEProceedingShareSheetView.h"


@protocol PIEProceedingShareViewDelegate <NSObject>
@optional
- (void)tapShare1;
- (void)tapShare2;
- (void)tapShare3;
- (void)tapShare4;
- (void)tapShare5;
- (void)tapShare6;
- (void)tapShare7;
- (void)tapShareCancel;
@end


@interface PIEProceedingShareView : UIView

@property (strong, nonatomic) PIEProceedingShareSheetView *sheetView;
@property (nonatomic, weak) id<PIEProceedingShareViewDelegate> delegate;
@property (nonatomic, assign) BOOL hideDeleteButton;
@property (strong, nonatomic) UIVisualEffectView *dimmingView;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)show;
-(void)dismiss;

@end
