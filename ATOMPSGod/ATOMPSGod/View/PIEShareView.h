//
//  PIEShareView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIESharesheetView.h"

@protocol PIEShareViewDelegate <NSObject>
@optional
- (void)tapShare1;
- (void)tapShare2;
- (void)tapShare3;
- (void)tapShare4;
- (void)tapShare5;
- (void)tapShare6;
- (void)tapShare7;
- (void)tapShare8;
- (void)tapShareCancel;
@end

@interface PIEShareView:UIView
@property (strong, nonatomic) PIESharesheetView *sheetView;
@property (strong, nonatomic) UIVisualEffectView *dimmingView;

@property (nonatomic, weak) id<PIEShareViewDelegate> delegate;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)show;
-(void)dismiss;
@end
