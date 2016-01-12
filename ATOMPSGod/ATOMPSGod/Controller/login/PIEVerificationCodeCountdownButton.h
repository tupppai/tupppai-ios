//
//  PIEVerificationCodeCountdownButton.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/9/16.
//  Copyright © 2016 Shenzhen  Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

// Void -> Void
typedef void(^FetchVerificationCodeBlock)(void);

@interface PIEVerificationCodeCountdownButton : UIButton

@property (nonatomic, copy)
FetchVerificationCodeBlock fetchVerificationCodeBlock;


@end
