//
//  ATOMTipButton.h
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATOMTipButtonTypeLeft = 0,
    ATOMTipButtonTypeRight
} ATOMTipButtonType;

@interface ATOMTipButton : UIButton

@property (nonatomic, assign) ATOMTipButtonType type;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, assign) CGPoint position;

- (void)constrainTipLabelToImageView;
- (void)changeTipLabelDirection;


@end
