//
//  PIEChannelViewModel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelViewModel.h"
#import "PIECategoryModel.h"
@implementation PIEChannelViewModel
- (NSString *)description
{
    return [NSString stringWithFormat:
            @"\n ID = %ld \n imageUrl = %@ \n iconUrl = %@ \n title = %@ \n content = %@ \n threads = %@ \n\n", (long)_ID, _imageUrl, _iconUrl, _title, _content, _threads];
}


-(instancetype)initWithModel:(PIECategoryModel*)model {
    self = [super init];
    if (self) {
        _ID = [model.ID integerValue];
        _askID = [model.askID integerValue];
    }

    return self;

}
@end
