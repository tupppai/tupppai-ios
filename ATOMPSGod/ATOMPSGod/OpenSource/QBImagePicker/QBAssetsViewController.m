//
//  QBAssetsViewController.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Views
#import "QBAssetCell.h"
#import "QBVideoIndicatorView.h"
#import "PIECameraCell.h"
// ViewControllers
#import "QBImagePickerController.h"

@interface QBImagePickerController (Private)

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSBundle *assetBundle;

@end

@interface QBAssetsViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;

@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, assign) NSUInteger numberOfAssets;
@property (nonatomic, assign) NSUInteger numberOfPhotos;
@property (nonatomic, assign) NSUInteger numberOfVideos;

@property (nonatomic, assign) BOOL disableScrollToBottom;
@property (nonatomic, strong) NSIndexPath *indexPathForLastVisibleItem;
@property (nonatomic, strong) NSIndexPath *lastSelectedItemIndexPath;

@end

@implementation QBAssetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = self.imagePickerController.allowsMultipleSelection;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PIECameraCell" bundle:nil] forCellWithReuseIdentifier:@"PIECameraCell"];
    
    _selectedCountLabel.layer.cornerRadius = _selectedCountLabel.frame.size.width/2;
    _selectedCountLabel.clipsToBounds = YES;
    // Register observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(assetsLibraryChanged:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:nil];
    [_backButton setTarget:self];
    [_backButton setAction:@selector(tapBackButton)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self updateDoneButtonState];
    [self updateSelectionInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)dealloc
{
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ALAssetsLibraryChangedNotification
                                                  object:nil];
}


- (void)tapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    [self updateAssets];
    
    if ([self isAutoDeselectEnabled] && self.imagePickerController.selectedAssetURLs.count > 0) {
        // Get index of previous selected asset
        NSURL *previousSelectedAssetURL = [self.imagePickerController.selectedAssetURLs firstObject];
        
        [self.assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
            
            if ([assetURL isEqual:previousSelectedAssetURL]) {
                self.lastSelectedItemIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
                *stop = YES;
            }
        }];
    }
    
    [self.collectionView reloadData];
}

- (BOOL)isAutoDeselectEnabled
{
    return (self.imagePickerController.maximumNumberOfSelection == 1
            && self.imagePickerController.maximumNumberOfSelection >= self.imagePickerController.minimumNumberOfSelection);
}


#pragma mark - Handling Device Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Save indexPath for the last item
    self.indexPathForLastVisibleItem = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    // Update layout
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Restore scroll position
    [self.collectionView scrollToItemAtIndexPath:self.indexPathForLastVisibleItem atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Save indexPath for the last item
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    // Update layout
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Restore scroll position
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }];
}


#pragma mark - Handling Assets Library Changes

- (void)assetsLibraryChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSSet *updatedAssetsGroups = notification.userInfo[ALAssetLibraryUpdatedAssetGroupsKey];
        NSURL *assetsGroupURL = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
        
        for (NSURL *updatedAssetsGroupURL in updatedAssetsGroups) {
            if ([updatedAssetsGroupURL isEqual:assetsGroupURL]) {
                [self updateAssets];
                [self.collectionView reloadData];
            }
        }
    });
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectAssets:)]) {
        [self fetchAssetsFromSelectedAssetURLsWithCompletion:^(NSArray *assets) {
            [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController didSelectAssets:assets];
        }];
    }
}


#pragma mark - Toolbar
//
//- (void)setUpToolbarItems
//{
////    // Space
////    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
////    
////    UIBarButtonItem *middleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
////    
////    // Info label
////    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
////    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:nil action:NULL];
//////    infoButtonItem.enabled = NO;
////    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
////    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateDisabled];
////    
////    self.toolbarItems = @[leftSpace, middleSpace, infoButtonItem];
//}

- (void)updateSelectionInfo
{
//    NSMutableOrderedSet *selectedAssetURLs = self.imagePickerController.selectedAssetURLs;
    _selectedCountLabel.text = [NSString stringWithFormat:@"%zd",self.imagePickerController.selectedAssetURLs.count];

//    if (selectedAssetURLs.count > 0) {
//        NSBundle *bundle = self.imagePickerController.assetBundle;
//        NSString *format;
//        if (selectedAssetURLs.count > 1) {
//            format = NSLocalizedStringFromTableInBundle(@"items_selected", @"QBImagePicker", bundle, nil);
//        } else {
//            format = NSLocalizedStringFromTableInBundle(@"item_selected", @"QBImagePicker", bundle, nil);
//        }
//        
//        NSString *title = [NSString stringWithFormat:format, selectedAssetURLs.count];
//        [(UIBarButtonItem *)self.toolbarItems[2] setTitle:title];
//    } else {
//        [(UIBarButtonItem *)self.toolbarItems[2] setTitle:@""];
//    }
}


