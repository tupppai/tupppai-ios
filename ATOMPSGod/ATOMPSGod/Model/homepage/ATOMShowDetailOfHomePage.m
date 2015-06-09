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

- (AFHTTPRequestOperation *)ShowDetailOfHomePage:(NSDictionary *)param withImageID:(NSInteger)imageID withBlock:(void (^)(NSMutableArray *, NSError *))block {
    NSLog(@"%@ %ld", param[@"type"], [param[@"page"] longValue]);
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:[NSString stringWithFormat:@"ask/show/%d", (int)imageID] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ask/show/%ld,responseObject%@",(long)imageID,responseObject);
        NSMutableArray *detailOfHomePageArray = [NSMutableArray array];
        NSArray *imageDataArray = responseObject[@"data"][@"replies"];
        NSDate *clickTime = [NSDate date];
        for (int i = 0; i < imageDataArray.count; i++) {
            ATOMDetailImage *detailImage = [MTLJSONAdapter modelOfClass:[ATOMDetailImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
            detailImage.imageID = imageID;
            detailImage.clickTime = [clickTime timeIntervalSince1970];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)saveDetailImagesInDB:(NSMutableArray *)detailImages {
    
    if ([self isDetailImagesRechingTopBounds]) {
        [self clearPartOfDetailImages];
    }
    
    for (ATOMDetailImage *detailImage in detailImages) {
        if ([self.detailImageDAO isExistDetailImage:detailImage]) {
            [self.detailImageDAO updateDetailImage:detailImage];
        } else {
            [self.detailImageDAO insertDetailImage:detailImage];
            //创建HomePage目录
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *homePageDirectory = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"DetailImage"];
            BOOL flag;
            if ([fileManager fileExistsAtPath:homePageDirectory isDirectory:&flag]) {
                if (flag) {
                    NSLog(@"DetailImage directory already exists");
                }
            } else {
                BOOL bo = [fileManager createDirectoryAtPath:homePageDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
                if (bo) {
                    NSLog(@"create DetailImage directory success");
                } else {
                    NSLog(@"create DetailImage directory fail");
                }
            }
            //将图片写入沙盒中的HomePage目录下
            dispatch_queue_t q = dispatch_queue_create("LoadImage", NULL);
            dispatch_async(q, ^{
                NSLog(@"%@",detailImage.imageURL);
                NSURL *imageURL = [NSURL URLWithString:detailImage.imageURL];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                NSString *path = [homePageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE%d-%d.jpg", (int)detailImage.imageID, (int)detailImage.imageID]];
                if ([UIImageJPEGRepresentation(image, 1) writeToFile:path atomically:YES]) {
                    NSLog(@"write ATOMIMAGE%d-%d.jpg success", (int)detailImage.imageID, (int)detailImage.detailID);
                } else {
                    NSLog(@"write ATOMIMAGE%d-%d.jpg fail in %@", (int)detailImage.imageID, (int)detailImage.detailID, path);
                }
            });
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSString stringWithFormat:@"%@/DetailImage", PATH_OF_DOCUMENT];
    NSArray *homeImageIDArray = [self.detailImageDAO selectHomeImageIDOrderByClickTime];
    for (int i = 0; i < homeImageIDArray.count; i++) {
        NSInteger homeImageID = [homeImageIDArray[i] integerValue];
        NSArray *detailImageArray = [self.detailImageDAO selectDetailImagesByImageID:homeImageID];
        //删除评论
        for (ATOMDetailImage *detailImage in detailImageArray) {
            [self.commentDAO clearCommentsByDetailImageID:detailImage.detailID];
            //删除沙盒中DetailImage文件夹中对应的记录
            NSString *filename = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE%d-%d.jpg", (int)detailImage.imageID, (int)detailImage.imageID]];
            BOOL bo = [fileManager removeItemAtPath:filename error:NULL];
            if (bo) {
                NSLog(@"remove %@ success", filename);
            } else {
                NSLog(@"remove %@ fail", filename);
            }
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
