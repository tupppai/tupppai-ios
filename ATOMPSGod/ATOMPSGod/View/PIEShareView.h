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


@property (nonatomic, weak           ) id<PIEShareViewDelegate > delegate;


/**
 *  show shareView on a certain PIEPageVM(a view Model)
 */
- (void)showInView:(nonnull UIView *)view
          animated:(BOOL)animated
     pageViewModel:(nonnull PIEPageVM *)pageVM;


/**
 *  show shareView on a certain PIEPageVM(a viewModel)
 *
 *  @param pageVM <#pageVM description#>
 */
- (void)show:(nonnull PIEPageVM *)pageVM;

/**
 *  dismiss shareView
 */
- (void)dismiss;
@end
