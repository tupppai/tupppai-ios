//
//  ATOMUploadImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEUploadManager.h"
#import "DDSessionManager.h"
#import "ATOMImage.h"
@interface PIEUploadManager()
@property (nonatomic, strong) NSMutableArray *uploadIdArray;
@property (nonatomic, strong) NSMutableArray *ratioArray;
@property (nonatomic, copy) NSString *desc;

@end
@implementation PIEUploadManager

- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(ATOMImage *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] POST:@"image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"images" fileName:@"iOSTupaiApp" mimeType:@"image/png"];
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

- (void)uploadImage:(NSData*)imageData Type:(NSString*)type withBlock:(void (^)(CGFloat percentage,BOOL success))block {
    if (imageData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestOperation *requestOperation = [manager POST:@"http://api.loiter.us/image/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString* attachmentName = @"ask_attachment";
            if ([type isEqualToString: @"reply"]) {
                attachmentName = @"reply_attachment";
            }
            [formData appendPartWithFileData:imageData name:attachmentName fileName:@"AppTupaiImage_iOS" mimeType:@"image/png"];
        }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"operation success: %@\n %@", operation, responseObject);
            [self.uploadIdArray addObject:responseObject[@"data"][@"id"]];
            block(1,YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:@"ToUpload.dat"];
    NSArray* toUploadInfoArray = [NSArray arrayWithContentsOfFile:filePath2];
    _desc = [toUploadInfoArray lastObject];
    NSData* dataImage1;
    NSData* dataImage2;
    
    UIImage* image1;
    UIImage* image2;
    NSInteger uploadCount = toUploadInfoArray.count - 2;
    
    _type = [toUploadInfoArray objectAtIndex:0];
    if (uploadCount == 1) {
       dataImage1 = [toUploadInfoArray objectAtIndex:1];
        image1 = [UIImage imageWithData:dataImage1];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        [self.ratioArray addObject:@(ratio1)];
    } else if (uploadCount == 2) {
        dataImage1 = [toUploadInfoArray objectAtIndex:1];
        dataImage2 = [toUploadInfoArray objectAtIndex:2];
        image1 = [UIImage imageWithData:dataImage1];
        image2 = [UIImage imageWithData:dataImage2];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        CGFloat ratio2 = image2.size.height/image2.size.width;
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
//    long long timeStamp = [[NSDate date] timeIntervalSince1970];
//    [param setObject:@(timeStamp) forKey:@"last_updated"];

    [param setObject:_desc forKey:@"desc"];
    [DDService ddSaveAsk:param withBlock:^(NSInteger newImageID) {
        if (newImageID!=-1) {
//            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToAskSegment"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            [Hud success:@"求P成功"];
            if  (block) {
                block(YES);
            }
        } else {
            [Hud error:@"求P失败,请重试"];
//            self.navigationItem.rightBarButtonItem.enabled = YES;
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
    [param setObject:_desc forKey:@"desc"];
    NSInteger askID = [[NSUserDefaults standardUserDefaults]
                       integerForKey:@"AskIDToReply"];
    [param setObject:@(askID) forKey:@"ask_id"];
    [DDService ddSaveReply:param withBlock:^(BOOL success) {
        if (success) {
            [Hud success:@"提交作品成功"];
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
