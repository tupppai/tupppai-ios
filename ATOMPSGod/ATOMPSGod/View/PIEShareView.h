//
//  PIEShareView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIESharesheetView.h"
#import "FXBlurView.h"
@interface PIEShareView : FXBlurView
@property (strong, nonatomic) PIESharesheetView *shareSheetView;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)show;
-(void)dismiss;
@end
