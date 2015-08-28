//
//  ATOMBaseRequest.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseService.h"

@implementation DDBaseService

+ (NSURLSessionDataTask *)toggleLike:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block {
    NSString* url;
    if (type == ATOMPageTypeAsk) {
        url = [NSString stringWithFormat:@"ask/upask/%ld",(long)ID];
    } else if (type == ATOMPageTypeReply) {
        url = [NSString stringWithFormat:@"reply/upreply/%ld",(long)ID];
    }
    return [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
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
+ (void)toggleLike:(NSDictionary *)param withType:(ATOMPageType)type withID:(NSInteger)ID  withBlock:(void (^)(NSError *))block {
    NSString* url;
    if (type == ATOMPageTypeAsk) {
        url = [NSString stringWithFormat:@"ask/upask/%ld",(long)ID];
    } else if (type == ATOMPageTypeReply) {
        url = [NSString stringWithFormat:@"reply/upreply/%ld",(long)ID];
    }
    
    [DDBaseService GET:param withUrl:url withBlock:^(id responseObject) {
        if (responseObject) {
            block(nil);
        } else {
            NSError* error = [NSError new];
            block(error);
        }
    }];
}
+ (void)downloadImage:(NSString*)url withBlock:(void (^)(UIImage* image))block {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:filePath]];
        if (image) {
            block(image);
        } else {
            block(nil);
        }
        
    }];
    [downloadTask resume];
}

+ (void)POST2 :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(id responseObject))block {
     [[DDSessionManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMBaseRequest post info%@",[ responseObject objectForKey:@"info"]);
            if (block) {
                block(responseObject);
            }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}

+ (NSURLSessionDataTask *)get :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *))block {
    NSLog(@"ATOMBaseRequest post param %@",param);
    return [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMBaseRequest post responseObject%@",responseObject);
        NSLog(@"ATOMBaseRequest post info%@",[ responseObject objectForKey:@"info"]);
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

+ (void)GET :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(id responseObject))block {
     [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(responseObject);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}

+ (void) POST :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(id responseObject))block {
    NSLog(@"POST  param %@",param);
     [[DDSessionManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST  responseObject%@",responseObject);
        NSLog(@"POST  info%@",[ responseObject objectForKey:@"info"]);
         
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            if (block) {
                block(responseObject);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
}
@end
