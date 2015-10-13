//
//  PIEShareView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEShareIcon.h"
@interface PIESharesheetView : UIView
@property (strong, nonatomic) PIEShareIcon *icon1;
@property (strong, nonatomic) PIEShareIcon *icon2;
@property (strong, nonatomic) PIEShareIcon *icon3;
@property (strong, nonatomic) PIEShareIcon *icon4;
@property (strong, nonatomic) PIEShareIcon *icon5;
@property (strong, nonatomic) PIEShareIcon *icon6;
@property (strong, nonatomic) PIEShareIcon *icon7;
@property (strong, nonatomic) PIEShareIcon *icon8;
@property (strong, nonatomic) UILabel *cancelLabel;

@property (strong, nonatomic) NSMutableArray *iconArray;
@property (strong, nonatomic) NSArray *infoArray;

@end
