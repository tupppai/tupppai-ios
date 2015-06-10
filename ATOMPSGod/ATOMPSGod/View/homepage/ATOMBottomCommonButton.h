//
//  ATOMBottomCommonButton.h
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ATOMBottomCommonButtonDelegate <NSObject>
-(void) tapLikeButton:(UIView*)buttonView;
-(void) untapLikeButton:(UIView*)buttonView;
@end

@interface ATOMBottomCommonButton : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<ATOMBottomCommonButtonDelegate> delegate;
-(void)toggleLike;
-(void)toggleSeleted;
-(void)toggleNumber;
-(void)toggleColor;
-(void)toggleLikeWhenSelectedChanged:(BOOL)selected;
@end
