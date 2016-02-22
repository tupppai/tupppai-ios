//
//  ViewController.m
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinViewController.h"
#import <Photos/Photos.h>
#import "Masonry.h"
#import "SwipeView.h"
#import "LeesinTextInputBar.h"
#import "LeesinBottomBar.h"
#import "LeesinAssetCell.h"
#import "LeesinMissionCell.h"
#import "PHAsset+Addition.h"
#import "PIEPageVM+Selected.h"
#import "LeesinPreviewBar.h"
#import "PIEProceedingManager.h"
#import "LeesinUploadModel.h"
#import "LeesinUploadManager.h"
#import "LeesinSwipeView.h"
#import "QBImagePickerController.h"
#import "NSNumber+leesinDone.h"
#import "LeesinTextView.h"

typedef NS_ENUM(NSUInteger, PIESwipeViewResueViewType) {
    PIESwipeViewResueViewTypeMission,
    PIESwipeViewResueViewTypePhoto,
};
@interface LeesinViewController ()<QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) QBImagePickerController *qbImagePickerController;

@end
@interface LeesinViewController ()<LeesinBottomBarDelegate,LeesinPreviewBarDelegate>

@property (nonatomic, strong) LeesinBottomBar *bottomBar;
@property (nonatomic, strong) LeesinPreviewBar *previewBar;
@property (nonatomic, strong) MASConstraint *previewBarMarginBC;
@property (nonatomic, assign) BOOL isPreviewShown;
@end

@interface LeesinViewController ()
@property (nonatomic, strong) LeesinTextInputBar* bar;
@property (nonatomic, strong) MASConstraint *inputBarHC;
@property (nonatomic, strong) MASConstraint *inputbarBottomMarginHC;
@end

@interface LeesinViewController ()<SwipeViewDataSource,SwipeViewDelegate>
@property (nonatomic, strong) UIView *swipeViewContainerView;
@property (nonatomic, strong) LeesinSwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *sourceMissions;
@property (nonatomic, strong) NSMutableArray *sourceMissions_done;
@property (nonatomic, strong) NSMutableArray *sourceMissions_undone;

@property (nonatomic, strong) NSMutableOrderedSet *sourceAssets;
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssets;
@property (nonatomic, strong) NSNumber *selectedIndexOfMission;
@property (nonatomic, assign) NSInteger selectedIndexOfMission_done;
@property (nonatomic, assign) NSInteger selectedIndexOfMission_undone;

@property (nonatomic, assign) BOOL photoLibraryHasChangedOnceFromShooting;

@end


@implementation LeesinViewController

#pragma mark - Initilization

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    }
    return self;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupViews];
    [self setupTapEvents];
    [self registerObservers];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)dealloc {
    [self unRegisterObervers];
}


#pragma mark - Setups

- (void)setupData {
    _selectedAssets = [NSMutableOrderedSet orderedSet];
    _sourceAssets   = [NSMutableOrderedSet orderedSet];
    _sourceMissions_undone = [NSMutableArray array];
    _sourceMissions_done = [NSMutableArray array];

    _selectedIndexOfMission = nil;
    [self setupPhotoSourceData];
    
    self.sourceMissions = self.sourceMissions_undone;
    [self setupMissionSource_undone];
}

- (void)setupViews {
    [self.view addSubview:self.bar];
    [self.view addSubview:self.swipeViewContainerView];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.previewBar];
    [self.view sendSubviewToBack:self.previewBar];
    
    [self.swipeViewContainerView addSubview:self.swipeView];
    
    [self setupViewContraints];
}


