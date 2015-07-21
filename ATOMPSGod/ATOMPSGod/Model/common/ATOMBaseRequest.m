//
//  ATOMBaseRequest.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseRequest.h"
#import "ATOMHTTPRequestOperationManager.h"
@implementation ATOMBaseRequest
- (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withUrl:(NSString*)fUrl withID:(NSInteger)imageID  withBlock:(void (^)(NSError *))block {
    NSString* url = [NSString stringWithFormat:@"%@/%ld",fUrl,(long)imageID];
    NSLog(@"param %@, url %@",param,url);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}
+ (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block {
    NSString* url;
    if (type == ATOMPageTypeAsk) {
        url = [NSString stringWithFormat:@"ask/upask/%ld",(long)ID];
    } else if (type == ATOMPageTypeReply) {
        url = [NSString stringWithFormat:@"reply/upreply/%ld",(long)ID];
    }
    NSLog(@"param %@, url %@",param,url);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

+ (void)downloadImage:(NSString*)url withBlock:(void (^)(UIImage* image))block {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

@end
