//
//  ATOMPSView.h
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATOMPSViewDelegate <NSObject>

- (void)dealImageWithCommand:(NSString *)command;

@end

@interface ATOMPSView : UIView

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, weak) id<ATOMPSViewDelegate> delegate;

@end
