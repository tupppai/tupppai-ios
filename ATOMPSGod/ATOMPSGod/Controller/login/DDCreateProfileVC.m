//
//  ATOMCreateProfileViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCreateProfileVC.h"
#import "PIECreateProfileView.h"
#import "DDPhoneRegisterVC.h"
#import "ATOMHeaderImageCropperViewController.h"
#import "PIEUploadManager.h"
#import "PIEModelImageInfo.h"
#import "JGActionSheet.h"
#import "DDLoginNavigationController.h"
#import "PIEAgreementsViewController.h"

@interface DDCreateProfileVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ATOMCropHeaderImageCompleteProtocol>
@property (nonatomic, strong) PIECreateProfileView *createProfileView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapSexViewGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapRegionViewGesture;
@property (nonatomic, assign) NSInteger selectedRowComponent1;
@property (nonatomic, assign) NSInteger selectedRowComponent2;
@property (nonatomic, strong) NSArray* provinces;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;

@end

@implementation DDCreateProfileVC
#pragma mark - UI

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadRegionResource];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavBar];
}

- (void)setupNavBar {
//    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
//    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [buttonLeft setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
//    [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
//    self.navigationItem.leftBarButtonItem =  buttonItem;
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButtonItem)];
    self.navigationItem.rightBarButtonItem = btnDone;

}
//- (void)dismiss {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)createUI {
    _createProfileView = [PIECreateProfileView new];
    self.view = _createProfileView;
    _createProfileView.nicknameTextField.delegate = self;
    [_createProfileView.userHeaderButton addTarget:self action:@selector(clickToManageAvatar) forControlEvents:UIControlEventTouchUpInside];
    
    [_createProfileView.areaView addGestureRecognizer:self.tapRegionViewGesture];
    _createProfileView.regionPickerView.delegate = self;
    _createProfileView.regionPickerView.dataSource = self;
    
    _selectedRowComponent1 = 0;
    _selectedRowComponent2 = 0;
    
    //guangdong province
//    [_createProfileView.regionPickerView selectRow:18 inComponent:0 animated:YES];

    [_createProfileView.confirmPickerButton addTarget:self action:@selector(clickConfirmPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.cancelRegionPickerButton addTarget:self action:@selector(clickCancelRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_createProfileView.confirmRegionPickerButton addTarget:self action:@selector(clickConfirmRegionPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_createProfileView.protocolButton addTarget:self action:@selector(tapProtocol) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary* sdkUser = [[NSUserDefaults standardUserDefaults]valueForKey:@"SdkUser"];

    if ([sdkUser[@"gender"]integerValue] == 1) {
        [_createProfileView.sexSegment setSelectedSegmentIndex:1];
    }
    
    [self setupWithSourceData];

}

-(void )tapProtocol {
    PIEAgreementsViewController* vc = [PIEAgreementsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Third party sign up
-(void)setupWithSourceData {
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SignUpType"]integerValue] != ATOMSignUpMobile) {
        NSDictionary* sdkUser = [[NSUserDefaults standardUserDefaults]valueForKey:@"SdkUser"];
        NSString* avatarUrl = sdkUser[@"icon"];
        [DDUserManager currentUser].sex = [sdkUser[@"gender"]integerValue] == 0 ? YES:NO;
        NSString* name = sdkUser[@"nickname"];
        [DDUserManager currentUser].avatar = avatarUrl;
        [_createProfileView.userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: avatarUrl] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        _createProfileView.nicknameTextField.text = name;
    }
}

#pragma mark - Click Event

- (void)clickRightButtonItem {
    NSString *str = _createProfileView.nicknameTextField.text;
    if (str.length < 2) {
        [Hud text:@"昵称不能低于2位"];
        return ;
    } else if (str.length > 16) {
        [Hud text:@"昵称不能大于16位"];
        return ;
    }
    [DDUserManager currentUser].sex = _createProfileView.genderIsMan;
    [DDUserManager currentUser].nickname = str;
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
        DDLoginNavigationController* nav = [[DDLoginNavigationController alloc]initWithRootViewController:hicvc];
        hicvc.delegate = ws;
        hicvc.originImage = info[UIImagePickerControllerOriginalImage];
        [self presentViewController:nav animated:YES completion:nil];
    }];
}

#pragma ATOMCropHeaderImageCompleteProtocol

- (void)cropHeaderImageCompleteWith:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    [_createProfileView.userHeaderButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    PIEUploadManager *uploadImage = [PIEUploadManager new];
    [uploadImage UploadImage:data WithBlock:^(PIEModelImageInfo *imageInfomation, NSError *error) {
        if (error) {
            return ;
        }
        [DDUserManager currentUser].avatar = imageInfomation.imageURL;
    }];
}
#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *str = textField.text;
    if (str.length == 0) {
        [Util ShowTSMessageWarn:@"昵称不能为空"];
        return NO;
    } else if (str.length > 16) {
        [Util ShowTSMessageWarn:@"昵称不能大于16位"];

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
            return [[[_provinces objectAtIndex:_selectedRowComponent1]objectForKey:@"citys"] count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        if(component == 0)
        {
            
            return [[_provinces objectAtIndex:row]objectForKey:@"name"];
        }
        else
        {
            NSArray* cities = [[_provinces objectAtIndex:_selectedRowComponent1] objectForKey:@"citys"];
            return [[[cities objectAtIndex:row] allValues]objectAtIndex:0];
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
    NSString* provinceName = [[_provinces objectAtIndex:_selectedRowComponent1]objectForKey:@"name"];
    NSArray* cities = [[_provinces objectAtIndex:_selectedRowComponent1]objectForKey:@"citys"];
    NSString* cityName = @"";
    if(cities.count > _selectedRowComponent2) {
         cityName = [[cities[_selectedRowComponent2] allValues]objectAtIndex:0];
//        [[DDUserManager currentUser].region setValue:[[[cities objectAtIndex:_selectedRowComponent2] allKeys]objectAtIndex:0] forKey:@"cityID"];
    }
    _createProfileView.showAreaLabel.text = [NSString stringWithFormat:@"%@,%@",provinceName,cityName];
//    [[DDUserManager currentUser].region setValue:cityName forKey:@"cityName"];
//    [[DDUserManager currentUser].region setValue:provinceName forKey:@"provinceName"];
//    [[DDUserManager currentUser].region setValue:_provinces[_selectedRowComponent1][@"id"] forKey:@"provinceID"];
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

@end
