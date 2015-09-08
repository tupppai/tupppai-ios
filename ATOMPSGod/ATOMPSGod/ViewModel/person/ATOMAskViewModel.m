//
//  ATOMAskViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAskViewModel.h"
#import "ATOMAskPage.h"

@implementation ATOMAskViewModel

- (void)setViewModelData:(ATOMAskPage *)homeImage {
    _imageURL = homeImage.imageURL;
    _totalPSNumber = [NSString stringWithFormat:@"%d", (int)homeImage.totalWorkNumber];
}

@end
