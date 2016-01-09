//
//  PIETextToolBar.h
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/5/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LeeSinBottomBarType) {
    LeeSinBottomBarTypeReplyMission,
    LeeSinBottomBarTypeReplyPHAsset,
    LeeSinBottomBarTypeAsk,
    LeeSinBottomBarTypeReplyNoMissionSelection,
};

typedef NS_ENUM(NSUInteger, LeesinBottomBarRightButtonType) {
    LeesinBottomBarRightButtonTypeConfirmEnable,
    LeesinBottomBarRightButtonTypeConfirmDisable,
    LeesinBottomBarRightButtonTypeCancelEnable,
};
@interface LeesinBottomBar : UIView
@property (nonatomic, strong) UIButton *button_album;
@property (nonatomic, strong) UIButton *button_shoot;
@property (nonatomic, strong) UIButton *button_confirm;
@property (nonatomic, strong) UILabel  *label_confirmedCount;
@property (nonatomic, assign) LeeSinBottomBarType type;
@property (nonatomic, assign) LeesinBottomBarRightButtonType rightButtonType;

@end
