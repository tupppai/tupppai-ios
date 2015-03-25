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
#import "ATOMHomePageViewModel.h"
#import "ATOMHomeImageDAO.h"
#import "ATOMImageTipLabelDAO.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMShowHomepage ()

@property (nonatomic, strong) ATOMHomeImageDAO *homeImageDAO;
@property (nonatomic, strong) ATOMImageTipLabelDAO *imageTipLabelDAO;

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

- (AFHTTPRequestOperation *)ShowHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    NSLog(@"%@ %ld", param[@"type"], [param[@"page"] longValue]);
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"index/index" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *homepageArray = [NSMutableArray array];
        NSArray *imageDataArray = responseObject[@"data"];
        for (int i = 0; i < imageDataArray.count; i++) {
            ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
            homeImage.tipLabelArray = [NSMutableArray array];
            NSArray *labelDataArray = imageDataArray[i][@"labels"];
            if (labelDataArray.count) {
                for (int j = 0; j < labelDataArray.count; j++) {
                    ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                    tipLabel.imageID = homeImage.imageID;
                    [homeImage.tipLabelArray addObject:tipLabel];
                }
            }
            [homepageArray addObject:homeImage];
        }
        if (block) {
            block(homepageArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    }
}

- (NSArray *)getHomeImages {
    NSArray *array = [self.homeImageDAO selectHomeImages];
    for (ATOMHomeImage *homeImage in array) {
        homeImage.tipLabelArray = [self.imageTipLabelDAO selectTipLabelsByImageID:homeImage.imageID];
    }
    return array;
}

- (void)clearHomeImages {
    [self.homeImageDAO clearHomeImages];
    //清空标签数据库
    [self.imageTipLabelDAO clearTipLabels];
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
