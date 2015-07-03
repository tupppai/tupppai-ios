//
//  ATOMShareView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMShareFunctionView : ATOMBaseView

@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UIButton *wxFriendCircleButton;
@property (nonatomic, strong) UIButton *sinaWeiboButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, weak) id<ATOMShareFunctionViewDelegate> delegate;
-(void)show;
-(void)dismiss;
@end
