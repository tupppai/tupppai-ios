//
//  ATOMShowHomepage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDHomePageManager.h"
#import "DDSessionManager.h"
#import "ATOMAskPage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMReplier.h"
#import "DDPageVM.h"
#import "ATOMHomeImageDAO.h"
#import "ATOMImageTipLabelDAO.h"
#import "ATOMReplierDAO.h"
#import "kfcHomeScrollView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDHomePageManager ()

@property (nonatomic, strong) ATOMHomeImageDAO *homeImageDAO;
@property (nonatomic, strong) ATOMImageTipLabelDAO *imageTipLabelDAO;
@property (nonatomic, strong) ATOMReplierDAO *replierDAO;

@end

@implementation DDHomePageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSURLSessionDataTask *)getHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"ask/index" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *homepageArray = [NSMutableArray array];
            NSArray *imageDataArray = [ responseObject objectForKey:@"data"];
            for (int i = 0; i < imageDataArray.count; i++) {
                ATOMAskPage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMAskPage class] fromJSONDictionary:imageDataArray[i] error:NULL];
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
                [homepageArray addObject:homeImage];
            }
            if (block) {
                block(homepageArray, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
            
}

- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages {
    for (ATOMAskPage *homeImage in homeImages) {
        if ([self.homeImageDAO isExistHomeImage:homeImage]) {
            [self.homeImageDAO updateHomeImage:homeImage];
        } else {
            [self.homeImageDAO insertHomeImage:homeImage];
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
    for (ATOMAskPage *homeImage in array) {
        homeImage.tipLabelArray = [self.imageTipLabelDAO selectTipLabelsByImageID:homeImage.imageID];
        homeImage.replierArray = [self.replierDAO selectReplierByImageID:homeImage.imageID];
    }
    return array;
}

- (NSArray *)getHomeImagesWithHomeType:(PIEHomeType)homeType {
    
    NSArray *array = [self.homeImageDAO selectHomeImagesWithHomeType:homeType];
    for (ATOMAskPage *homeImage in array) {
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
}
- (void)clearHomePagesWithHomeType:(NSString *)homeType {
    [self.homeImageDAO clearHomeImagesWithHomeType:homeType];
    //清空标签数据库
    [self.imageTipLabelDAO clearTipLabels];
    //清空ATOMReplier数据库
    [self.replierDAO clearReplier];
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




@end
