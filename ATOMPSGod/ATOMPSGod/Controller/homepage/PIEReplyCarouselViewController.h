//
//  PIEDetailPageVC.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
#import "iCarousel.h"

@interface PIEReplyCarouselViewController : DDBaseVC<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) DDPageVM *pageVM;
@end
