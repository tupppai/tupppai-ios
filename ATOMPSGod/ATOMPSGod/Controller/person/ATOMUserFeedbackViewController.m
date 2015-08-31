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
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)createUI {
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    rightButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _userFeedbackView = [ATOMUserFeedbackView new];
    self.view = _userFeedbackView;
    _userFeedbackView.feedbackTextView.delegate = self;
    _userFeedbackView.contactTextField.delegate = self;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    if (_userFeedbackView.feedbackTextView.text.length <= 0) {
        [Hud text:@"请输入你的建议" inView:self.view];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:_userFeedbackView.feedbackTextView.text forKey:@"content"];
        [param setObject:_userFeedbackView.contactTextField.text forKey:@"contact"];
        
        [DDService postFeedBack:param withBlock:^(BOOL success) {
            if (!success) {
            } else {
                [Hud success:@"感谢你的反馈😊"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
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
