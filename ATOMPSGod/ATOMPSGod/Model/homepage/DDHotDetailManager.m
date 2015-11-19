//
//  ATOMShowDetailOfHomePage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDHotDetailManager.h"
#import "DDSessionManager.h"
#import "PIECommentEntity.h"
//#import "ATOMCommentDAO.h"
//#import "ATOMDetailImageDAO.h"
//#import "PIEPageDAO.h"

#import "PIEImageEntity.h"
@interface DDHotDetailManager ()
//@property (nonatomic, strong) ATOMDetailImageDAO *detailImageDAO;
//@property (nonatomic, strong) ATOMCommentDAO *commentDAO;
@end

@implementation DDHotDetailManager
//
////- (ATOMDetailImageDAO *)detailImageDAO {
////    if (!_detailImageDAO) {
////        _detailImageDAO = [ATOMDetailImageDAO new];
////    }
////    return _detailImageDAO;
////}
//
////- (ATOMCommentDAO *)commentDAO {
////    if (!_commentDAO) {
////        _commentDAO = [ATOMCommentDAO new];
////    }
////    return _commentDAO;
////}
//
- (NSURLSessionDataTask *)fetchAllReply:(NSDictionary *)param ID:(NSInteger)replyID withBlock:(void (^)(NSMutableArray *askArrayRET, NSMutableArray *replyArrayRET))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:[NSString stringWithFormat:@"ask/show/%zd",replyID] parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* data = [ responseObject objectForKey:@"data"];
        if (data.count > 0) {
            NSMutableArray *askRETArray = [NSMutableArray array];
            NSMutableArray *replyRETArray = [NSMutableArray array];
            
            NSArray *replyArray = [data objectForKey:@"replies"];
            NSDictionary *askObject = [data objectForKey:@"ask"];
            NSArray *askImageEntities = [askObject objectForKey:@"ask_uploads"];
            
            for (NSDictionary* object in askImageEntities) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:askObject error:NULL];
                PIEImageEntity* imgEntity = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:object error:NULL];
                entity.imageURL = imgEntity.url;
                entity.imageWidth = imgEntity.width;
                entity.imageHeight = imgEntity.height;
                
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.thumbEntityArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.thumbEntityArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                
                entity.thumbEntityArray = thumbArray;

                
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                
                [askRETArray addObject:vm];

            }

            for (int i = 0; i < replyArray.count; i++) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[replyArray objectAtIndex:i] error:NULL];
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [replyRETArray addObject:vm];

            }
            if (block) {
                block(askRETArray, replyRETArray);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (block) {
            block(nil, nil);
        }
    }];
}

//
////暂时不存。
//- (void)saveDetailImagesInDB:(NSMutableArray *)detailImages {
//    if ([self isDetailImagesRechingTopBounds]) {
//        [self clearPartOfDetailImages];
//    }
//    
//    for (ATOMDetailPage *detailImage in detailImages) {
//        if ([self.detailImageDAO isExistDetailImage:detailImage]) {
//            [self.detailImageDAO updateDetailImage:detailImage];
//        } else {
//            [self.detailImageDAO insertDetailImage:detailImage];
//        }
//        //存储热门评论
//        NSArray *comments = detailImage.hotCommentArray;
//        for (ATOMComment *comment in comments) {
//            if ([self.commentDAO isExistComment:comment]) {
//                [self.commentDAO updateComment:comment];
//            } else {
//                [self.commentDAO insertComment:comment];
//            }
//        }
//    }
//}
//
//- (NSArray *)getDetalImagesByImageID:(NSInteger)imageID {
//    NSArray *array = [self.detailImageDAO selectDetailImagesByImageID:imageID];
//    //更新点击时间
//    [self updateClickTime:imageID];
//    for (ATOMDetailPage *detailImage in array) {
//        detailImage.hotCommentArray = [self.commentDAO selectCommentsByDetailImageID:detailImage.detailID];
//    }
//    return array;
//}
//
///**
// *  判断详情数据是否超过30条，如果超过30，则调用clearPartOfDetailImages
// *
// *  @return BOOL Value
// */
//- (BOOL)isDetailImagesRechingTopBounds {
//    BOOL flag;
//    NSArray *array = [self.detailImageDAO selectDetailImages];
//    if (!array || array.count < 30) {
//        flag = NO;
//    } else {
//        flag = YES;
//    }
//    return flag;
//}
//
///**
// *  按照时间戳排序清理前15条数据
// */
//- (void)clearPartOfDetailImages {
////    NSFileManager *fileManager = [NSFileManager defaultManager];
////    NSString *directory = [NSString stringWithFormat:@"%@/DetailImage", PATH_OF_DOCUMENT];
//    NSArray *homeImageIDArray = [self.detailImageDAO selectHomeImageIDOrderByClickTime];
//    for (int i = 0; i < homeImageIDArray.count; i++) {
//        NSInteger homeImageID = [homeImageIDArray[i] integerValue];
//        NSArray *detailImageArray = [self.detailImageDAO selectDetailImagesByImageID:homeImageID];
//        //删除评论
//        for (ATOMDetailPage *detailImage in detailImageArray) {
//            [self.commentDAO clearCommentsByDetailImageID:detailImage.detailID];
//            //删除沙盒中DetailImage文件夹中对应的记录
////            NSString *filename = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE%d-%d.jpg", (int)detailImage.imageID, (int)detailImage.imageID]];
////            BOOL bo = [fileManager removeItemAtPath:filename error:NULL];
////            if (bo) {
////                NSLog(@"remove %@ success", filename);
////            } else {
////                NSLog(@"remove %@ fail", filename);
////            }
//        }
//        //删除详情
//        [self.detailImageDAO clearDetailImagsByImageID:homeImageID];
//    }
//}

//- (void)updateClickTime:(NSInteger)imageID {
//    NSArray *detailImageArray = [self.detailImageDAO selectDetailImagesByImageID:imageID];
//    NSDate *clickTime = [NSDate date];
//    for (ATOMDetailPage *detailImage in detailImageArray) {
//        detailImage.clickTime = [clickTime timeIntervalSince1970];
//        [self.detailImageDAO updateDetailImage:detailImage];
//    }
//}
//
































@end
