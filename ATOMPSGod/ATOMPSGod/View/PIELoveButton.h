//
//  PIELoveButton.h
//  TUPAI
//
//  Created by chenpeiwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEHighlightableLabel.h"
#import "PIELoveLabel.h"

@interface PIELoveButton : UIView
@property (nonatomic, strong) PIELoveLabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString* numberString;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) PIELoveButtonStatus status;
- (void)initStatus :(PIELoveButtonStatus)status numberString:(NSString*)numberString ;
- (void)commitStatus ;
- (void)revertStatus;
@end
