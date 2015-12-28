//
//  PIEUploadModel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUploadModel.h"

@implementation PIEUploadModel

-(instancetype)init {
    self = [super init];
    if (self) {
        _imageArray = [NSMutableArray new];
        _uploadIdArray = [NSMutableArray new];
        _ratioArray = [NSMutableArray new];
    }
    return self;
}
@end
