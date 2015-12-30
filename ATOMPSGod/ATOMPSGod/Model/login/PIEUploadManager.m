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

#import "PIEUploadModel.h"

@interface PIEUploadManager()
//@property (nonatomic, strong) NSMutableArray *uploadIdArray;
//@property (nonatomic, strong) NSMutableArray *ratioArray;
@end

static dispatch_once_t onceToken;
static dispatch_once_t onceToken2;

static PIEUploadManager *shareManager;
static PIEUploadModel *shareModel;

@implementation PIEUploadManager

-(instancetype)init {
    self = [super init];
    if (self) {
        _model = [PIEUploadModel new];
    }
    return self;
}
- (instancetype)initWithShareModel {
    self = [super init];
    if (self) {
        NSLog(@"initWithShareModel shareModel%@",shareModel);
        NSLog(@"initWithShareModel shareModel%zd,%@",shareModel.ask_id,shareModel.imageArray);

        _model = [PIEUploadModel new];
        _model.content = shareModel.content;
        _model.ID = shareModel.ID;
        _model.ask_id = shareModel.ask_id;
        _model.channel_id = shareModel.channel_id;
        _model.type = shareModel.type;
        _model.imageArray = [shareModel.imageArray copy];
        _model.tagIDArray = shareModel.tagIDArray;
        
        NSLog(@"_model!!   %@,%zd,%zd,%zd,%@,%@ ",_model.content,_model.ask_id,_model.channel_id,_model.type,_model.imageArray,_model.tagIDArray);
    }
    return self;
}
+(PIEUploadManager *)shareManager {
        dispatch_once(&onceToken, ^{
            shareManager = [PIEUploadManager new];
        });
        return shareManager;
}

+(PIEUploadModel *)shareModel {
    dispatch_once(&onceToken2, ^{
        shareModel = [PIEUploadModel new];
    });
    return shareModel;
}

- (void)resetModel {
    shareModel = nil;
    shareModel = [PIEUploadModel new];
}


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
            [self.model.uploadIdArray addObject:responseObject[@"data"][@"id"]];
            block(1,YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
        }];
        [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            if (block) {
                block(percentDone,NO);
            }
        }];
    } else {
        [Hud error:@"图片数据为空"];
    }

}

- (void)upload:(void (^)(CGFloat percentage,BOOL success))block {
    
    if (self.model.type == PIEPageTypeAsk) {
        [Hud text:@"正在后台上传你的求P..."];
    } else {
        [Hud text:@"正在后台上传你的作品..."];
    }
    
    NSData* dataImage1;
    NSData* dataImage2;
    
    UIImage* image1;
    UIImage* image2;
    NSInteger uploadCount = self.model.imageArray.count;
    
    if (uploadCount == 1) {
        image1 = [self.model.imageArray objectAtIndex:0];
        dataImage1 = UIImageJPEGRepresentation(image1, 1.0);
        CGFloat ratio1 = image1.size.height/image1.size.width;
        [self.model.ratioArray addObject:@(ratio1)];
    } else if (uploadCount >= 2) {
        image1 = [self.model.imageArray objectAtIndex:0];
        image2 = [self.model.imageArray objectAtIndex:1];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        CGFloat ratio2 = image2.size.height/image2.size.width;
        
        dataImage1 = UIImageJPEGRepresentation(image1, 1.0);
        dataImage2 = UIImageJPEGRepresentation(image2, 1.0);

        [self.model.ratioArray addObject:@(ratio1)];
        [self.model.ratioArray addObject:@(ratio2)];
    }
    
    if (self.model.type == PIEPageTypeAsk) {
        if (uploadCount == 1) {
            [self uploadImage:dataImage1 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                block(percentage/1.1,NO);
                if (success) {
                    [self uploadRestInfo:^(BOOL success) {
                        [[PIEUploadManager shareManager] resetModel];
                        if (block) {
                            block(1.0,success);
                        }
                    }];
                }
            }];
        } else  if (uploadCount >= 2) {
            [self uploadImage:dataImage1 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                if (!success) {
                    block(percentage/(100/45),NO);
                } else {
                    [self uploadImage:dataImage2 Type:@"ask" withBlock:^(CGFloat percentage,BOOL success) {
                        block(0.45+percentage/2,NO);
                        if (success) {
                            [self uploadRestInfo:^(BOOL success) {
                                [[PIEUploadManager shareManager] resetModel];
                                if (block) {
                                    block(1.0,success);
                                }
                            }];
                        }
                    }];
                }
                
            }];
        }
    } else if (self.model.type == PIEPageTypeReply) {
        if (uploadCount >= 1) {
            [self uploadImage:dataImage1 Type:@"reply" withBlock:^(CGFloat percentage,BOOL success) {
                block(percentage/1.1,NO);
                if (success) {
                    [self uploadReplyRestInfo:^(BOOL success) {
                        [[PIEUploadManager shareManager] resetModel];
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
    [param setObject:self.model.uploadIdArray forKey:@"upload_ids"];
    [param setObject:self.model.ratioArray forKey:@"ratios"];
    [param setObject:self.model.content forKey:@"desc"];
    [param setObject:self.model.tagIDArray forKey:@"tag_ids"];
    [param setObject:@(self.model.channel_id) forKey:@"category_id"];

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
    [param setObject:self.model.uploadIdArray forKey:@"upload_ids"];
    [param setObject:self.model.ratioArray forKey:@"ratios"];
    [param setObject:self.model.content forKey:@"desc"];
    [param setObject:@(self.model.channel_id) forKey:@"category_id"];

    [param setObject:@(self.model.ask_id) forKey:@"ask_id"];
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


//-(NSMutableArray *)ratioArray {
//    if (!_ratioArray) {
//        _ratioArray = [NSMutableArray array];
//    }
//    return _ratioArray;
//}
//-(NSMutableArray *)uploadIdArray {
//    if (!_uploadIdArray) {
//        _uploadIdArray = [NSMutableArray array];
//    }
//    return _uploadIdArray;
//}
@end
