//
//  ATOMReplierDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMReplier;

@interface ATOMReplierDAO : ATOMBaseDAO

- (void)insertReplier:(ATOMReplier *)replier;
- (void)updateReplier:(ATOMReplier *)replier;
- (ATOMReplier *)selectReplierByreplierID:(NSInteger)replierID;
- (NSMutableArray *)selectReplierByImageID:(NSInteger)imageID;
- (BOOL)isExistReplier:(ATOMReplier *)replier;
- (void)clearReplier;

@end