#pragma mark - Fetching Assets

- (void)updateAssets
{
    NSMutableArray *assets = [NSMutableArray array];
    __block NSUInteger numberOfAssets = 0;
    __block NSUInteger numberOfPhotos = 0;
    __block NSUInteger numberOfVideos = 0;
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            numberOfAssets++;
            
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypePhoto]) numberOfPhotos++;
            else if ([type isEqualToString:ALAssetTypeVideo]) numberOfVideos++;
            
            [assets addObject:result];
        }
    }];
    
    self.assets =[[[assets reverseObjectEnumerator] allObjects] mutableCopy];
    self.numberOfAssets = numberOfAssets;
    self.numberOfPhotos = numberOfPhotos;
    self.numberOfVideos = numberOfVideos;
}

- (void)fetchAssetsFromSelectedAssetURLsWithCompletion:(void (^)(NSArray *assets))completion
{
    // Load assets from URLs
    // The asset will be ignored if it is not found
    ALAssetsLibrary *assetsLibrary = self.imagePickerController.assetsLibrary;
    NSMutableOrderedSet *selectedAssetURLs = self.imagePickerController.selectedAssetURLs;
    
    __block NSMutableArray *assets = [NSMutableArray array];
    
    void (^checkNumberOfAssets)(void) = ^{
        if (assets.count == selectedAssetURLs.count) {
            if (completion) {
                completion([assets copy]);
            }
        }
    };
    
    for (NSURL *assetURL in selectedAssetURLs) {
        [assetsLibrary assetForURL:assetURL
                       resultBlock:^(ALAsset *asset) {
                           if (asset) {
                               // Add asset
                               [assets addObject:asset];
                               
                               // Check if the loading finished
                               checkNumberOfAssets();
                           } else {
                               [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                   [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                       if ([result.defaultRepresentation.url isEqual:assetURL]) {
                                           // Add asset
                                           [assets addObject:result];
                                           
                                           // Check if the loading finished
                                           checkNumberOfAssets();
                                           
                                           *stop = YES;
                                       }
                                   }];
                               } failureBlock:^(NSError *error) {
                                   NSLog(@"Error: %@", [error localizedDescription]);
                               }];
                           }
                       } failureBlock:^(NSError *error) {
                           NSLog(@"Error: %@", [error localizedDescription]);
                       }];
    }
}


#pragma mark - Checking for Selection Limit

- (BOOL)isMinimumSelectionLimitFulfilled
{
   return (self.imagePickerController.minimumNumberOfSelection <= self.imagePickerController.selectedAssetURLs.count);
}

- (BOOL)isMaximumSelectionLimitReached
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.imagePickerController.minimumNumberOfSelection);
   
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        return (self.imagePickerController.maximumNumberOfSelection <= self.imagePickerController.selectedAssetURLs.count);
    }
   
    return NO;
}