- (void)setupTapEvents {
    [self.bar.leftButton1 addTarget:self action:@selector(bar_tapLeftButton1:) forControlEvents:UIControlEventTouchDown];
    [self.bar.leftButton2 addTarget:self action:@selector(bar_tapLeftButton2:) forControlEvents:UIControlEventTouchDown];
    [self.bar.rightButton addTarget:self action:@selector(bar_tapPublishButton:) forControlEvents:UIControlEventTouchDown];

    UITapGestureRecognizer* tapGesure1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tapGesure1];
}
- (void)setupViewContraints {
    
    [self.previewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@38);
        self.previewBarMarginBC =  make.bottom.equalTo(self.bar.mas_top).with.offset(38);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];

    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        _inputBarHC  = make.height.equalTo(@(self.bar.appropriateHeight));
        _inputbarBottomMarginHC = make.bottom.equalTo(self.view).with.offset(-260);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
    }];
    
    [self.swipeViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bar.mas_bottom).with.priorityHigh();
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view).with.priorityHigh();
    }];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(4, 0, 4, 0);
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.swipeViewContainerView).with.insets(inset);
    }];

}


- (void)setupMissionSource_undone {
    if (self.type == LeesinViewControllerTypeReply) {
        WS(ws);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        long long timeStamp = [[NSDate date] timeIntervalSince1970];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(timeStamp) forKey:@"last_updated"];
        [param setObject:@(20) forKey:@"size"];
        [param setObject:@(self.channel_id) forKey:@"category_id"];
        
        self.swipeView.emptyDataSetShouldDisplay = NO;
        [PIEProceedingManager getMyToHelp:param withBlock:^(NSArray *resultArray) {
            if (resultArray.count == 0) {
            } else {
                for (PIEPageModel *model in resultArray) {
                    PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:model];
                    [ws.sourceMissions_undone addObject:vm];
                }
            }

            if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
                self.swipeView.emptyDataSetShouldDisplay = YES;
                [self.swipeView reloadData];
            }
            
        }];
    }
}

- (void)setupMissionSource_done {
    if (self.type == LeesinViewControllerTypeReply) {
        WS(ws);
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        long long timeStamp = [[NSDate date] timeIntervalSince1970];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(timeStamp) forKey:@"last_updated"];
        [param setObject:@(20) forKey:@"size"];
        [param setObject:@(self.channel_id) forKey:@"category_id"];
        self.swipeView.emptyDataSetShouldDisplay = NO;

        [DDService GET:param url:@"profile/done" block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            NSArray* modelArray = [MTLJSONAdapter modelsOfClass:[PIEPageModel class] fromJSONArray:dataArray error:nil];
            for (PIEPageModel* model in modelArray) {
                PIEPageVM* vm = [[PIEPageVM alloc]initWithPageEntity:model];
                [ws.sourceMissions_done addObject:vm];
            }
            if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
                self.swipeView.emptyDataSetShouldDisplay = YES;
                [self.swipeView reloadData];
            }
            }];
    }
}

- (void)setupPhotoSourceData {
    
    [_sourceAssets removeAllObjects];
    
    // Fetch user albums and smart albums
    PHFetchResult *smartAlbum =    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];

    NSArray* assetCollectionSubtypes = @[
                                     @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                     @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                     @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                     ];
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    
        [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
             if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }

    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [_sourceAssets addObject:asset];
        }];
        [self.swipeView reloadData];
    }];
}



#pragma mark - NSNotificationCenter register/unregister

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

- (void)unRegisterObervers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:NULL];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}




#pragma mark - Tap Actions

- (void) tapOnView:(UIGestureRecognizer*)sender {
    if ([self.view hitTest:[sender locationInView:self.view] withEvent:nil] == self.view )  {
        if ([self.bar.textView isFirstResponder]) {
            [self.bar.textView resignFirstResponder];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)bar_tapLeftButton1:(id)sender {
    if ([self.bar.textView isFirstResponder]) {
        [self.bar.textView resignFirstResponder];
    }
    if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission && ![self lsn_isCurrentMissionTypeDone] ) {
        return;
    }

    self.sourceMissions = self.sourceMissions_undone;
    self.bar.buttonType = LeesinTextInputBarButtonTypeMission;
    self.bottomBar.type = LeeSinBottomBarTypeReplyMission;
    self.swipeView.type = LeesinSwipeViewTypeMission;
    [self.swipeView reloadData];
}

- (void)bar_tapLeftButton2:(id)sender {
    
    if ([self.bar.textView isFirstResponder]) {
        [self.bar.textView resignFirstResponder];
    }

    if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
        return;
    }
    if (self.type == LeesinViewControllerTypeAsk) {
        self.bottomBar.type = LeeSinBottomBarTypeAsk;
    } else if (self.type == LeesinViewControllerTypeReply) {
        self.bottomBar.type = LeeSinBottomBarTypeReplyPHAsset;
    } else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection) {
        self.bottomBar.type = LeeSinBottomBarTypeReplyNoMissionSelection;
    }

    self.bar.buttonType = LeesinTextInputBarButtonTypePHAsset;
    self.swipeView.type = LeesinSwipeViewTypePHAsset;

    [self.swipeView reloadData];
}

