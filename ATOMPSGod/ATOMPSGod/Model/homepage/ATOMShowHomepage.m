//
//  ATOMShowHomepage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowHomepage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMReplier.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHomeImageDAO.h"
#import "ATOMImageTipLabelDAO.h"
#import "ATOMReplierDAO.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMShowHomepage ()

@property (nonatomic, strong) ATOMHomeImageDAO *homeImageDAO;
@property (nonatomic, strong) ATOMImageTipLabelDAO *imageTipLabelDAO;
@property (nonatomic, strong) ATOMReplierDAO *replierDAO;

@end

@implementation ATOMShowHomepage

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (ATOMHomeImageDAO *)homeImageDAO {
    if (!_homeImageDAO) {
        _homeImageDAO = [ATOMHomeImageDAO new];
    }
    return _homeImageDAO;
}

- (ATOMImageTipLabelDAO *)imageTipLabelDAO {
    if (!_imageTipLabelDAO) {
        _imageTipLabelDAO = [ATOMImageTipLabelDAO new];
    }
    return _imageTipLabelDAO;
}

- (ATOMReplierDAO *)replierDAO {
    if (!_replierDAO) {
        _replierDAO = [ATOMReplierDAO new];
    }
    return _replierDAO;
}

- (AFHTTPRequestOperation *)toggleLike:(NSDictionary *)param withID:(NSInteger)imageID  withBlock:(void (^)(NSString *, NSError *))block {
    NSString* url = [NSString stringWithFormat:@"ask/upask/%ld",(long)imageID];
    NSLog(@"param %@, url %@",param,url);
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(@"success", nil);
            }
        } else {
            block(@"fail", nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(@"fail", error);
        }
    }];
}

- (AFHTTPRequestOperation *)ShowHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"ask/index" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"ShowHomepage responseObject%@",responseObject);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *homepageArray = [NSMutableArray array];
            NSArray *imageDataArray = responseObject[@"data"];
            for (int i = 0; i < imageDataArray.count; i++) {
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
                homeImage.homePageType = (NSString*)[param[@"type"] copy];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = imageDataArray[i][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                homeImage.replierArray = [NSMutableArray array];
                NSArray *replierArray = imageDataArray[i][@"replyer"];
                if (replierArray.count) {
                    for (int j = 0; j < replierArray.count; j++) {
                        ATOMReplier *replier = [MTLJSONAdapter modelOfClass:[ATOMReplier class] fromJSONDictionary:replierArray[j] error:NULL];
                        replier.imageID = homeImage.imageID;
                        [homeImage.replierArray addObject:replier];
                    }
                }
                NSLog(@"homeImage %@ ",homeImage);
                [homepageArray addObject:homeImage];
            }
            if (block) {
                block(homepageArray, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil, error);
        }
    }];
            
}

- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages {
    for (ATOMHomeImage *homeImage in homeImages) {
        if ([self.homeImageDAO isExistHomeImage:homeImage]) {
            [self.homeImageDAO updateHomeImage:homeImage];
        } else {
            [self.homeImageDAO insertHomeImage:homeImage];
            //创建HomePage目录
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *homePageDirectory = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"HomePage"];
            BOOL flag;
            if ([fileManager fileExistsAtPath:homePageDirectory isDirectory:&flag]) {
                if (flag) {
                    NSLog(@"HomePage directory already exists");
                }
            } else {
                BOOL bo = [fileManager createDirectoryAtPath:homePageDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
                if (bo) {
                    NSLog(@"create HomePage directory success");
                } else {
                    NSLog(@"create HomePage directory fail");
                }
            }
            //将图片写入沙盒中的HomePage目录下
            dispatch_queue_t q = dispatch_queue_create("LoadImage", NULL);
            dispatch_async(q, ^{
                NSLog(@"%@",homeImage.imageURL);
                NSURL *imageURL = [NSURL URLWithString:homeImage.imageURL];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                NSString *path = [homePageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE-%d.jpg", (int)homeImage.imageID]];
                NSLog(@"path %@",path);
                if ([UIImageJPEGRepresentation(image, 1) writeToFile:path atomically:YES]) {
                    NSLog(@"write ATOMIMAGE-%d success", (int)homeImage.imageID);
                } else {
                    NSLog(@"write ATOMIMAGE-%d fail in %@", (int)homeImage.imageID, path);
                }
            });
        }
        //插入标签
        NSArray *labels = homeImage.tipLabelArray;
        for (ATOMImageTipLabel *label in labels) {
            if ([self.imageTipLabelDAO isExistTipLabel:label]) {
                [self.imageTipLabelDAO updateTipLabel:label];
            } else {
                [self.imageTipLabelDAO insertTipLabel:label];
            }
        }
        //插入replier
        NSArray *repliers = homeImage.replierArray;
        for (ATOMReplier *replier in repliers) {
            if ([self.replierDAO isExistReplier:replier]) {
                [self.replierDAO updateReplier:replier];
            } else {
                [self.replierDAO insertReplier:replier];
            }
        }
    }
}

- (NSArray *)getHomeImages {
    NSArray *array = [self.homeImageDAO selectHomeImages];
    for (ATOMHomeImage *homeImage in array) {
        homeImage.tipLabelArray = [self.imageTipLabelDAO selectTipLabelsByImageID:homeImage.imageID];
        homeImage.replierArray = [self.replierDAO selectReplierByImageID:homeImage.imageID];
    }
    return array;
}

- (NSArray *)getHomeImagesWithHomeType:(NSString *)homeType {
    NSArray *array = [self.homeImageDAO selectHomeImagesWithHomeType:homeType];
    for (ATOMHomeImage *homeImage in array) {
        homeImage.tipLabelArray = [self.imageTipLabelDAO selectTipLabelsByImageID:homeImage.imageID];
        homeImage.replierArray = [self.replierDAO selectReplierByImageID:homeImage.imageID];
    }
    return array;
}

- (void)clearHomePages {
    [self.homeImageDAO clearHomeImages];
    //清空标签数据库
    [self.imageTipLabelDAO clearTipLabels];
    //清空ATOMReplier数据库
    [self.replierDAO clearReplier];
    //删除沙盒中HomePage文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSString stringWithFormat:@"%@/HomePage", PATH_OF_DOCUMENT];
    NSArray *fileContents = [fileManager contentsOfDirectoryAtPath:directory error:NULL];
    NSEnumerator *e =[fileContents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject]) {
        BOOL bo = [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
        if (bo) {
            NSLog(@"remove HomePageImage success");
        } else {
            NSLog(@"remove HomePageImage fail");
        }
    }
}
- (void)clearHomePagesWithHomeType:(NSString *)homeType {
    [self.homeImageDAO clearHomeImagesWithHomeType:homeType];
    //清空标签数据库
    [self.imageTipLabelDAO clearTipLabels];
    //清空ATOMReplier数据库
    [self.replierDAO clearReplier];
    //删除沙盒中HomePage文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [NSString stringWithFormat:@"%@/HomePage", PATH_OF_DOCUMENT];
    NSArray *fileContents = [fileManager contentsOfDirectoryAtPath:directory error:NULL];
    NSEnumerator *e =[fileContents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject]) {
        BOOL bo = [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
        if (bo) {
            NSLog(@"remove HomePageImage success");
        } else {
            NSLog(@"remove HomePageImage fail");
        }
    }
}

























@end
