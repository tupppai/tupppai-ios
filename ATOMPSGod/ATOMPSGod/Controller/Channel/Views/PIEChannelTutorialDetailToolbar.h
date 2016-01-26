//
//  PIEChannelTutorialDetailToolbar.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEChannelTutorialDetailToolbar : UIView

+ (PIEChannelTutorialDetailToolbar *)toolbar;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rollDiceButton;

@end
