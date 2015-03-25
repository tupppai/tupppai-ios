//
//  ATOMAddTipLabelToImageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAddTipLabelToImageViewController.h"
#import "ATOMAddTipLabelToImageView.h"
#import "ATOMTipButton.h"
#import "ATOMFillInContentOfTipLabelView.h"
#import "ATOMInviteViewController.h"
#import "ATOMShareViewController.h"
#import "ATOMSubmitImageWithLabel.h"
#import "ATOMUploadImage.h"
#import "ATOMImage.h"
#import "ATOMImageTipLabel.h"
#import "AppDelegate.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMAddTipLabelToImageViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ATOMAddTipLabelToImageView *addTipLabelToImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapAddTipLabelToImageViewGesture;
@property (nonatomic, strong) ATOMFillInContentOfTipLabelView *fillInContentOfTipLabelView;
@property (nonatomic, strong) NSArray *originLeftBarButtonItems;
@property (nonatomic, strong) UIBarButtonItem *originRightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelLeftBarButtonItem;
@property (nonatomic, strong) NSMutableArray *tipLabelArray;
@property (nonatomic, strong) NSString *currentTipLabelText;
@property (nonatomic, assign) CGPoint currentLocation;
@property (nonatomic, strong) ATOMTipButton *lastAddButton;

@end

@implementation ATOMAddTipLabelToImageViewController

#pragma mark - Lazy Initialize

- (UITapGestureRecognizer *)tapAddTipLabelToImageViewGesture {
    if (_tapAddTipLabelToImageViewGesture == nil) {
        _tapAddTipLabelToImageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddTipLabelToImageViewGesture:)];
    }
    return _tapAddTipLabelToImageViewGesture;
}

- (NSMutableArray *)tipLabelArray {
    if (_tipLabelArray == nil) {
        _tipLabelArray = [NSMutableArray array];
    }
    return _tipLabelArray;
}

- (UIBarButtonItem *)cancelLeftBarButtonItem {
    if (_cancelLeftBarButtonItem == nil) {
        _cancelLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelLeftBarButtonItem:)];
    }
    return _cancelLeftBarButtonItem;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addClickEventToShareButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    } else {
        return YES;
    }
}

