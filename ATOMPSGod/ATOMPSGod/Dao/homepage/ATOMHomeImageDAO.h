//
//  ATOMHomeImageDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMHomeImage;

@interface ATOMHomeImageDAO : ATOMBaseDAO

- (void)insertHomeImage:(ATOMHomeImage *)homeImage;
- (void)updateHomeImage:(ATOMHomeImage *)homeImage;
- (ATOMHomeImage *)selectHomeImageByImageID:(NSInteger)imageID;
- (NSArray *)selectHomeImages;
- (NSArray *)selectHomeImagesWithHomeType:(ATOMHomepageViewType)homeType;
- (BOOL)isExistHomeImage:(ATOMHomeImage *)homeImage;
- (void)clearHomeImages;
- (void)clearHomeImagesWithHomeType:(NSString *)homeType;

@end
