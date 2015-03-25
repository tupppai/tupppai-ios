//
//  ATOMUserFeedbackView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/25.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMUserFeedbackView : ATOMBaseView

@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, copy) NSAttributedString *feedbackTextViewPlaceholder;

@end