- (void)bar_tapPublishButton:(id)sender {
    
    if (![self lsn_isPublishReady]) {
        return;
    }
    if ([self.bar.textView isFirstResponder]) {
        [self.bar.textView resignFirstResponder];
    }

    self.bar.rightButton.enabled = NO;
    
    LeesinUploadManager *uploadManager = [LeesinUploadManager new];
    LeesinUploadModel   *uploadModel = [LeesinUploadModel new];
    
    if (self.type == LeesinViewControllerTypeAsk) {
        uploadModel.type = PIEPageTypeAsk;
    } else if (self.type == LeesinViewControllerTypeReply) {
        uploadModel.type = PIEPageTypeReply;
        PIEPageVM* vm = [_sourceMissions objectAtIndex:[self.selectedIndexOfMission integerValue]];
        uploadModel.ask_id = vm.askID;
    } else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection) {
        uploadModel.type = PIEPageTypeReply;
        uploadModel.ask_id = self.ask_id;
    }

    uploadModel.channel_id = self.channel_id;
    uploadModel.content = self.bar.textView.text;
    uploadModel.imageArray = self.selectedAssets;
    
    uploadManager.model = uploadModel;
    [uploadManager upload:^(CGFloat percentage, BOOL success) {
        if (_delegate && [_delegate respondsToSelector:@selector(leesinViewController:uploadPercentage:uploadSucceed:)]) {
            [_delegate leesinViewController:self uploadPercentage:percentage uploadSucceed:success];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
    
}



#pragma mark - Notification Events


- (void)lsn_didChangeTextViewText:(id)sender {

    if (![[sender object] isEqual: self.bar.textView]) {
        return;
    }
    if (self.bar.frame.size.height != self.bar.appropriateHeight) {
        [self.inputBarHC setOffset:self.bar.appropriateHeight];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.bar layoutIfNeeded];
    }];
}

- (void) lsn_willShowKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-[self lsn_appropriateKeyboardHeightFromNotification:notification]];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.bar.buttonType = LeesinTextInputBarButtonTypeNone;
}
- (void) lsn_willHideKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-260];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.bar.buttonType = self.bar.lastButtonType;
    [self.swipeView reloadData];
}

- (void) lsn_didShowKeyboard:(NSNotification*)notification {

}
- (void) lsn_didHideKeyboard:(NSNotification*)notification {
    
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    if (_photoLibraryHasChangedOnceFromShooting) {
        return;
    }
    
    _photoLibraryHasChangedOnceFromShooting = YES;

    dispatch_async(dispatch_get_main_queue(), ^{

        [self setupPhotoSourceData];
        for (PHAsset* asset in self.selectedAssets) {
            asset.selected = NO;
        }
        [self.selectedAssets removeAllObjects];
        
        PHAsset* asset = [_sourceAssets objectAtIndex:0];
        asset.selected = YES;
        [self.selectedAssets addObject:asset];
        
        [self.swipeView reloadData];
//        [self lsn_updatePublishButton];
        [self lsn_updateSourceAndReloadPreviewBar];
        [Hud dismiss:self.view];
    });
}


#pragma mark - Custom Functions


