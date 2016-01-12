//
//  PIETextInputbar.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeesinTextView.h"

typedef NS_ENUM(NSUInteger, LeesinTextInputBarButtonType) {
    LeesinTextInputBarButtonTypeMission,
    LeesinTextInputBarButtonTypePHAsset,
    LeesinTextInputBarButtonTypeNone,
};
typedef NS_ENUM(NSUInteger, LeesinTextInputBarType) {
    LeesinTextInputBarTypeAsk,
    LeesinTextInputBarTypeReply,
    LeesinTextInputBarTypeReplyNoMissionSelection,
};

@interface LeesinTextInputBar : UIView

@property (nonatomic, strong) LeesinTextView *textView;
@property (nonatomic, strong) UIButton *leftButton1;
@property (nonatomic, strong) UIButton *leftButton2;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) LeesinTextInputBarType type;

@property (nonatomic, assign) LeesinTextInputBarButtonType buttonType;

@property (nonatomic, assign) LeesinTextInputBarButtonType lastButtonType;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, readonly) CGFloat minimumInputbarHeight;
@property (nonatomic, readonly) CGFloat appropriateHeight;


- (instancetype)initWithTextViewClass:(Class)textViewClass;
- (void)pie_hideLeftButton1;
@end
