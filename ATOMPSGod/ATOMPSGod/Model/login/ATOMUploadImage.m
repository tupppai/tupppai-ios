//
//  ATOMUploadImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUploadImage.h"
#import "DDSessionManager.h"
#import "ATOMImage.h"

@implementation ATOMUploadImage

//- (NSURLSessionDataTask *)UploadImage:(NSData *)data withParam:(NSDictionary *)param andBlock:(void (^)(ATOMImage *, NSError *))block {
//    return [[DDSessionManager shareHTTPSessionManager] POST:@"image/upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"images" fileName:@"ATOMIMAGE" mimeType:@"image/png"];
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        ATOMImage *imageInfomation = [MTLJSONAdapter modelOfClass:[ATOMImage class] fromJSONDictionary:responseObject error:NULL];
//        [ATOMCurrentUser currentUser].avatar = imageInfomation.imageURL;
//        [ATOMCurrentUser currentUser].avatarID = imageInfomation.imageID;
//        if (block) {
//            block(imageInfomation, nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
//}

- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(ATOMImage *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"images" fileName:@"ATOMIMAGE" mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        ATOMImage *imageInfomation = [MTLJSONAdapter modelOfClass:[ATOMImage class] fromJSONDictionary:responseObject error:NULL];
        if (block) {
            block(imageInfomation, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
