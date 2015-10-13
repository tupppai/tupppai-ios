//
//  PIECarousel2ViewController.h
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEBasePresentedViewController.h"
#import "iCarousel.h"

@interface PIECarousel2ViewController : PIEBasePresentedViewController<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) DDPageVM *pageVM;
@end
