//
//  ATOMShowDetailOfHomePage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowDetailOfHomePage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMDetailImage.h"
#import "ATOMComment.h"
#import "ATOMCommentDAO.h"
#import "ATOMDetailImageDAO.h"
#import "ATOMHomeImageDAO.h"
#import "ATOMImageTipLabel.h"
@interface ATOMShowDetailOfHomePage ()
@property (nonatomic, strong) ATOMDetailImageDAO *detailImageDAO;
@property (nonatomic, strong) ATOMCommentDAO *commentDAO;

@end

@implementation ATOMShowDetailOfHomePage

- (ATOMDetailImageDAO *)detailImageDAO {
    if (!_detailImageDAO) {
        _detailImageDAO = [ATOMDetailImageDAO new];
    }
    return _detailImageDAO;
}

- (ATOMCommentDAO *)commentDAO {
    if (!_commentDAO) {
        _commentDAO = [ATOMCommentDAO new];
    }
    return _commentDAO;
}

- (NSURLSessionDataTask *)ShowDetailOfHomePage:(NSDictionary *)param withImageID:(NSInteger)imageID withBlock:(void (^)(NSMutableArray *, NSError *))block {
    NSLog(@"ShowDetailOfHomePage %@", param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:[NSString stringWithFormat:@"ask/show/%d", (int)imageID] parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([ responseObject objectForKey:@"data"]) {
            NSLog(@"ask/show/%ld,responseObject%@",(long)imageID,responseObject);
            NSMutableArray *detailOfHomePageArray = [NSMutableArray array];
            NSArray *imageDataArray = [ responseObject objectForKey:@"data"][@"replies"];
            NSDate *clickTime = [NSDate date];
            for (int i = 0; i < imageDataArray.count; i++) {
                ATOMDetailImage *detailImage = [MTLJSONAdapter modelOfClass:[ATOMDetailImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
                detailImage.imageID = imageID;
                detailImage.clickTime = [clickTime timeIntervalSince1970];
                
                detailImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = [imageDataArray[i] objectForKey:@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = detailImage.imageID;
                        [detailImage.tipLabelArray addObject:tipLabel];
                    }
                }
                
                detailImage.hotCommentArray = [NSMutableArray array];
                NSArray *hotCommentDataArray = imageDataArray[i][@"hot_comments"];
                if (hotCommentDataArray.count) {
                    for (int j = 0; j < hotCommentDataArray.count; j++) {
                        ATOMComment *comment = [MTLJSONAdapter modelOfClass:[ATOMComment class] fromJSONDictionary:hotCommentDataArray[j] error:NULL];
                        comment.commentType = 1;
                        comment.detailID = detailImage.detailID;
                        [detailImage.hotCommentArray addObject:comment];
                    }
                }
                [detailOfHomePageArray addObject:detailImage];
            }
            if (block) {
                block(detailOfHomePageArray, nil);
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


//暂时不存。
- (void)saveDetailImagesInDB:(NSMutableArray *)detailImages {
    if ([self isDetailImagesRechingTopBounds]) {
        [self clearPartOfDetailImages];
    }
    
    for (ATOMDetailImage *detailImage in detailImages) {
        if ([self.detailImageDAO isExistDetailImage:detailImage]) {
            [self.detailImageDAO updateDetailImage:detailImage];
        } else {
            [self.detailImageDAO insertDetailImage:detailImage];
        }
        //存储热门评论
        NSArray *comments = detailImage.hotCommentArray;
        for (ATOMComment *comment in comments) {
            if ([self.commentDAO isExistComment:comment]) {
                [self.commentDAO updateComment:comment];
            } else {
                [self.commentDAO insertComment:comment];
            }
        }
    }
}

- (NSArray *)getDetalImagesByImageID:(NSInteger)imageID {
    NSArray *array = [self.detailImageDAO selectDetailImagesByImageID:imageID];
    //更新点击时间
    [self updateClickTime:imageID];
    for (ATOMDetailImage *detailImage in array) {
        detailImage.hotCommentArray = [self.commentDAO selectCommentsByDetailImageID:detailImage.detailID];
    }
    return array;
}

/**
 *  判断详情数据是否超过30条，如果超过30，则调用clearPartOfDetailImages
 *
 *  @return BOOL Value
 */
- (BOOL)isDetailImagesRechingTopBounds {
    BOOL flag;
    NSArray *array = [self.detailImageDAO selectDetailImages];
    if (!array || array.count < 30) {
        flag = NO;
    } else {
        flag = YES;
    }
    return flag;
}

/**
 *  按照时间戳排序清理前15条数据
 */
- (void)clearPartOfDetailImages {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *directory = [NSString stringWithFormat:@"%@/DetailImage", PATH_OF_DOCUMENT];
    NSArray *homeImageIDArray = [self.detailImageDAO selectHomeImageIDOrderByClickTime];
    for (int i = 0; i < homeImageIDArray.count; i++) {
        NSInteger homeImageID = [homeImageIDArray[i] integerValue];
        NSArray *detailImageArray = [self.detailImageDAO selectDetailImagesByImageID:homeImageID];
        //删除评论
        for (ATOMDetailImage *detailImage in detailImageArray) {
            [self.commentDAO clearCommentsByDetailImageID:detailImage.detailID];
            //删除沙盒中DetailImage文件夹中对应的记录
//            NSString *filename = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE%d-%d.jpg", (int)detailImage.imageID, (int)detailImage.imageID]];
//            BOOL bo = [fileManager removeItemAtPath:filename error:NULL];
//            if (bo) {
//                NSLog(@"remove %@ success", filename);
//            } else {
//                NSLog(@"remove %@ fail", filename);
//            }
        }
        //删除详情
        [self.detailImageDAO clearDetailImagsByImageID:homeImageID];
    }
}

- (void)updateClickTime:(NSInteger)imageID {
    NSArray *detailImageArray = [self.detailImageDAO selectDetailImagesByImageID:imageID];
    NSDate *clickTime = [NSDate date];
    for (ATOMDetailImage *detailImage in detailImageArray) {
        detailImage.clickTime = [clickTime timeIntervalSince1970];
        [self.detailImageDAO updateDetailImage:detailImage];
    }
}

































@end
