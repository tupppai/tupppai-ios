//
//  PIEActionSheet_PS.m
//  TUPAI
//
//  Created by chenpeiwei on 11/30/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEActionSheet_PS.h"

#import "PIECategoryModel.h"
@implementation PIEActionSheet_PS

-(instancetype)init {
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片帮P", @"添加至进行中",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
    [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
    NSArray *sections = @[section];
    self = [super initWithSections:sections];
    
    if (self) {
            WS(ws);
                ws.delegate = self;
                [ws setOutsidePressBlock:^(JGActionSheet *sheet) {
                    [sheet dismissAnimated:YES];
                }];
                [ws setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
                    switch (indexPath.row) {
                        case 0:
                            [ws dismissAnimated:YES];
                            [ws help:YES];
                            break;
                        case 1:
                            [ws dismissAnimated:YES];
                            [ws help:NO];
                            break;
                        case 2:
                            [ws dismissAnimated:YES];
                            break;
                        default:
                            [ws dismissAnimated:YES];
                            break;
                    }
                }];
    }
    return self;
}


- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@(_vm.ID) forKey:@"target"];
    [param setObject:@"ask" forKey:@"type"];
    if (_vm.models_catogory.count >= 1) {
        PIECategoryModel* model = [_vm.models_catogory objectAtIndex:0];
        [param setObject:model.ID forKey:@"category_id"];
    }
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [Hud activity:@"下载图片中..."];
                [DDService sd_downloadImage:imageUrl withBlock:^(UIImage *image) {
                    [Hud dismiss];
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            else {
                [Hud customText:@"添加成功\n在“进行中”等你下载咯!" inView:[AppDelegate APP].window];
            }
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
    } else {
        [Hud customText:@"下载成功\n我猜你会用美图秀秀来P?" inView:[AppDelegate APP].window];
    }
}
@end