- (CGFloat)lsn_appropriateKeyboardHeightFromNotification:(NSNotification *)notification
{
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    return [self lsn_appropriateKeyboardHeightFromRect:keyboardRect];
}
- (CGFloat)lsn_appropriateKeyboardHeightFromRect:(CGRect)rect
{
    CGRect keyboardRect = [self.view convertRect:rect fromView:nil];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    
    CGFloat keyboardHeight = MAX(0.0, viewHeight - keyboardMinY);
    
    return keyboardHeight;
}

- (id)lsn_getSubviewAsClass:(Class)class fromView:(UIView*)view {
    for (UIView* subview in view.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
    }
    return nil;
}

- (BOOL)lsn_isTextReady {
    
    BOOL isReady =  [self.bar.textView.text length] >= 3;
    if (!isReady) {
        [Hud text:@"请输入至少3个字符的作品描述~" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.4] margin:15 cornerRadius:7];
    }
    return isReady;
}

- (BOOL)lsn_isMissionReady_reply {
    BOOL isReady = [self.previewBar hasSourceMission];
    if (!isReady) {
        [Hud text:@"请选择对应的帮P任务~" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.4] margin:15 cornerRadius:7];
    }
    return isReady;
}
- (BOOL)lsn_isPhotosReady_ask {
    BOOL isReady = [self.previewBar hasSourcePHAsset];
    if (!isReady) {
        [Hud text:@"请至少选择一张求P~" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.4] margin:15 cornerRadius:7];
    }
    return isReady;
}
- (BOOL)lsn_isPhotoReady_reply {
    BOOL isReady = [self.previewBar hasSourcePHAsset];
    if (!isReady) {
        [Hud text:@"请选择一张作品~" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.4] margin:15 cornerRadius:7];
    }
    return isReady;
}
- (BOOL)lsn_isPhotoReady_replyNoMissionSelection {
    return [self.previewBar hasSourcePHAsset];
}

- (BOOL)lsn_isCurrentMissionTypeDone {
    return [self.sourceMissions isEqualToArray:self.sourceMissions_done];
}

- (BOOL)lsn_isSelectionsReady {
    if (self.type == LeesinViewControllerTypeAsk) {
        return [self lsn_isPhotosReady_ask];
    } else if (self.type == LeesinViewControllerTypeReply) {
        return ([self lsn_isMissionReady_reply] && [self lsn_isPhotoReady_reply]);
    }else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection) {
        return ([self lsn_isPhotoReady_reply]);
    }
    return NO;
}

- (BOOL)lsn_isPublishReady {
    return  [self lsn_isSelectionsReady] && [self lsn_isTextReady];
}
//- (void)lsn_updatePublishButton {
//    self.bar.rightButton.enabled = [self lsn_isPublishReady];
//}

- (void)lsn_updateSourceAndReloadPreviewBar {

    if (self.type == LeesinViewControllerTypeAsk) {
        self.previewBar.source = self.selectedAssets;
    } else {
        NSMutableOrderedSet *source = [NSMutableOrderedSet orderedSet];

        if (self.selectedIndexOfMission) {
            PIEPageVM   *vm = [_sourceMissions objectAtIndex:[self.selectedIndexOfMission integerValue]];
            [source addObject:vm];
        }
        if (self.selectedAssets.count > 0) {
            [source addObject:[self.selectedAssets objectAtIndex:0]];
        }
        
        self.previewBar.source = source;

    }
    
    [self reloadPreviewBar];
}



#pragma mark - SwipeView Datasource and Delete


-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        return _sourceMissions.count;
    }
    else if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset)
    {
        return _sourceAssets.count;
    }
    return 0;
}

