//
//  PIEChannelTutorialFinishUploadingHomeworkView.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEChannelTutorialFinishUploadingHomeworkView : UIView

@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@property (weak, nonatomic) IBOutlet UIButton *qqzoneButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatMomentButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (weak, nonatomic) IBOutlet UIButton *qqFriendButton;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;


+ (PIEChannelTutorialFinishUploadingHomeworkView *)finishUploadingHomeworkView;

@end
