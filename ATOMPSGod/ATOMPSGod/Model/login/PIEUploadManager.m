//
//  ATOMUploadImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEUploadManager.h"
#import "DDSessionManager.h"
#import "PIEModelImageInfo.h"
@interface PIEUploadManager()
@property (nonatomic, strong) NSMutableArray *uploadIdArray;
@property (nonatomic, strong) NSMutableArray *ratioArray;

@end
@implementation PIEUploadManager

- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(PIEModelImageInfo *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"images" fileName:@"iOSTupaiApp" mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        PIEModelImageInfo *imageInfomation = [MTLJSONAdapter modelOfClass:[PIEModelImageInfo class] fromJSONDictionary:responseObject error:NULL];
        if (block) {
            block(imageInfomation, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)uploadImage:(NSData*)imageData Type:(NSString*)type withBlock:(void (^)(CGFloat percentage,BOOL success))block {
    if (imageData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* url = [NSString stringWithFormat:@"%@%@",[DDSessionManager shareHTTPSessionManager].baseURL,@"image/upload"];
        AFHTTPRequestOperation *requestOperation = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString* attachmentName = @"ask_attachment";
            if ([type isEqualToString: @"reply"]) {
                attachmentName = @"reply_attachment";
            }
            [formData appendPartWithFileData:imageData name:attachmentName fileName:@"AppTupaiImage_iOS" mimeType:@"image/png"];
        }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"operation success: %@\n %@", operation, responseObject);
            [self.uploadIdArray addObject:responseObject[@"data"][@"id"]];
            block(1,YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
        }];
        [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            if (block) {
                block(percentDone,NO);
            }
//            NSLog(@"progress updated(percentDone) : %f ,totalBytesExpectedToWrite %lld", percentDone,totalBytesExpectedToWrite);
        }];
    } else {
        [Hud error:@"图片数据为空"];
    }

}

- (void)upload:(void (^)(CGFloat percentage,BOOL success))block {
    
    _type = [_uploadInfo objectForKey:@"type"];
    if ([[_uploadInfo objectForKey:@"type"] isEqualToString:@"ask"]) {
        [Hud text:@"正在后台上传你的求P..."];
    } else {
        [Hud text:@"正在后台上传你的作品..."];
    }
    
    NSData* dataImage1;
    NSData* dataImage2;
    
    UIImage* image1;
    UIImage* image2;
    NSInteger uploadCount =[[_uploadInfo objectForKey:@"imageCount"]integerValue];
    
    if (uploadCount == 1) {
        image1 = [_uploadInfo objectForKey:@"image1"];
        dataImage1 = UIImageJPEGRepresentation(image1, 1.0);
        CGFloat ratio1 = image1.size.height/image1.size.width;
        [self.ratioArray addObject:@(ratio1)];
    } else if (uploadCount == 2) {
        image1 = [_uploadInfo objectForKey:@"image1"];
        image2 = [_uploadInfo objectForKey:@"image2"];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        CGFloat ratio2 = image2.size.height/image2.size.width;
        
        dataImage1 = UIImageJPEGRepresentation(image1, 1.0);
        dataImage2 = UIImageJPEGRepresentation(image2, 1.0);

        [self.ratioArray addObject:@(ratio1)];
        [self.ratioArray addObject:@(ratio2)];
    }
    
    if ([_type isEqualToString: @"ask"]) {
        if (uploadCount == 1) {
            [self uploadImage:dataImage1 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                block(percentage/1.1,NO);
                if (success) {
                    [self uploadRestInfo:^(BOOL success) {
                        if (block) {
                            block(1.0,success);
                        }
                    }];
                }
            }];
        } else  if (uploadCount == 2) {
            [self uploadImage:dataImage1 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                if (!success) {
                    block(percentage/(100/45),NO);
                } else {
                    [self uploadImage:dataImage2 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                        block(0.45+percentage/2,NO);
                        if (success) {
                            [self uploadRestInfo:^(BOOL success) {
                                if (block) {
                                    block(1.0,success);
                                }
                            }];
                        }
                    }];
                }
                
            }];
        }
    } else if ([_type isEqualToString:@"reply"]) {
        if (uploadCount == 1) {
            [self uploadImage:dataImage1 Type:@"reply" withBlock:^(CGFloat percentage,BOOL success) {
                block(percentage/1.1,NO);
                if (success) {
                    [self uploadReplyRestInfo:^(BOOL success) {
                        if (block) {
                            block(1.0,success);
                        }
                    }];
                }
            }];
        }
    }
    
}


- (void)uploadRestInfo:(void (^) (BOOL success))block {

    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.uploadIdArray forKey:@"upload_ids"];
    [param setObject:self.ratioArray forKey:@"ratios"];
    
    NSArray* tag_ids = [_uploadInfo objectForKey:@"tag_ids_array"];
    [param setObject:[_uploadInfo objectForKey:@"text_string"] forKey:@"desc"];
    [param setObject:tag_ids forKey:@"tag_ids"];
    
    NSNumber *cid = [_uploadInfo objectForKey:@"channel_id"];
    if (cid) {
        [param setObject:cid forKey:@"category_id"];
    }

    [DDService ddSaveAsk:param withBlock:^(NSInteger newImageID) {
        if (newImageID!=-1) {
            [Hud success:@"求P成功"];
            if  (block) {
                block(YES);
            }
        } else {
            [Hud error:@"求P失败,请重试"];
            if  (block) {
                block(NO);
            }
        }
    }];
}

- (void)uploadReplyRestInfo:(void (^) (BOOL success))block {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.uploadIdArray forKey:@"upload_ids"];
    [param setObject:self.ratioArray forKey:@"ratios"];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:[_uploadInfo objectForKey:@"text_string"] forKey:@"desc"];
    NSNumber *cid = [_uploadInfo objectForKey:@"channel_id"];
    if (cid) {
        [param setObject:cid forKey:@"category_id"];
    }

    
    NSInteger askID = [[NSUserDefaults standardUserDefaults]
                       integerForKey:@"AskIDToReply"];
    [param setObject:@(askID) forKey:@"ask_id"];
    [DDService ddSaveReply:param withBlock:^(BOOL success) {
        if (success) {
            [Hud success:@"上传作品成功"];
            if  (block) {
                block(YES);
            }
        } else {
            [Hud error:@"上传作品失败,请重试"];
            if  (block) {
                block(NO);
            }
        }
    }];
}


-(NSMutableArray *)ratioArray {
    if (!_ratioArray) {
        _ratioArray = [NSMutableArray array];
    }
    return _ratioArray;
}
-(NSMutableArray *)uploadIdArray {
    if (!_uploadIdArray) {
        _uploadIdArray = [NSMutableArray array];
    }
    return _uploadIdArray;
}
@end
