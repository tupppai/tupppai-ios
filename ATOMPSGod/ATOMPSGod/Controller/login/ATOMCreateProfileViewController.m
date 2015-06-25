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
@property (nonatomic, strong) UITapGestureRecognizer *tapRegionViewGesture;

@property (nonatomic, assign) NSInteger selectedRowComponent1;
@property (nonatomic, assign) NSInteger selectedRowComponent2;
@property (nonatomic, strong) NSArray* provinces;

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
- (UITapGestureRecognizer *)tapRegionViewGesture {
    if (!_tapRegionViewGesture) {
        _tapRegionViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegionViewGesture:)];
    }
    return _tapRegionViewGesture;
}
#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRegionResource];
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
    
    [_createProfileView.areaView addGestureRecognizer:self.tapRegionViewGesture];
    _createProfileView.regionPickerView.delegate = self;
    _createProfileView.regionPickerView.dataSource = self;
    
    _selectedRowComponent1 = 0;
    _selectedRowComponent2 = 0;
    
    [_createProfileView.cancelPickerButton addTarget:self action:@selector(clickCancelPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.confirmPickerButton addTarget:self action:@selector(clickConfirmPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.cancelRegionPickerButton addTarget:self action:@selector(clickCancelRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.confirmRegionPickerButton addTarget:self action:@selector(clickConfirmRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setupWithSourceData];
}

#pragma mark - Third party sign up
-(void)setupWithSourceData {
    if (_userProfileViewModel) {
        _createProfileView.showSexLabel.text = _userProfileViewModel.gender;
        [_createProfileView.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: _userProfileViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        _createProfileView.nicknameTextField.text = _userProfileViewModel.nickName;
        [ATOMCurrentUser currentUser].avatar = _userProfileViewModel.avatarURL;
        
        switch ([ATOMCurrentUser currentUser].signUpType) {
                //微信获取到的地区是名字，需要解析为ID
            case ATOMSignUpWeixin:
                _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",_userProfileViewModel.province,_userProfileViewModel.city];
                for (NSDictionary* province in _provinces) {
                    NSString* provinceName = (NSString* )province[@"name"];
                    if ([provinceName isEqualToString:_userProfileViewModel.province]) {
                        NSArray* cities = province[@"citys"];
                        NSString* provinceID = province[@"id"];
                        [[ATOMCurrentUser  currentUser].region setObject:provinceID forKey:@"provinceID"];
                        for (NSDictionary* city in cities) {
                            NSString* cityName = [city allValues][0];
                            if ([cityName isEqualToString:_userProfileViewModel.city]) {
                                NSString* cityID = [city allKeys][0];
                                [[ATOMCurrentUser  currentUser].region setObject:cityID forKey:@"cityID"];
                            }
                        }
                    
                    }
                }
                break;
                //获取到的是ID，需要解析为string展示出来
            case ATOMSignUpWeibo:
                for (NSDictionary* province in _provinces) {
                    NSString* provinceID = [NSString stringWithFormat:@"%@",province[@"id"]];
                    if ([provinceID isEqualToString: _userProfileViewModel.province]) {
                        NSArray* cities = province[@"citys"];
                        NSString* provinceName = province[@"name"];
                        [[ATOMCurrentUser  currentUser].region setObject:provinceID forKey:@"provinceID"];
                        for (NSDictionary* city in cities) {
                            NSString* cityID = [city allKeys][0];
                            if ([cityID isEqualToString:_userProfileViewModel.city]) {
                                NSString* cityName = [city allValues][0];
                                [[ATOMCurrentUser currentUser].region setObject:cityID forKey:@"cityID"];
                                _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
                            }
                        }
                        
                    }
                }
                break;
            default:
                break;
        }
    }

}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    NSString *str = _createProfileView.nicknameTextField.text;
    if (str.length < 4) {
        [Util TextHud:@"昵称不能低于4位"];
        return ;
    } else if (str.length > 8) {
        [Util TextHud:@"昵称不能大于8位"];
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
    if ( [_createProfileView.showSexLabel.text  isEqualToString: @""] || _createProfileView.showSexLabel.text == NULL) {
        _createProfileView.showSexLabel.text = @"男";
    }
}
- (void)clickCancelRegionPickerButton:(UIButton *)sender {
    [_createProfileView hideRegionPickerView];
    [self updateAreaLabel];
}

- (void)clickConfirmRegionPickerButton:(UIButton *)sender {
    [_createProfileView hideRegionPickerView];
    [self updateAreaLabel];
}

#pragma mark - Gesture Event

- (void)tapSexViewGesture:(UITapGestureRecognizer *)gesture {
    [_createProfileView showSexPickerView];
}
- (void)tapRegionViewGesture:(UITapGestureRecognizer *)gesture {
    [_createProfileView showRegionPickerView];
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
    if (pickerView == _createProfileView.sexPickerView) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _createProfileView.sexPickerView) {
        return 2;
    } else {
        if(component == 0)
            return [_provinces count];
        else
            return[ _provinces[_selectedRowComponent1][@"citys"] count];
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _createProfileView.sexPickerView) {
         if (row == 0) {
            return @"男";
        } else if (row == 1) {
            return @"女";
        }
        return nil;
    } else {
        if(component == 0)
        {
            return _provinces[row][@"name"];
        }
        else
        {
            NSArray* cities = _provinces[_selectedRowComponent1][@"citys"];
            return [cities[row] allValues][0];
        }
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (pickerView == _createProfileView.sexPickerView) {
        return 50;
    } else {
        return 25;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _createProfileView.sexPickerView) {
        if (row == 0) {
            _createProfileView.showSexLabel.text = @"男";
        } else if (row == 1) {
            _createProfileView.showSexLabel.text = @"女";
        }
    } else {
        if(component == 0) {
            _selectedRowComponent1 = row;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        else {
            _selectedRowComponent2 = row;
            [self updateAreaLabel];
        }
    }
}

//updateAreaLabel and update currentUser
-(void)updateAreaLabel {
    NSString* provinceName = _provinces[_selectedRowComponent1][@"name"];
    NSArray* cities = _provinces[_selectedRowComponent1][@"citys"];
    NSString* cityName = [cities[_selectedRowComponent2] allValues][0];
    _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
    [[ATOMCurrentUser currentUser].region setValue:cityName forKey:@"cityName"];
    [[ATOMCurrentUser currentUser].region setValue:provinceName forKey:@"provinceName"];
    [[ATOMCurrentUser currentUser].region setValue:[cities[_selectedRowComponent2] allKeys][0] forKey:@"cityID"];
    [[ATOMCurrentUser currentUser].region setValue:_provinces[_selectedRowComponent1][@"id"] forKey:@"provinceID"];
}
//load region.csv before doing anything
-(void)loadRegionResource {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region"ofType:@"csv"];
    NSData *data=[NSData dataWithContentsOfFile:path];
    if (data) {
        NSDictionary* jsonRegionObject=[NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:NULL];
        _provinces = jsonRegionObject[@"provinces"];
    }
    
}

@end