-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
        CGFloat ratio = 270.0/405.0;
        CGFloat height = swipeView.frame.size.height;
        CGFloat width = height*ratio;
        
        if (!view || view.tag != PIESwipeViewResueViewTypePhoto ) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width+5, height)];
            view.backgroundColor = [UIColor clearColor];
            view.tag = PIESwipeViewResueViewTypePhoto;
            LeesinAssetCell* cell = [[LeesinAssetCell alloc]initWithFrame:view.bounds];
            [view addSubview:cell];
        }
        
        LeesinAssetCell *cell = [self lsn_getSubviewAsClass:[LeesinAssetCell class] fromView:view];;
        CGFloat height_image    = cell.imageView.frame.size.height * [[UIScreen mainScreen] scale];
        CGFloat width_image     = cell.imageView.frame.size.width  * [[UIScreen mainScreen] scale];
        
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHAsset *currentAsset = [_sourceAssets objectAtIndex:index];
        cell.selected = currentAsset.selected;
        [imageManager requestImageForAsset:currentAsset
                                targetSize:CGSizeMake(width_image,height_image)
                               contentMode:PHImageContentModeDefault
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 cell.image = result;
                             }];
    } else  if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        CGFloat ratio = 270.0/405.0;
        CGFloat height = swipeView.frame.size.height;
        CGFloat width = height*ratio;
        
        if (!view || view.tag != PIESwipeViewResueViewTypeMission ) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width+5, height)];
            view.backgroundColor = [UIColor clearColor];
            view.tag = PIESwipeViewResueViewTypeMission;
            LeesinMissionCell* cell = [[LeesinMissionCell alloc]initWithFrame:CGRectMake(0, 0, width, height)];
            [view addSubview:cell];
        }
        PIEPageVM* vm = [_sourceMissions objectAtIndex:index];
        LeesinMissionCell *cell = [self lsn_getSubviewAsClass:[LeesinMissionCell class] fromView:view];
        cell.viewModel = vm;
        cell.selected = vm.selected;
    }
    
    
    
    return view;
}



-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
   
    UIView* view = [swipeView itemViewAtIndex:index];
    BOOL shouldUpdate = YES;
    if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
        
        LeesinAssetCell *cell = [self lsn_getSubviewAsClass:[LeesinAssetCell class] fromView:view];;
        PHAsset *currentAsset = [_sourceAssets objectAtIndex:index];
        if (cell.selected) {
            cell.selected = NO;
            currentAsset.selected = NO;
            [self.selectedAssets removeObject:currentAsset];
        } else {
            if ((self.type == LeesinViewControllerTypeReply && self.selectedAssets.count < 1 )|| (self.type == LeesinViewControllerTypeReplyNoMissionSelection && self.selectedAssets.count < 1 ) || (self.type == LeesinViewControllerTypeAsk && self.selectedAssets.count < 2 )) {
                cell.selected = YES;
                currentAsset.selected = YES;
                [self.selectedAssets addObject:currentAsset];
            } else {
                shouldUpdate = NO;
            }
        }
    } else     if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        
        LeesinMissionCell *cell = [self lsn_getSubviewAsClass:[LeesinMissionCell class] fromView:view];
        PIEPageVM* vm = [_sourceMissions objectAtIndex:index];
        if (cell.selected) {
            cell.selected = NO;
            vm.selected = NO;
            _selectedIndexOfMission = nil;
        } else {
            if (_selectedIndexOfMission == nil) {
                cell.selected = YES;
                vm.selected = YES;
                _selectedIndexOfMission = @(index);
                _selectedIndexOfMission.isMission_undone = [self lsn_isCurrentMissionTypeDone]?NO:YES;
                
            } else {
                shouldUpdate = NO;
            }
        }
    }
    
    if (shouldUpdate) {
        [self lsn_updateSourceAndReloadPreviewBar];
//        [self lsn_updatePublishButton];
    }
    
}

