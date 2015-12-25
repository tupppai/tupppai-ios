//
//  PIEModifySelfViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEModifyProfileViewController.h"
#import "PIEModifySelfView.h"
#import "DDPhoneRegisterVC.h"
#import "ATOMHeaderImageCropperViewController.h"
#import "PIEUploadManager.h"
#import "PIEModelImageInfo.h"
#import "JGActionSheet.h"
#import "AppDelegate.h"
#import "DDNavigationController.h"
#import "PIEMeViewController.h"

@interface PIEModifyProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate , ATOMCropHeaderImageCompleteProtocol>
@property (nonatomic, strong) PIEModifySelfView *createProfileView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapSexViewGesture;
//@property (nonatomic, strong) UITapGestureRecognizer *tapRegionViewGesture;
@property (nonatomic, assign) NSInteger selectedRowComponent1;
@property (nonatomic, assign) NSInteger selectedRowComponent2;
@property (nonatomic, strong) NSArray* provinces;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, assign) NSInteger avatarID;
@property (nonatomic, assign) BOOL sexIsMale;


@end

@implementation PIEModifyProfileViewController


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadRegionResource];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"确认修改" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButtonItem)];
    self.navigationItem.rightBarButtonItem = btnDone;
}
- (void)createUI {
    self.title = @"资料编辑";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    _createProfileView = [PIEModifySelfView new];
    self.view = _createProfileView;
    
    _createProfileView.nicknameTextField.delegate = self;
    [_createProfileView.userHeaderButton addTarget:self action:@selector(clickToManageAvatar) forControlEvents:UIControlEventTouchUpInside];
    _createProfileView.genderIsMan = [DDUserManager currentUser].sex;
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
    
    NSMutableDictionary* param = [NSMutableDictionary new];
    if (_avatar) {
        [param setObject:_avatar forKey:@"avatar"];
    }
    [param setObject:@(_createProfileView.genderIsMan) forKey:@"sex"];
    if (![[DDUserManager currentUser].nickname isEqualToString:_createProfileView.nicknameTextField.text]) {
        [param setObject:_createProfileView.nicknameTextField.text forKey:@"nickname"];
    }
    [DDService updateProfile:param withBlock:^(BOOL success) {
        if (success) {
            [Hud success:@"修改成功"];
            [DDUserManager currentUser].nickname = _createProfileView.nicknameTextField.text;
            [DDUserManager currentUser].sex = _createProfileView.genderIsMan;
            if (_avatar) {
                //use reactive cocoa to update all avatar view.
                [DDUserManager currentUser].avatar = _avatar;
                [[AppDelegate APP].mainTabBarController updateTabbarAvatar];
            }
            [DDUserManager updateCurrentUserInDatabase];
            
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            PIEMeViewController* mevc = [nav.viewControllers firstObject];
            [mevc updateAvatar];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [Hud error:@"修改失败" inView:self.view];
        }
    }];
}
- (void)clickLeftButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickToManageAvatar{
    [self.view endEditing:YES];
    [self.cameraActionsheet showInView:self.view animated:YES];
}



#pragma mark - Gesture Event



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMHeaderImageCropperViewController *hicvc = [ATOMHeaderImageCropperViewController new];
        DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:hicvc];
        hicvc.delegate = ws;
        hicvc.originImage = info[UIImagePickerControllerOriginalImage];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }];
}

#pragma ATOMCropHeaderImageCompleteProtocol

- (void)cropHeaderImageCompleteWith:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    [_createProfileView.userHeaderButton setImage:image forState:UIControlStateNormal];
    PIEUploadManager *uploadImage = [PIEUploadManager new];
    [uploadImage UploadImage:data WithBlock:^(PIEModelImageInfo *imageInfomation, NSError *error) {
        if (error) {
            return ;
        }
        _avatar = imageInfomation.imageURL;
        _avatarID = imageInfomation.imageID;
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


@end
