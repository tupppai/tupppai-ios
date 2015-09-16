//
//  QBAlbumsViewController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBImagePickerController;

@interface QBAlbumsViewController : UITableViewController
@property (nonatomic, copy) NSArray *assetsGroups;
@property (nonatomic, weak) QBImagePickerController *imagePickerController;
@property (nonatomic, assign) BOOL initPush;

@end
