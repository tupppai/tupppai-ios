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

@optional

- (void)shareViewDidShare:(nonnull PIEShareView *)shareView;
- (void)shareViewDidCancel:(nonnull PIEShareView *)shareView;

/* 以下代理方法仅在EliteViewController中实现，因为只有那里的replyCell，askCell有一个星星需要刷新（UI刷新） */
- (void)shareViewDidCollect:(nonnull PIEShareView *)shareView;

- (void)shareView:(nonnull PIEShareView *)shareView didShareWithType:(ATOMShareType)type;

@end

@interface PIEShareView:UIView


@property (nonatomic, weak) id<PIEShareViewDelegate > delegate;


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