-(void)leesinBottomBar:(LeesinBottomBar *)leesinBottomBar isPhotoLibraryButtonTapped:(BOOL)isPhotoLibraryButtonTapped isAllMissionButtonTapped:(BOOL)isAllMissionButtonTapped isShootingButtonTapped:(BOOL)isShootingButtonTapped {
    
    if (isPhotoLibraryButtonTapped) {
        [self presentViewController:self.qbImagePickerController animated:YES completion:NULL];
    }
    if (isAllMissionButtonTapped) {
        self.bottomBar.button_album.selected = !self.bottomBar.button_album.selected;
        
        if (self.bottomBar.button_album.selected) {
            self.sourceMissions = self.sourceMissions_done;
            if (self.sourceMissions_done.count <= 0) {
                [self setupMissionSource_done];
            } else {
                [self.swipeView reloadData];
            }
        } else {
            self.sourceMissions = self.sourceMissions_undone;
            if (self.sourceMissions_undone.count <= 0) {
                [self setupMissionSource_undone];
            } else {
                [self.swipeView reloadData];
            }
        }
  
    }
    
    
    if (isShootingButtonTapped) {
        _photoLibraryHasChangedOnceFromShooting = NO;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }else {
            NSLog(@"相机不可用");
        }
    }
    
}

-(void)leesinPreviewBar:(LeesinPreviewBar *)leesinPreviewBar didTapImage1:(BOOL)didTapImage1 didTapImage2:(BOOL)didTapImage2 {
    
    if (self.type == LeesinViewControllerTypeAsk) {
        if (didTapImage1) {
            if (self.selectedAssets.count>0) {
                PHAsset *asset = [self.selectedAssets objectAtIndex:0];
                NSInteger index = [_sourceAssets indexOfObject:asset];
                if (index != NSNotFound) {
                    [self.swipeView scrollToItemAtIndex:index duration:0.5];
                }
            }

        }
        if (didTapImage2) {
            if (self.selectedAssets.count>1) {
                PHAsset *asset = [self.selectedAssets objectAtIndex:1];
                NSInteger index = [_sourceAssets indexOfObject:asset];
                if (index != NSNotFound) {
                    [self.swipeView scrollToItemAtIndex:index duration:0.5];
                }
            }
        }
    }
    
    
    else {
        
            if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
                if (self.selectedAssets.count>0) {
                    PHAsset *asset = [self.selectedAssets objectAtIndex:0];
                    NSInteger index = [_sourceAssets indexOfObject:asset];
                    if (index != NSNotFound) {
                        [self.swipeView scrollToItemAtIndex:index duration:0.5];
                    }
                }
            } else if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
                if (self.selectedIndexOfMission) {
                    if (self.swipeView.numberOfItems > [self.selectedIndexOfMission integerValue]) {
                        if (self.selectedIndexOfMission.isMission_undone && ![self lsn_isCurrentMissionTypeDone]) {
                            [self.swipeView scrollToItemAtIndex:[self.selectedIndexOfMission integerValue] duration:0.5];
                        }
                        
                        if (!self.selectedIndexOfMission.isMission_undone && [self lsn_isCurrentMissionTypeDone]) {
                            [self.swipeView scrollToItemAtIndex:[self.selectedIndexOfMission integerValue] duration:0.5];
                        }
                    }
                }
            }
        
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [Hud activity:@"" inView:self.view];
    UIImage *imageToBeSaved = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)reloadPreviewBar {
    
    if ([self.previewBar isSourceEmpty]) {
        if (self.isPreviewShown == NO) {
            return;
        }
        [self.previewBarMarginBC setOffset:38];
        self.isPreviewShown = NO;
    } else {
        if (self.isPreviewShown == YES) {
            return;
        }
        [self.previewBarMarginBC setOffset:0];
        self.isPreviewShown = YES;
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.previewBar layoutIfNeeded];
    } completion:nil];
}


#pragma mark - Get and Set

