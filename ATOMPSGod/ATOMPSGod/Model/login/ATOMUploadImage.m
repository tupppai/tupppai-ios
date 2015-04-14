//
//  ATOMUploadImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUploadImage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMImage.h"

@implementation ATOMUploadImage

//- (AFHTTPRequestOperation *)UploadImage:(NSData *)data withParam:(NSDictionary *)param andBlock:(void (^)(ATOMImage *, NSError *))block {
//    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"image/upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"images" fileName:@"ATOMIMAGE" mimeType:@"image/png"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        ATOMImage *imageInfomation = [MTLJSONAdapter modelOfClass:[ATOMImage class] fromJSONDictionary:responseObject error:NULL];
//        [ATOMCurrentUser currentUser].avatar = imageInfomation.imageURL;
//        [ATOMCurrentUser currentUser].avatarID = imageInfomation.imageID;
//        if (block) {
//            block(imageInfomation, nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (block) {
//            block(nil, error);
//        }
//    }];
//}

- (AFHTTPRequestOperation *)UploadImage:(NSData *)data WithBlock:(void (^)(ATOMImage *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"images" fileName:@"ATOMIMAGE" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ATOMImage *imageInfomation = [MTLJSONAdapter modelOfClass:[ATOMImage class] fromJSONDictionary:responseObject error:NULL];
        [ATOMCurrentUser currentUser].avatar = imageInfomation.imageURL;
        [ATOMCurrentUser currentUser].avatarID = imageInfomation.imageID;
        if (block) {
            block(imageInfomation, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
