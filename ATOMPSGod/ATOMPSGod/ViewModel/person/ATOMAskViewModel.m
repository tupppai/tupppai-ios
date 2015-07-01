//
//  ATOMAskViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAskViewModel.h"
#import "ATOMHomeImage.h"

@implementation ATOMAskViewModel

- (void)setViewModelData:(ATOMHomeImage *)homeImage {
    _imageURL = homeImage.imageURL;
    NSLog(@"homeImage.totalWorkNumber %ld",(long)homeImage.totalWorkNumber);
    _totalPSNumber = [NSString stringWithFormat:@"%d", (int)homeImage.totalWorkNumber];
}

@end
