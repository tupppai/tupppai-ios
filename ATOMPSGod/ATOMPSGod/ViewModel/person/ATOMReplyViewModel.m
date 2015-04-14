//
//  ATOMReplyViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMReplyViewModel.h"
#import "ATOMHomeImage.h"

@implementation ATOMReplyViewModel

- (void)setViewModelData:(ATOMHomeImage *)homeImage {
    _imageURL = homeImage.imageURL;
}

@end
