//
//  ATOMCameraView.h
//  ATOMPSGod
//
//  Created by atom on 15/5/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATOMCameraViewDelegate <NSObject>

- (void)dealWithCommand:(NSString *)command;

@end

@interface ATOMCameraView : UIView

@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, weak) id<ATOMCameraViewDelegate> delegate;

@end
