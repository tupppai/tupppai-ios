//
//  PIEActionSheet_UserAbuse.m
//  TUPAI
//
//  Created by chenpeiwei on 12/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEActionSheet_UserAbuse.h"
#import "ATOMReportModel.h"
#import "AppDelegate.h"


@implementation PIEActionSheet_UserAbuse
-(instancetype)initWithUser:(PIEEntityUser* )user {
    WS(ws);
    _user = user;
    NSString* blockStr = _user.blocked ? @"解除屏蔽":@"屏蔽此用户";
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[blockStr, @"举报此用户"] buttonStyle:JGActionSheetButtonStyleDefault];
    NSArray *sections = @[section];
    self = [super initWithSections:sections];
    if (self) {
        self.delegate = self;
        [self setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [self setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws dismissAnimated:YES];
                    [ws block];
                    break;
                case 1:
                    [ws dismissAnimated:YES];
                    [ws report];
                    break;
                default:
                    [ws dismissAnimated:YES];
                    break;
            }
        }];
        
    }
    return  self;
}

-(void) block {
    NSString* title = @"屏蔽";
    
    NSString* msg = @"屏蔽此用户你将看不到ta发布的内容，确定要屏蔽吗?";
    if (_user.blocked) {
        msg = @"你将解除屏蔽此用户，确定解除屏蔽吗？";
        title = @"解除屏蔽";
    }
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:msg];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
        NSMutableDictionary* param = [NSMutableDictionary new];
          if (_user.blocked) {
              [param setObject:@(0) forKey:@"status"];
          }
        [param setObject:@(_uid) forKey:@"uid"];
            [DDBaseService POST:param url:@"user/block" block:^(id responseObject) {
                if (_user.blocked) {
                    [Hud text:@"已解除屏蔽"];
                } else {
                    [Hud text:@"已屏蔽"];
                }
                _user.blocked = !_user.blocked;
            }];
    }];
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    [alertView show];
}

-(void) report {
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗", @"发布广告骚扰",@"违反法律法规"] buttonStyle:JGActionSheetButtonStyleDefault];
    NSArray *sections = @[section];
    JGActionSheet *actionSheet = [[JGActionSheet alloc]initWithSections:sections];
        actionSheet.delegate = self;
        [actionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
    
        [actionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [sheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [sheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [sheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [sheet dismissAnimated:YES];
                    break;
            }
            [param setObject:@(_uid) forKey:@"target_id"];
            [param setObject:@(4) forKey:@"target_type"];

            [ATOMReportModel report:param withBlock:^(NSError *error) {
                    [Hud text:@"已举报"];
            }];
        }];
    
    [actionSheet showInView:[AppDelegate APP].window animated:YES];

}



@end
