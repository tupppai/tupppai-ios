//
//  PIEModifyPasswordViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/30/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEModifyPasswordViewController.h"
#import "DDInputPhoneFPVC.h"
@interface PIEModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation PIEModifyPasswordViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = btnDone;
}
- (void)createUI {
    self.title = @"修改密码";
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    label.text = @"原密码";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    label2.text = @"新密码";
    label2.textColor = [UIColor lightGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    
    UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    label3.text = @"确认密码";
    label3.textColor = [UIColor lightGrayColor];
    label3.font = [UIFont systemFontOfSize:15];
    
    self.oldPasswordTextField.leftView = label;
    self.modifyPasswordTextField.leftView = label2;
    self.confirmPasswordTextField.leftView = label3;

    self.oldPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.modifyPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;

    self.forgetPasswordButton.hidden = YES;
    [self.forgetPasswordButton addTarget:self action:@selector(clickForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    if ([self isNewPasswordAccepted]) {
        NSMutableDictionary* param = [NSMutableDictionary new];
        [param setObject:self.oldPasswordTextField.text forKey:@"old_pwd"];
        [param setObject:self.modifyPasswordTextField.text forKey:@"new_pwd"];
        [DDService updatePassword:param withBlock:^(BOOL success, NSInteger ret) {
            if (success) {
                if (ret == 1) {
                    [Util ShowTSMessageSuccess:@"修改密码成功"];
                } else if (ret == 2) {
                    [Util ShowTSMessageError:@"原密码错误"];
                    
                } else if (ret == 3) {
                    [Util ShowTSMessageError:@"原密码与新密码相同"];
                } else {
                    [Util ShowTSMessageError:@"修改密码失败"];
                }
            }
        }];
        
    }
}


- (void)clickForgetPasswordButton:(UIButton *)sender {
    DDInputPhoneFPVC* fpvc = [DDInputPhoneFPVC new];
    [self.navigationController pushViewController:fpvc animated:YES];
}
- (BOOL)isNewPasswordAccepted {
    if (![self.oldPasswordTextField.text isPassword]){
        [Util ShowTSMessageWarn:@"旧密码还没正确输入"];
        return NO;
    } else if (![self.modifyPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [Util ShowTSMessageWarn:@"两次输入的新密码不一致"];
        return NO;
    } else if (![self.modifyPasswordTextField.text isPassword] || ![self.confirmPasswordTextField.text isPassword]) {
        [Util ShowTSMessageWarn:@"新密码必须由6~16位的数字和字母组成"];
        return NO;
    } else  {
        return YES;
    }
}

@end
