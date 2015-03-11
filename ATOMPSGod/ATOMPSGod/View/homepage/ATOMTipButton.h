//
//  ATOMTipButton.h
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATOMLeftTipType = 0,
    ATOMRightTipType
} ATOMTipButtonType;

@interface ATOMTipButton : UIButton

@property (nonatomic, assign) ATOMTipButtonType tipButtonType;
@property (nonatomic, strong) NSString *buttonText;

- (void)constrainTipLabelToImageView;
- (void)changeTipLabelDirection;


@end
