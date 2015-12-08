//
//  PIEReportActionSheet.m
//  TUPAI
//
//  Created by chenpeiwei on 11/30/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEActionSheet_Report.h"
#import "ATOMReportModel.h"

@implementation PIEActionSheet_Report

-(instancetype)init {
    WS(ws);
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗内容", @"广告或垃圾信息",@"违反法律法规的内容"] buttonStyle:JGActionSheetButtonStyleDefault];
    NSArray *sections = @[section];
    self = [super initWithSections:sections];
    if (self) {
        self.delegate = self;
        [self setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [self setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(ws.vm.ID) forKey:@"target_id"];
            [param setObject:@(ws.vm.type) forKey:@"target_type"];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [ws dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [ws dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [ws dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [ws dismissAnimated:YES];
                    break;
            }
            [ATOMReportModel report:param withBlock:^(NSError *error) {
                if(!error) {
                    [Hud textWithLightBackground:@"已举报"];
                }
                
            }];
        }];

    }
    return  self;
}

@end
