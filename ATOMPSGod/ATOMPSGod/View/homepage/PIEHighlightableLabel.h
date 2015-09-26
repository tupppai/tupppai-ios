//
//  PIECountLabel.h
//  TUPAI
//
//  Created by chenpeiwei on 9/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEHighlightableLabel : UILabel
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString* numberString;
@property (nonatomic, assign) BOOL selected;

@end
