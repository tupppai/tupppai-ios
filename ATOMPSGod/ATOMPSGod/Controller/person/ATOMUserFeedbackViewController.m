//
//  ATOMUserFeedbackViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/25.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUserFeedbackViewController.h"
#import "ATOMUserFeedbackView.h"

@interface ATOMUserFeedbackViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ATOMUserFeedbackView *userFeedbackView;

@end

@implementation ATOMUserFeedbackViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)createUI {
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _userFeedbackView = [ATOMUserFeedbackView new];
    self.view = _userFeedbackView;
    _userFeedbackView.feedbackTextView.delegate = self;
    _userFeedbackView.contactTextField.delegate = self;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:[_userFeedbackView.feedbackTextViewPlaceholder string]]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.attributedText = _userFeedbackView.feedbackTextViewPlaceholder;
    }
    [textView resignFirstResponder];
}









@end
