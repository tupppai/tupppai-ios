//
//  ATOMHomeImageDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMAskPage;

@interface ATOMHomeImageDAO : ATOMBaseDAO

- (void)insertHomeImage:(ATOMAskPage *)homeImage;
- (void)updateHomeImage:(ATOMAskPage *)homeImage;
- (ATOMAskPage *)selectHomeImageByImageID:(NSInteger)imageID;
- (NSArray *)selectHomeImages;
- (NSArray *)selectHomeImagesWithHomeType:(PIEHomeType)homeType;
- (BOOL)isExistHomeImage:(ATOMAskPage *)homeImage;
- (void)clearHomeImages;
- (void)clearHomeImagesWithHomeType:(NSString *)homeType;

@end
