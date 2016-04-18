//
//  LeesinUploadManager.m
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "LeesinUploadManager.h"
#import "LeesinUploadModel.h"
#import "PIEModelImageInfo.h"
#import <Photos/Photos.h>

@interface LeesinUploadManager()
@property (nonatomic,strong)    NSData* dataImage1;
@property (nonatomic,strong)    NSData* dataImage2;
@end
@implementation LeesinUploadManager


#pragma mark - public methods
- (void)uploadHomework:(void (^)(CGFloat percentage, BOOL success, PIEPageModel *pageModel))block
{
    [Hud text:@"正在上传你的作业..." backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];

    PHAsset *asset = [self.model.imageArray firstObject];
    float ratio1 = [self getAssetRatio:asset];
    
    [self.model.ratioArray addObject:@(ratio1)];
    
    [self getImageDataFromAsset:asset
                          block:^(NSData *data) {
                              _dataImage1 = data;
                              [self uploadHomeworkStep2:^(CGFloat percentage, BOOL success, PIEPageModel *pageModel) {
                                  if (block != nil) {
                                      block(percentage, success, pageModel);
                                  }
                              }];
                          }];
}

- (void)uploadMoment:(void (^)(CGFloat percentage, BOOL success))block
{
//    [Hud text:@"正在上传你的动态..." backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];
    
    PHAsset *asset = [self.model.imageArray firstObject];
    float ratio1 = [self getAssetRatio:asset];
    
    [self.model.ratioArray addObject:@(ratio1)];
    [self getImageDataFromAsset:asset
                          block:^(NSData *data) {
                              _dataImage1 = data;
                              [self uploadMomentStep2:^(CGFloat percentage, BOOL success) {
                                  if (block != nil) {
                                      block(percentage, success);
                                  }
                              }];
                          }];
}

- (void)upload:(void (^)(CGFloat percentage,BOOL success))block {
    
    if (self.model.type == PIEPageTypeAsk) {
        [Hud text:@"正在上传你的求P..." backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];
    } else {
        [Hud text:@"正在上传你的作品..." backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];
    }
    
    PHAsset* asset1;
    PHAsset* asset2;
    NSInteger uploadCount = self.model.imageArray.count;
    
    
    
    if (uploadCount == 1) {
        asset1 = [self.model.imageArray objectAtIndex:0];
        float ratio1 = [self getAssetRatio:asset1];
        [self.model.ratioArray addObject:@(ratio1)];
        
        [self getImageDataFromAsset:asset1 block:^(NSData *data) {
            _dataImage1 = data;
            [self uploadStep2:^(CGFloat percentage, BOOL success) {
                if (block) {
                    block(percentage,success);
                }
            }];
        }];
    } else if (uploadCount >= 2) {
        asset1 = [self.model.imageArray objectAtIndex:0];
        asset2 = [self.model.imageArray objectAtIndex:1];
        
        float ratio1 = [self getAssetRatio:asset1];
        float ratio2 = [self getAssetRatio:asset2];
        [self.model.ratioArray addObject:@(ratio1)];
        [self.model.ratioArray addObject:@(ratio2)];
        
        [self getImageDataFromAsset:asset1 block:^(NSData *data) {
            _dataImage1 = data;
            [self getImageDataFromAsset:asset2 block:^(NSData *data) {
                _dataImage2 = data;
                [self uploadStep2:^(CGFloat percentage, BOOL success) {
                    if (block) {
                        block(percentage,success);
                    }
                }];
            }];
        }];
        
        
    }
    
}


