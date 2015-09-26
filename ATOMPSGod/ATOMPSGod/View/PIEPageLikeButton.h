//
//  PIEPageLikeButton.h
//  TUPAI
//
//  Created by chenpeiwei on 9/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEHighlightableLabel.h"

@interface PIEPageLikeButton : UIView
@property (nonatomic, strong) PIEHighlightableLabel *label;
@property (nonatomic, strong) UIImageView *imageView;
/**
selected toggle color and number
 */
@property (nonatomic, assign) BOOL selected;
/**
highlighted toggle color only!
 */
@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString* numberString;
@end
