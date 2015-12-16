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

- (void)shareViewDidShare:(PIEShareView *)shareView
          socialShareType:(ATOMShareType)shareType;


/* !!! 循环引用的隐忧？我主动把PIEPageVM的prperty设置为weak*/
- (void)shareViewDidPaste:(PIEShareView *)shareView;
- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView;
- (void)shareViewDidCollect:(PIEShareView *)shareView;


- (void)shareViewDidCancel:(PIEShareView *)shareView;

@end

@interface PIEShareView:UIView
@property (strong, nonatomic) PIESharesheetView *sheetView;
@property (strong, nonatomic) UIVisualEffectView *dimmingView;
@property (nonatomic, strong)  PIEActionSheet_Report * reportActionSheet;

@property (nonatomic, weak) id<PIEShareViewDelegate> delegate;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)show;

/* 替换版本 */
- (void)showInView:(UIView *)view animated:(BOOL)animated pageViewModel:(PIEPageVM *)pageVM;
- (void)show:(PIEPageVM *)pageVM;
-(void)dismiss;
@end
