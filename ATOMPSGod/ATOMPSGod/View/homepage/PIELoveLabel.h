//
//  PIELoveLabel.h
//  TUPAI
//
//  Created by chenpeiwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PIELoveButtonStatus) {
    PIELoveButtonStatusNormal = 0,
    PIELoveButtonStatusSelectedLow,
    PIELoveButtonStatusSelectedMedium,
    PIELoveButtonStatusSelectedHigh,
};

@interface PIELoveLabel : UILabel
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString* numberString;
@property (nonatomic, assign) PIELoveButtonStatus status;
- (void)switchStatus:(PIELoveButtonStatus)status;
@end