#pragma mark - private helpers
- (void)uploadImage:(NSData*)imageData Type:(PIEPageType)type withBlock:(void (^)(CGFloat percentage,BOOL success))block {
    if (imageData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* url = [NSString stringWithFormat:@"%@%@",[DDSessionManager shareHTTPSessionManager].baseURL,@"image/upload"];
        AFHTTPRequestOperation *requestOperation = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString* attachmentName = @"ask_attachment";
            if (type == PIEPageTypeReply) {
                attachmentName = @"reply_attachment";
            }
            [formData appendPartWithFileData:imageData name:attachmentName fileName:@"AppTupaiImage_iOS" mimeType:@"image/png"];
        }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.model.uploadIdArray addObject:responseObject[@"data"][@"id"]];
            block(1,YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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



- (void) uploadStep2:(void (^)(CGFloat percentage,BOOL success))block {
    
    NSInteger uploadCount = self.model.imageArray.count;
    
    if (self.model.type == PIEPageTypeAsk) {
        if (uploadCount == 1) {
            [self uploadImage:_dataImage1 Type:PIEPageTypeAsk withBlock:^(CGFloat percentage,BOOL success) {
                block(percentage/1.1,NO);
                if (success) {
                    [self uploadRestInfo:^(BOOL success) {
                        if (block) {
                            block(1.0,success);
                        }
                    }];
                }
            }];
        } else  if (uploadCount >= 2) {
            [self uploadImage:_dataImage1 Type:PIEPageTypeAsk withBlock:^(CGFloat percentage,BOOL success) {
                if (!success) {
                    block(percentage/(100/45),NO);
                } else {
                    [self uploadImage:_dataImage2 Type:PIEPageTypeAsk withBlock:^(CGFloat percentage,BOOL success) {
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
    }
    else if (self.model.type == PIEPageTypeReply) {
        if (uploadCount >= 1) {
            [self uploadImage:_dataImage1 Type:PIEPageTypeReply withBlock:^(CGFloat percentage,BOOL success) {
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

/** 这里给我一种强烈的ReactiveCocoa的即视感 */
- (void)uploadHomeworkStep2:
(void (^)(CGFloat percentage, BOOL success, PIEPageModel *pageModel))block{
    [self uploadImage:_dataImage1 Type:PIEPageTypeReply
            withBlock:^(CGFloat percentage, BOOL success) {
                block(percentage/1.1, NO, nil);
                if (success) {
                    [self uploadHomeworkRestInfo:^(BOOL success, PIEPageModel *pageModel) {
                        block(1.0, success, pageModel);
                    }];
                }
            }];
}

- (void)uploadMomentStep2:(void (^)(CGFloat percentage, BOOL success))block
{
    [self uploadImage:_dataImage1
                 Type:PIEPageTypeReply
            withBlock:^(CGFloat percentage, BOOL success) {
                block(percentage / 1.1, NO);
                if (success) {
                    [self uploadMomentRestInfo:^(BOOL success) {
                        block(1.0, success);
                    }];
                }
            }];
}

- (float)getAssetRatio:(PHAsset*)asset{
    NSString* rationString = [NSString stringWithFormat:@"%.4f", ((CGFloat)asset.pixelHeight/(CGFloat)asset.pixelWidth)];
    float ratio = [rationString floatValue];
    return ratio;
}

- (void)getImageDataFromAsset:(PHAsset*)asset block:(void (^)(NSData *data))block {
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (block) {
            block(imageData);
        }
    }];
}

- (void)uploadRestInfo:(void (^) (BOOL success))block {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.model.uploadIdArray forKey:@"upload_ids"];
    [param setObject:self.model.ratioArray forKey:@"ratios"];
    [param setObject:self.model.content forKey:@"desc"];
    //    [param setObject:self.model.tagIDArray forKey:@"tag_ids"];
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


- (void)uploadHomeworkRestInfo:(void (^)(BOOL success, PIEPageModel *pageModel))block
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.model.uploadIdArray forKey:@"upload_ids"];
    [params setObject:self.model.ratioArray forKey:@"ratios"];
    [params setObject:self.model.content forKey:@"desc"];
    [params setObject:@(self.model.ask_id) forKey:@"ask_id"];
    
    // 先调用 reply/multi 将七牛给我的id转换成在服务器的reply_id, 对应的ask_id和category_id
    [DDBaseService
     POST:params
     url:@"reply/multi"
     block:^(id responseObject) {
         if (responseObject == nil) {
             if (block != nil) {
                 block(NO, nil);
             }
         }else{
             // 手拆JSON！
             NSDictionary *dataDict  = responseObject[@"data"];
             PIEPageModel *pageModel = [PIEPageModel new];
             pageModel.ID            = [dataDict[@"id"] integerValue];
             pageModel.askID         = [dataDict[@"ask_id"] integerValue];
             pageModel.type          = PIEPageTypeReply;
             
             if (block != nil) {
                 block(YES, pageModel);
             }
         }
     }];
    // LeesinUploadManager 只负责把图片上传到七牛并且通知服务器绑定reply_id。
}

- (void)uploadMomentRestInfo:(void (^)(BOOL success))block
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.model.uploadIdArray forKey:@"upload_ids"];
    [params setObject:self.model.ratioArray forKey:@"ratios"];
    [params setObject:self.model.content forKey:@"desc"];
    [params setObject:@(self.model.ask_id) forKey:@"ask_id"];
    
    // 先调用 reply/multi 将七牛给我的id转换成在服务器的reply_id, 对应的ask_id和category_id
    [DDBaseService
     POST:params
     url:@"timeline/multi"
     block:^(id responseObject) {
         if (responseObject == nil) {
             if (block != nil) {
                 block(NO);
             }
         }else{
             if (block != nil) {
                 block(YES);
             }
         }
     }];
    // LeesinUploadManager 只负责把图片上传到七牛并且通知服务器绑定reply_id。
}

@end
