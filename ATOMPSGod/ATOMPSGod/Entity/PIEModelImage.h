//
//  PIEImageEntity.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/21/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface PIEModelImage : ATOMBaseModel
//<MTLFMDBSerializing>
//@property (nonatomic, assign) NSInteger ID;
//@property (nonatomic, assign) NSInteger height;
//@property (nonatomic, assign) NSInteger width;
@property (nonatomic, copy) NSString *url;

@end