- (void)updateDoneButtonState
{
    self.doneButton.enabled = [self isMinimumSelectionLimitFulfilled];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfAssets+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        PIECameraCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIECameraCell" forIndexPath:indexPath];
        return cell;
    }
    QBAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.showsOverlayViewWhenSelected = self.imagePickerController.allowsMultipleSelection;
    
    ALAsset *asset = self.assets[indexPath.item-1];
    // Image
    UIImage * image;
    CGImageRef iRef = nil;
    iRef = [asset aspectRatioThumbnail];
    if (iRef) {
        image = [UIImage imageWithCGImage:iRef];
    } else {
        image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
       cell.imageView.image = image;
    
    // Video indicator
    NSString *assetType = [asset valueForProperty:ALAssetPropertyType];
    
    if ([assetType isEqualToString:ALAssetTypeVideo]) {
        cell.videoIndicatorView.hidden = NO;
        
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        NSInteger minutes = (NSInteger)(duration / 60.0);
        NSInteger seconds = (NSInteger)ceil(duration - 60.0 * (double)minutes);
        cell.videoIndicatorView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    } else {
        cell.videoIndicatorView.hidden = YES;
    }
    
    // Selection state
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    if ([self.imagePickerController.selectedAssetURLs containsObject:assetURL]) {
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:@"FooterView"
                                                                                         forIndexPath:indexPath];
        
        // Number of assets
        UILabel *label = (UILabel *)[footerView viewWithTag:1];
        NSBundle *bundle = self.imagePickerController.assetBundle;
        NSUInteger numberOfPhotos = self.numberOfPhotos;
        NSUInteger numberOfVideos = self.numberOfVideos;
        
        switch (self.imagePickerController.filterType) {
            case QBImagePickerControllerFilterTypeNone:
            {
                NSString *format;
                if (numberOfPhotos == 1) {
                    if (numberOfVideos == 1) {
                        format = NSLocalizedStringFromTableInBundle(@"format_photo_and_video", @"QBImagePicker", bundle, nil);
                    } else {
                        format = NSLocalizedStringFromTableInBundle(@"format_photo_and_videos", @"QBImagePicker", bundle, nil);
                    }
                } else if (numberOfVideos == 1) {
                    format = NSLocalizedStringFromTableInBundle(@"format_photos_and_video", @"QBImagePicker", bundle, nil);
                } else {
                    format = NSLocalizedStringFromTableInBundle(@"format_photos_and_videos", @"QBImagePicker", bundle, nil);
                }
                
                label.text = [NSString stringWithFormat:format, numberOfPhotos, numberOfVideos];
            }
                break;
                
            case QBImagePickerControllerFilterTypePhotos:
            {
                NSString *key = (numberOfPhotos == 1) ? @"format_photo" : @"format_photos";
                NSString *format = NSLocalizedStringFromTableInBundle(key, @"QBImagePicker", bundle, nil);
                
                label.text = [NSString stringWithFormat:format, numberOfPhotos];
            }
                break;
                
            case QBImagePickerControllerFilterTypeVideos:
            {
                NSString *key = (numberOfVideos == 1) ? @"format_video" : @"format_videos";
                NSString *format = NSLocalizedStringFromTableInBundle(key, @"QBImagePicker", bundle, nil);
                
                label.text = [NSString stringWithFormat:format, numberOfVideos];
            }
                break;
        }
        
        return footerView;
    }
    
    return nil;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:shouldSelectAsset:)]) {
        ALAsset *asset = self.assets[indexPath.item];
        return [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController shouldSelectAsset:asset];
    }
    
    if ([self isAutoDeselectEnabled]) {
        return YES;
    }
    
    return ![self isMaximumSelectionLimitReached];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        //go to camera
        
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
        if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *deviceNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"相机不可用"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"好的"
                                                                otherButtonTitles:nil];
            [deviceNotFoundAlert show];

        }else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    } else {
        QBImagePickerController *imagePickerController = self.imagePickerController;
        NSMutableOrderedSet *selectedAssetURLs = imagePickerController.selectedAssetURLs;
        ALAsset *asset = self.assets[indexPath.item-1];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        if (imagePickerController.allowsMultipleSelection) {
            if ([self isAutoDeselectEnabled] && selectedAssetURLs.count > 0) {
                // Remove previous selected asset from set
                [imagePickerController willChangeValueForKey:@"selectedAssetURLs"];
                [selectedAssetURLs removeObjectAtIndex:0];
                [imagePickerController didChangeValueForKey:@"selectedAssetURLs"];
                
                // Deselect previous selected asset
                if (self.lastSelectedItemIndexPath) {
                    [collectionView deselectItemAtIndexPath:self.lastSelectedItemIndexPath animated:NO];
                }
            }
            
            // Add asset to set
            [imagePickerController willChangeValueForKey:@"selectedAssetURLs"];
            [selectedAssetURLs addObject:assetURL];
            [imagePickerController didChangeValueForKey:@"selectedAssetURLs"];
            
            self.lastSelectedItemIndexPath = indexPath;
            
            [self updateDoneButtonState];
            
            if (imagePickerController.showsNumberOfSelectedAssets) {
                [self updateSelectionInfo];
            }
        } else {
            if ([imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectAsset:)]) {
                [imagePickerController.delegate qb_imagePickerController:imagePickerController didSelectAsset:asset];
            }
        }

    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        
        if (!self.imagePickerController.allowsMultipleSelection) {
            return;
        }
        
        QBImagePickerController *imagePickerController = self.imagePickerController;
        NSMutableOrderedSet *selectedAssetURLs = imagePickerController.selectedAssetURLs;
        
        // Remove asset from set
        ALAsset *asset = self.assets[indexPath.item-1];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        [imagePickerController willChangeValueForKey:@"selectedAssetURLs"];
        [selectedAssetURLs removeObject:assetURL];
        [imagePickerController didChangeValueForKey:@"selectedAssetURLs"];
        
        self.lastSelectedItemIndexPath = nil;
        
        [self updateDoneButtonState];
        
        if (imagePickerController.showsNumberOfSelectedAssets) {
            [self updateSelectionInfo];
            
            if (selectedAssetURLs.count == 0) {
                // Hide toolbar
                [self.navigationController setToolbarHidden:YES animated:YES];
            }
        }
    }

}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfColumns;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        numberOfColumns = self.imagePickerController.numberOfColumnsInPortrait;
    } else {
        numberOfColumns = self.imagePickerController.numberOfColumnsInLandscape;
    }
    
    CGFloat width = (CGRectGetWidth(self.view.frame) - 2.0 * (numberOfColumns + 1)) / numberOfColumns;
    
    return CGSizeMake(width, width);
}


#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
//    chosenImage
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//}
@end
