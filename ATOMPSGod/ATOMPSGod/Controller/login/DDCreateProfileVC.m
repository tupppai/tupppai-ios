//
//  ATOMCreateProfileViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCreateProfileVC.h"
#import "ATOMCreateProfileView.h"
#import "DDPhoneRegisterVC.h"
#import "ATOMHeaderImageCropperViewController.h"
#import "ATOMUploadImage.h"
#import "ATOMImage.h"
#import "JGActionSheet.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDCreateProfileVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ATOMCropHeaderImageCompleteProtocol>
@property (nonatomic, strong) ATOMCreateProfileView *createProfileView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapSexViewGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapRegionViewGesture;
@property (nonatomic, assign) NSInteger selectedRowComponent1;
@property (nonatomic, assign) NSInteger selectedRowComponent2;
@property (nonatomic, strong) NSArray* provinces;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;

@end

@implementation DDCreateProfileVC

#pragma mark - Lazy Initialize
- (JGActionSheet *)cameraActionsheet {
    WS(ws);
    if (!_cameraActionsheet) {
        _cameraActionsheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"拍照", @"从相册选择",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _cameraActionsheet = [JGActionSheet actionSheetWithSections:sections];
//        _cameraActionsheet.delegate = self;
        [_cameraActionsheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_cameraActionsheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    ws.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [ws presentViewController:ws.imagePickerController animated:YES completion:NULL];
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
                case 1:
                    ws.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [ws presentViewController:ws.imagePickerController animated:YES completion:NULL];
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
                case 2:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
                default:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _cameraActionsheet;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
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
}

- (void)createUI {
    _createProfileView = [ATOMCreateProfileView new];
    self.view = _createProfileView;
    _createProfileView.nicknameTextField.delegate = self;
    [_createProfileView.userHeaderButton addTarget:self action:@selector(clickToManageAvatar) forControlEvents:UIControlEventTouchUpInside];
    
    [_createProfileView.nextButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.backButton addTarget:self action:@selector(clickLeftButtonItem) forControlEvents:UIControlEventTouchUpInside];

    [_createProfileView.areaView addGestureRecognizer:self.tapRegionViewGesture];
    _createProfileView.regionPickerView.delegate = self;
    _createProfileView.regionPickerView.dataSource = self;
    
    _selectedRowComponent1 = 0;
    _selectedRowComponent2 = 0;
    [_createProfileView.confirmPickerButton addTarget:self action:@selector(clickConfirmPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.cancelRegionPickerButton addTarget:self action:@selector(clickCancelRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.confirmRegionPickerButton addTarget:self action:@selector(clickConfirmRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setupWithSourceData];
}

#pragma mark - Third party sign up
-(void)setupWithSourceData {
    if (_userProfileViewModel) {
//        _createProfileView.showSexLabel.text = _userProfileViewModel.gender;
        [_createProfileView.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: _userProfileViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        _createProfileView.nicknameTextField.text = _userProfileViewModel.nickName;
        [DDUserManager currentUser].avatar = _userProfileViewModel.avatarURL;
        
        switch ([DDUserManager currentUser].signUpType) {
                //微信获取到的地区是名字，需要解析为ID
            case ATOMSignUpWechat:
                _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",_userProfileViewModel.province,_userProfileViewModel.city];
                for (NSDictionary* province in _provinces) {
                    NSString* provinceName = (NSString* )province[@"name"];
                    if ([provinceName isEqualToString:_userProfileViewModel.province]) {
                        NSArray* cities = province[@"citys"];
                        NSString* provinceID = province[@"id"];
                        [[DDUserManager  currentUser].region setObject:provinceID forKey:@"provinceID"];
                        for (NSDictionary* city in cities) {
                            NSString* cityName = [city allValues][0];
                            if ([cityName isEqualToString:_userProfileViewModel.city]) {
                                NSString* cityID = [city allKeys][0];
                                [[DDUserManager  currentUser].region setObject:cityID forKey:@"cityID"];
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
                        [[DDUserManager  currentUser].region setObject:provinceID forKey:@"provinceID"];
                        for (NSDictionary* city in cities) {
                            NSString* cityID = [city allKeys][0];
                            if ([cityID isEqualToString:_userProfileViewModel.city]) {
                                NSString* cityName = [city allValues][0];
                                [[DDUserManager currentUser].region setObject:cityID forKey:@"cityID"];
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

- (void)clickRightButtonItem {
    NSString *str = _createProfileView.nicknameTextField.text;
    if (str.length < 2) {
        [Hud text:@"昵称不能低于2位"];
        return ;
    } else if (str.length > 8) {
        [Hud text:@"昵称不能大于8位"];
        return ;
    }
    [DDUserManager currentUser].sex = _createProfileView.genderIsMan;
    [DDUserManager currentUser].username = str;
    DDPhoneRegisterVC *mrvc = [[DDPhoneRegisterVC alloc] init];
    [self.navigationController pushViewController:mrvc animated:YES];
}
- (void)clickLeftButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickToManageAvatar{
    [self.view endEditing:YES];
    [self.cameraActionsheet showInView:self.view animated:YES];
}


- (void)clickConfirmPickerButton:(UIButton *)sender {
//    [_createProfileView hideSexPickerView];
//    if ( [_createProfileView.showSexLabel.text  isEqualToString: @""] || _createProfileView.showSexLabel.text == NULL) {
//        _createProfileView.showSexLabel.text = @"男";
//    }
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


- (void)tapRegionViewGesture:(UITapGestureRecognizer *)gesture {
    [_createProfileView.nicknameTextField resignFirstResponder];
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
        [self.navigationController presentViewController:hicvc animated:NO completion:nil];
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
        [DDUserManager currentUser].avatar = imageInfomation.imageURL;
        [DDUserManager currentUser].avatarID = imageInfomation.imageID;
    }];
}
#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *str = textField.text;
    if (str.length == 0) {
        [Util ShowTSMessageWarn:@"昵称不能为空"];
        return NO;
    } else if (str.length > 8) {
        [Util ShowTSMessageWarn:@"昵称不能大于8位"];

        return NO;
    }
    [_createProfileView.nicknameTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

        if(component == 0)
            return [_provinces count];
        else
            return[ _provinces[_selectedRowComponent1][@"citys"] count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
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
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
        return 25;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

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

//updateAreaLabel and update currentUser
-(void)updateAreaLabel {
    NSString* provinceName = _provinces[_selectedRowComponent1][@"name"];
    NSArray* cities = _provinces[_selectedRowComponent1][@"citys"];
    NSString* cityName = @"";
    if(cities.count > 0) {
         cityName = [cities[_selectedRowComponent2] allValues][0];
        [[DDUserManager currentUser].region setValue:[cities[_selectedRowComponent2] allKeys][0] forKey:@"cityID"];
    }
    _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
    [[DDUserManager currentUser].region setValue:cityName forKey:@"cityName"];
    [[DDUserManager currentUser].region setValue:provinceName forKey:@"provinceName"];
    [[DDUserManager currentUser].region setValue:_provinces[_selectedRowComponent1][@"id"] forKey:@"provinceID"];
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
