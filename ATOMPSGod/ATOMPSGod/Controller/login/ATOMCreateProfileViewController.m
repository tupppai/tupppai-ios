//
//  ATOMCreateProfileViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCreateProfileViewController.h"
#import "ATOMCreateProfileView.h"
#import "ATOMMobileRegisterViewController.h"
#import "ATOMHeaderImageCropperViewController.h"
#import "ATOMUploadImage.h"
#import "ATOMImage.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMCreateProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ATOMCropHeaderImageCompleteProtocol>

@property (nonatomic, strong) ATOMCreateProfileView *createProfileView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation ATOMCreateProfileViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

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
    self.title = @"创建个人资料";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _createProfileView = [ATOMCreateProfileView new];
    self.view = _createProfileView;
    _createProfileView.nicknameTextField.delegate = self;
    [_createProfileView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.manButton addTarget:self action:@selector(clickManButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.womanButton addTarget:self action:@selector(clickWomanButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    NSString *str = _createProfileView.nicknameTextField.text;
    if (str.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空..."];
        return ;
    } else if (str.length >= 6) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能大于6位..."];
        return ;
    }
    [ATOMCurrentUser currentUser].sex = _createProfileView.manButton.selected;
    [ATOMCurrentUser currentUser].nickname = str;
    ATOMMobileRegisterViewController *mrvc = [[ATOMMobileRegisterViewController alloc] init];
    [self pushViewController:mrvc animated:YES];
}

- (void)clickUserHeaderButton:(UIButton *)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)clickManButton:(UIButton *)sender {
    sender.selected = YES;
    _createProfileView.womanButton.selected = NO;
}

- (void)clickWomanButton:(UIButton *)sender {
    sender.selected = YES;
    _createProfileView.manButton.selected = NO;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMHeaderImageCropperViewController *hicvc = [ATOMHeaderImageCropperViewController new];
        hicvc.delegate = ws;
        hicvc.originImage = info[UIImagePickerControllerOriginalImage];
        [self pushViewController:hicvc animated:NO];
    }];
}

#pragma ATOMCropHeaderImageCompleteProtocol

- (void)cropHeaderImageCompleteWith:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    [_createProfileView.userHeaderButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    ATOMUploadImage *uploadImage = [ATOMUploadImage new];
    [uploadImage UploadImage:data withBlock:^(ATOMImage *imageInformation, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        NSLog(@"%lld", imageInformation.imageID);
    }];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *str = textField.text;
    if (str.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空..."];
        return NO;
    } else if (str.length >= 6) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能大于6位..."];
        return NO;
    }
    [_createProfileView.nicknameTextField resignFirstResponder];
    return YES;
}



















@end