-(LeesinTextInputBar *)bar {
    if (!_bar) {
        _bar = [LeesinTextInputBar new];
    }
    return _bar;
}
-(LeesinPreviewBar *)previewBar {
    if (!_previewBar) {
        _previewBar = [LeesinPreviewBar new];
        _previewBar.delegate = self;
    }
    return _previewBar;
}
-(void)setType:(LeesinViewControllerType)type {
    _type = type;
    
    if (type == LeesinViewControllerTypeAsk) {
        self.bar.type = LeesinTextInputBarTypeAsk;
        self.bottomBar.type = LeeSinBottomBarTypeAsk;
        self.bar.buttonType = LeesinTextInputBarButtonTypePHAsset;
        self.swipeView.type = LeesinSwipeViewTypePHAsset;
    } else if (type == LeesinViewControllerTypeReply) {
        self.bar.type = LeesinTextInputBarTypeReply;
        self.bar.buttonType = LeesinTextInputBarButtonTypeMission;
        if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
            self.bottomBar.type = LeeSinBottomBarTypeReplyMission;
            self.swipeView = LeesinSwipeViewTypeMission;
        } else if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
            self.bottomBar.type = LeeSinBottomBarTypeReplyPHAsset;
            self.swipeView.type = LeesinSwipeViewTypePHAsset;
        }
    } else if (type == LeesinViewControllerTypeReplyNoMissionSelection) {
        self.bar.buttonType = LeesinTextInputBarButtonTypePHAsset;
        self.bar.type = LeesinTextInputBarTypeReplyNoMissionSelection;
        self.bottomBar.type = LeeSinBottomBarTypeReplyNoMissionSelection;
        self.swipeView.type = LeesinSwipeViewTypePHAsset;
    }
}
-(UIView *)swipeViewContainerView {
    if (!_swipeViewContainerView) {
        _swipeViewContainerView = [UIView new];
        _swipeViewContainerView.backgroundColor = [UIColor colorWithHex:0xeeeeee andAlpha:1.0];
    }
    return _swipeViewContainerView;
}
-(LeesinSwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [LeesinSwipeView new];
        _swipeView.dataSource = self;
        _swipeView.delegate  = self;
    }
    return _swipeView;
}
-(LeesinBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [LeesinBottomBar new];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

-(QBImagePickerController *)qbImagePickerController {
    if (!_qbImagePickerController) {
        _qbImagePickerController = [[QBImagePickerController alloc]init];
        _qbImagePickerController.mediaType = QBImagePickerMediaTypeImage;
        _qbImagePickerController.minimumNumberOfSelection = 1;
        _qbImagePickerController.numberOfColumnsInPortrait = 3;
        _qbImagePickerController.delegate = self;
        if (self.type == LeesinViewControllerTypeAsk) {
            _qbImagePickerController.allowsMultipleSelection = YES;
            _qbImagePickerController.maximumNumberOfSelection = 2;
        } else {
            _qbImagePickerController.allowsMultipleSelection = YES;
            _qbImagePickerController.maximumNumberOfSelection = 1;
        }
    }
    return _qbImagePickerController;
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.qbImagePickerController.selectedAssets removeAllObjects];
    }];
}
-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        for (PHAsset *asset in self.selectedAssets) {
            asset.selected = NO;
        }
        [self.selectedAssets removeAllObjects];
        
        BOOL firstIndexHasBeenExchanged = NO;
        for (PHAsset *asset in assets) {
            
            NSInteger index = [self.sourceAssets indexOfObject:asset];
            if (index != NSNotFound) {
                PHAsset *assetInSource = [self.sourceAssets objectAtIndex:index];
                assetInSource.selected = YES;
                if (!firstIndexHasBeenExchanged) {
                    [self.sourceAssets exchangeObjectAtIndex:index withObjectAtIndex:0];
                    firstIndexHasBeenExchanged = YES;
                } else {
                    [self.sourceAssets exchangeObjectAtIndex:index withObjectAtIndex:1];
                }
                [self.selectedAssets addObject:assetInSource];
            } else {
                asset.selected = YES;
                [self.sourceAssets insertObject:asset atIndex:0];
                [self.selectedAssets addObject:asset];
            }
        }
        
        [self.swipeView reloadData];
        [self.swipeView scrollToOffset:0 duration:0.45];
        [self lsn_updateSourceAndReloadPreviewBar];
        
        [self.qbImagePickerController.selectedAssets removeAllObjects];

    }];
}


@end
