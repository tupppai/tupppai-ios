//
//  PIEPageDetailTextInputBar.h
//  TUPAI
//
//  Created by chenpeiwei on 2/22/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeesinTextView;
@class PIEPageDetailTextInputBar;


@protocol PIEPageDetailTextInputBarDelegate <NSObject>
@optional
- (void)pageDetailTextInputBar:(PIEPageDetailTextInputBar *)pageDetailTextInputBar tapRightButton:(UIButton*)tappedButton;
@end

@interface PIEPageDetailTextInputBar : UIView

@property (nonatomic, weak) id<PIEPageDetailTextInputBarDelegate> delegate;
@property (nonatomic, strong) LeesinTextView *textView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, readonly) CGFloat minimumInputbarHeight;
@property (nonatomic, readonly) CGFloat appropriateHeight;

- (instancetype)initWithTextViewClass:(Class)textViewClass;

@end