- (void)createUI {
    self.title = @"添加标签";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _originLeftBarButtonItems = self.navigationItem.leftBarButtonItems;
    _originRightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    
    _addTipLabelToImageView = [ATOMAddTipLabelToImageView new];
    self.view = _addTipLabelToImageView;
    
    _fillInContentOfTipLabelView = [ATOMFillInContentOfTipLabelView new];
    _fillInContentOfTipLabelView.tipLabelContentTextField.delegate = self;
    [_fillInContentOfTipLabelView.tipLabelContentTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_fillInContentOfTipLabelView.sendTipLabelTextButton addTarget:self action:@selector(clickSendTipLabelTextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _addTipLabelToImageView.workImage = _workImage;
    [_addTipLabelToImageView addGestureRecognizer:self.tapAddTipLabelToImageViewGesture];
    [_addTipLabelToImageView.changeTipLabelDirectionButton addTarget:self action:@selector(clickChangeTipLabelDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTipLabelToImageView.deleteTipLabelButton addTarget:self action:@selector(clickDeleteTipLabelButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addClickEventToShareButton {
    [_addTipLabelToImageView.xlButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTipLabelToImageView.wxButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTipLabelToImageView.qqButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTipLabelToImageView.qqzoneButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickShareButton:(UIButton *)button {
    [_addTipLabelToImageView changeStatusOfShareButton:button];
}

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    NSString *pushTypeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadingOrSeekingHelp"];
    if ([pushTypeStr isEqualToString:@"Uploading"]) {
        [self dealSubmitWorkWithLabel];
        ATOMShareViewController *svc = [ATOMShareViewController new];
        [self pushViewController:svc animated:YES];
    } else if ([pushTypeStr isEqualToString:@"SeekingHelp"]) {
        [self dealSubmitUploadWithLabel];
    }
}

- (void)clickCancelLeftBarButtonItem:(UIBarButtonItem *)sender {
    [self changeViewToOrigin];
}

- (void)clickTipLabel:(UIButton *)sender {
//    NSLog(@"click %d", (int)sender.tag);
    _lastAddButton = (ATOMTipButton *)sender;
    if (![_addTipLabelToImageView isOperationButtonShow]) {
        [_addTipLabelToImageView showOperationButton];
    }
}

- (void)changeViewToOrigin {
//    self.view = _addTipLabelToImageView;
    [_addTipLabelToImageView removeTemporaryPoint];
    [_fillInContentOfTipLabelView removeFromSuperview];
    self.navigationItem.leftBarButtonItems = _originLeftBarButtonItems;
    self.navigationItem.rightBarButtonItem = _originRightBarButtonItem;
    _fillInContentOfTipLabelView.tipLabelContentTextField.text = @"";
    [_fillInContentOfTipLabelView.topWarnLabel removeFromSuperview];
}

- (void)clickChangeTipLabelDirectionButton:(UIButton *)sender {
    [_lastAddButton changeTipLabelDirection];
}

- (void)clickDeleteTipLabelButton:(UIButton *)sender {
    [_addTipLabelToImageView hideOperationButton];
    [_lastAddButton removeFromSuperview];
    [_tipLabelArray removeObject:_lastAddButton];
    _lastAddButton = nil;
}

- (void)dealSubmitWorkWithLabel {
    
}

- (void)dealSubmitUploadWithLabel {
    WS(ws);
    CGFloat scale = SCREEN_WIDTH / CGWidth(_addTipLabelToImageView.workImageView.frame);
    CGFloat ratio = CGHeight(_addTipLabelToImageView.workImageView.frame) / CGWidth(_addTipLabelToImageView.workImageView.frame);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(SCREEN_WIDTH), @"width", @(scale), @"scale", @(ratio), @"ratio", nil];
    NSData *data = UIImageJPEGRepresentation(_workImage, 0.2);
    ATOMUploadImage *uploadImage = [ATOMUploadImage new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [uploadImage UploadImage:data withParam:param andBlock:^(ATOMImage *imageInformation, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"提交作品失败..."];
            return ;
        }
        [ws dealSubmitUploadWithLabelBy:imageInformation.imageID];
    }];
}

- (void)dealSubmitUploadWithLabelBy:(long long)imageID {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *paramLabelArray = [NSMutableArray array];
    for (ATOMTipButton *tipButton in ws.tipLabelArray) {
        //标签左上角相对图片的百分比
        CGFloat x = CGOriginX(tipButton.frame) / CGWidth(ws.addTipLabelToImageView.workImageView.frame);
        CGFloat y = CGOriginY(tipButton.frame) / CGHeight(ws.addTipLabelToImageView.workImageView.frame);
        NSInteger labelDirection;
        if (tipButton.tipButtonType ==ATOMLeftTipType) {
            labelDirection = 0;
        } else {
            labelDirection = 1;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(x), @"x", @(y), @"y", tipButton.buttonText, @"content", @(labelDirection), @"direction", @(tipButton.tag), @"vid", nil];
        [paramLabelArray addObject:dict];
    }
    [param setObject:@(imageID) forKey:@"upload_id"];
    [param setObject:[paramLabelArray JSONString] forKey:@"labels"];
    ATOMSubmitImageWithLabel *submitImageWithLabel = [ATOMSubmitImageWithLabel new];
    [submitImageWithLabel SubmitImageWithLabel:param withBlock:^(NSMutableArray *labelArray, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"提交作品失败..."];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"提交作品成功..."];
        if (labelArray.count) {
            for (ATOMImageTipLabel *tipLabel in labelArray) {
                [submitImageWithLabel saveTipLabelInDB:tipLabel];
            }
        }
        ATOMInviteViewController *ivc = [ATOMInviteViewController new];
        [self pushViewController:ivc animated:YES];
    }];
}

- (void)clickSendTipLabelTextButton:(UIButton *)sender {
    _currentTipLabelText = _fillInContentOfTipLabelView.tipLabelContentTextField.text;
    if (_currentTipLabelText.length) {
        [_fillInContentOfTipLabelView.tipLabelContentTextField resignFirstResponder];
        [self changeViewToOrigin];
        [self addTipLabelAtLocation];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 18) {
        textField.text = [textField.text substringToIndex:18];
    } else {
        _fillInContentOfTipLabelView.showNumberLabel.text = [NSString stringWithFormat:@"%d/18", (int)textField.text.length];
    }
}

#pragma mark - Gesture Event

- (void)tapAddTipLabelToImageViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_addTipLabelToImageView];
    if ([_addTipLabelToImageView isOperationButtonShow]) {
        if (location.y <= CGHeight(_addTipLabelToImageView.frame) - 76) {
            [_addTipLabelToImageView hideOperationButton];
        }
    } else {
        if (_tipLabelArray.count < 3) {
            if (CGRectContainsPoint(_addTipLabelToImageView.workImageView.frame, location)) {
                _currentLocation = [gesture locationInView:_addTipLabelToImageView.workImageView];
                [self changeViewToFillInTipLabel];
            }
        }
    }
}

- (void)changeViewToFillInTipLabel {
//    self.view = _fillInContentOfTipLabelView;
    [_addTipLabelToImageView addTemporaryPointAt:_currentLocation];
    [_addTipLabelToImageView addSubview:_fillInContentOfTipLabelView];
    [_fillInContentOfTipLabelView.tipLabelContentTextField becomeFirstResponder];
    self.navigationItem.leftBarButtonItems = @[self.cancelLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem = nil;
    [[AppDelegate APP].window addSubview:_fillInContentOfTipLabelView.topWarnLabel];
}

- (void)panTipLabelGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint location = [gesture translationInView:_addTipLabelToImageView.workImageView];
    CGFloat x = gesture.view.center.x + location.x;
    CGFloat y = gesture.view.center.y + location.y;
    gesture.view.center = CGPointMake(x, y);
    [((ATOMTipButton *)gesture.view) constrainTipLabelToImageView];
    [gesture setTranslation:CGPointMake(0, 0) inView:_addTipLabelToImageView.workImageView];
}

- (void)addTipLabelAtLocation {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, nil];
    CGSize actualSize = [_currentTipLabelText boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    ATOMTipButton *button;
    if (_currentLocation.x <= CGWidth(_addTipLabelToImageView.workImageView.frame) / 2) {
        button = [[ATOMTipButton alloc] initWithFrame:CGRectMake(_currentLocation.x, _currentLocation.y - 15, actualSize.width + 40, 30)];
        button.tipButtonType = ATOMLeftTipType;
    } else {
        button = [[ATOMTipButton alloc] initWithFrame:CGRectMake(_currentLocation.x - actualSize.width - 40, _currentLocation.y - 15, actualSize.width + 40, 30)];
        button.tipButtonType = ATOMRightTipType;
    }
    button.buttonText = _currentTipLabelText;
    button.tag = self.tipLabelArray.count;
    [self.tipLabelArray addObject:button];
    UIPanGestureRecognizer *panTipLabelGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTipLabelGesture:)];
    [button addGestureRecognizer:panTipLabelGesture];
    [button addTarget:self action:@selector(clickTipLabel:) forControlEvents:UIControlEventTouchUpInside];
    [_addTipLabelToImageView.workImageView addSubview:button];

}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    _currentTipLabelText = textField.text;
    if (_currentTipLabelText.length) {
        [textField resignFirstResponder];
        [self changeViewToOrigin];
        [self addTipLabelAtLocation];
        return YES;
    }
    return NO;
}






@end
