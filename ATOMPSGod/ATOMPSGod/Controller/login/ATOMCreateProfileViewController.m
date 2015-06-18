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

@interface ATOMCreateProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ATOMCropHeaderImageCompleteProtocol>

@property (nonatomic, strong) ATOMCreateProfileView *createProfileView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapSexViewGesture;

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

- (UITapGestureRecognizer *)tapSexViewGesture {
    if (!_tapSexViewGesture) {
        _tapSexViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSexViewGesture:)];
    }
    return _tapSexViewGesture;
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
    rightButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _createProfileView = [ATOMCreateProfileView new];
    self.view = _createProfileView;
    _createProfileView.nicknameTextField.delegate = self;
    [_createProfileView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.sexView addGestureRecognizer:self.tapSexViewGesture];
    _createProfileView.sexPickerView.delegate = self;
    _createProfileView.sexPickerView.dataSource = self;
    [_createProfileView.cancelPickerButton addTarget:self action:@selector(clickCancelPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.confirmPickerButton addTarget:self action:@selector(clickConfirmPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_userProfileViewModel) {
        _createProfileView.showSexLabel.text = _userProfileViewModel.gender;
        [_createProfileView.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: _userProfileViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        _createProfileView.nicknameTextField.text = _userProfileViewModel.nickName;
        _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",_userProfileViewModel.city,_userProfileViewModel.province];
        [ATOMCurrentUser currentUser].avatar = _userProfileViewModel.avatarURL;
    }
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    NSString *str = _createProfileView.nicknameTextField.text;
    if (str.length == 0) {
        [Util TextHud:@"昵称不能为空"];
        return ;
    } else if (str.length > 6) {
        [Util TextHud:@"昵称不能大于6位"];
        return ;
    } else if ([_createProfileView tagOfCurrentSex] == -1) {
        [Util TextHud:@"请选择性别"];
        return ;
    }
    [ATOMCurrentUser currentUser].sex = [_createProfileView tagOfCurrentSex];
    [ATOMCurrentUser currentUser].nickname = str;
    ATOMMobileRegisterViewController *mrvc = [[ATOMMobileRegisterViewController alloc] init];
    [self pushViewController:mrvc animated:YES];
}

- (void)clickUserHeaderButton:(UIButton *)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)clickCancelPickerButton:(UIButton *)sender {
    [_createProfileView hideSexPickerView];
}

- (void)clickConfirmPickerButton:(UIButton *)sender {
    [_createProfileView hideSexPickerView];
}

#pragma mark - Gesture Event

- (void)tapSexViewGesture:(UITapGestureRecognizer *)gesture {
    [_createProfileView showSexPickerView];
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
    [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInfomation, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        [ATOMCurrentUser currentUser].avatar = imageInfomation.imageURL;
        [ATOMCurrentUser currentUser].avatarID = imageInfomation.imageID;
    }];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *str = textField.text;
    if (str.length == 0) {
        [Util TextHud:@"昵称不能为空..."];
        return NO;
    } else if (str.length >= 6) {
        [Util TextHud:@"昵称不能大于6位..."];
        return NO;
    }
    [_createProfileView.nicknameTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"请选择";
    } else if (row == 1) {
        return @"男";
    } else if (row == 2) {
        return @"女";
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        _createProfileView.showSexLabel.text = @"";
    } else if (row == 1) {
        _createProfileView.showSexLabel.text = @"男";
    } else if (row == 2) {
        _createProfileView.showSexLabel.text = @"女";
    }
}














@end
