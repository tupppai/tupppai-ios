//
//  ATOMShowDetailOfHomePage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDHotDetailManager.h"
#import "DDSessionManager.h"
#import "ATOMDetailPage.h"
#import "ATOMComment.h"
#import "ATOMCommentDAO.h"
#import "ATOMDetailImageDAO.h"
#import "PIEPageDAO.h"
#import "ATOMImageTipLabel.h"
#import "PIEPageEntity.h"
@interface DDHotDetailManager ()
@property (nonatomic, strong) ATOMDetailImageDAO *detailImageDAO;
@property (nonatomic, strong) ATOMCommentDAO *commentDAO;
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
- (NSURLSessionDataTask *)fetchAllReply:(NSDictionary *)param ID:(NSInteger)replyID withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:[NSString stringWithFormat:@"ask/show/%zd",replyID] parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([ responseObject objectForKey:@"data"]) {
            NSMutableArray *returnArray = [NSMutableArray array];
            NSArray *replyArray = [[responseObject objectForKey:@"data"] objectForKey:@"replies"];
            for (int i = 0; i < replyArray.count; i++) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:replyArray[i] error:NULL];
                NSLog(@"entity ID %zd",entity.ID);
                [returnArray addObject:entity];
            }
            if (block) {
                block(returnArray, nil);
            }
        } else {
            
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil, error);
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
