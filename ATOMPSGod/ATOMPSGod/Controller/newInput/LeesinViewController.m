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
typedef NS_ENUM(NSUInteger, PIESwipeViewResueViewType) {
    PIESwipeViewResueViewTypeMission,
    PIESwipeViewResueViewTypePhoto,
};

@interface LeesinViewController ()

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
@property (nonatomic, strong) LeesinSwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *sourceMissions;
@property (nonatomic, strong) NSMutableOrderedSet *sourceAssets;
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssets;
@property (nonatomic, assign) NSInteger selectedIndexOfMission;
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

-(void)dealloc {
    [self unRegisterObervers];
}


#pragma mark - Setups

- (void)setupData {
    _selectedAssets = [NSMutableOrderedSet orderedSet];
    _sourceAssets   = [NSMutableOrderedSet orderedSet];
    _sourceMissions = [NSMutableArray array];
    _selectedIndexOfMission = NSNotFound;
    [self setupPhotoSourceData];
    [self setupMissionSource];
}

- (void)setupViews {
    [self.view addSubview:self.bar];
    [self.view addSubview:self.swipeView];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.previewBar];
    [self.view sendSubviewToBack:self.previewBar];
    [self setupViewContraints];
}


- (void)setupTapEvents {
    [self.bar.leftButton1 addTarget:self action:@selector(bar_tapLeftButton1:) forControlEvents:UIControlEventTouchDown];
    [self.bar.leftButton2 addTarget:self action:@selector(bar_tapLeftButton2:) forControlEvents:UIControlEventTouchDown];
    [self.bar.rightButton addTarget:self action:@selector(bar_tapPublishButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.bottomBar.button_confirm addTarget:self action:@selector(bottomToolBar_tapOnConfirmButton:) forControlEvents:UIControlEventTouchDown];
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
        _inputbarBottomMarginHC = make.bottom.equalTo(self.view).with.offset(-230);
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
        
    }];
    
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bar.mas_bottom).with.priorityHigh();
//        make.height.equalTo(@200);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@45);
        make.top.equalTo(self.swipeView.mas_bottom);
        make.bottom.equalTo(self.view).with.priorityHigh();
    }];
}


- (void)setupMissionSource {
    if (self.type == LeesinViewControllerTypeReply) {
        WS(ws);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        long long timeStamp = [[NSDate date] timeIntervalSince1970];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(timeStamp) forKey:@"last_updated"];
        [param setObject:@(20) forKey:@"size"];
        [param setObject:@(self.channel_id) forKey:@"category_id"];
        [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
            if (resultArray.count == 0) {
            } else {
                for (PIEPageModel *model in resultArray) {
                    PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:model];
                    [ws.sourceMissions addObject:vm];
                }
            }
            
            if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
                [self.swipeView reloadData];
            }
            
        }];
    }
}
- (void)setupPhotoSourceData {
    // Fetch user albums and smart albums
    PHFetchResult *smartAlbum =    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];

    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [_sourceAssets addObject:asset];
        }];
    }];
}



#pragma mark - NSNotificationCenter register/unregister

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didShowOrHideKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lsn_didShowOrHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unRegisterObervers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:NULL];
}




#pragma mark - Tap Actions

- (void) tapOnView:(UIGestureRecognizer*)sender {
    if ([self.view hitTest:[sender locationInView:self.view] withEvent:nil] == self.view )  {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)bar_tapLeftButton1:(id)sender {
    if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        return;
    }
    self.bar.buttonType = LeesinTextInputBarButtonTypeMission;
    self.bottomBar.type = LeeSinBottomBarTypeReplyMission;
    self.swipeView.type = LeesinSwipeViewTypeMission;
    [self updateBottomBar];
    [self.swipeView reloadData];
}

- (void)bar_tapLeftButton2:(id)sender {
    
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

    [self updateBottomBar];
    [self.swipeView reloadData];
}

- (void)bar_tapPublishButton:(id)sender {
    
    self.bar.rightButton.enabled = NO;
    
    
    LeesinUploadManager *uploadManager = [LeesinUploadManager new];
    LeesinUploadModel   *uploadModel = [LeesinUploadModel new];
    
    
    if (self.type == LeesinViewControllerTypeAsk) {
        uploadModel.type = PIEPageTypeAsk;
    } else if (self.type == LeesinViewControllerTypeReply) {
        uploadModel.type = PIEPageTypeReply;
        PIEPageVM* vm = [_sourceMissions objectAtIndex:self.selectedIndexOfMission];
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

- (void)bottomToolBar_tapOnConfirmButton:(id)sender {


    if (self.type == LeesinViewControllerTypeAsk) {
        if ([self lsn_isPhotosReady_ask]) {
            for (PHAsset* asset in self.selectedAssets) {
                asset.selected = NO;
            }
            [self.selectedAssets removeAllObjects];
            [self.swipeView reloadData];
            [self.previewBar clear];
        } else {
            [self lsn_injectSourceForPreviewBar];
        }
    }
    
    else if (self.type == LeesinViewControllerTypeReply) {
        
        if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
            if ([self lsn_isPhotoReady_reply]) {
                for (PHAsset* asset in self.selectedAssets) {
                    asset.selected = NO;
                }
                [self.selectedAssets removeAllObjects];
                [self.previewBar clearReplyImage];
                [self.swipeView reloadData];
            } else {
                [self lsn_injectSourceForPreviewBar];
            }
        }
        
        else if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
            if ([self lsn_isMissionReady_reply]) {
                PIEPageVM* vm = [self.sourceMissions objectAtIndex:self.selectedIndexOfMission];
                vm.selected = NO;
                self.selectedIndexOfMission = NSNotFound;
                [self.swipeView reloadData];
                [self.previewBar clearReplyUrl];
            } else {
                [self lsn_injectSourceForPreviewBar];
            }
        }
        
    }
    
    else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection) {
        if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
            if ([self lsn_isPhotoReady_reply]) {
                for (PHAsset* asset in self.selectedAssets) {
                    asset.selected = NO;
                }
                [self.selectedAssets removeAllObjects];
                [self.previewBar clearReplyImage];
                [self.swipeView reloadData];
            } else {
                [self lsn_injectSourceForPreviewBar];
            }
        }
    }
    
    [self togglePreviewBar];
    [self updateBottomBar];
    [self lsn_togglePublishButtonStatus];
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

-(LeesinSwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [LeesinSwipeView new];
        _swipeView.dataSource = self;
        _swipeView.delegate  = self;
        _swipeView.backgroundColor = [UIColor groupTableViewBackgroundColor];//EEEEEE
    }
    return _swipeView;
}
-(LeesinBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [LeesinBottomBar new];
    }
    return _bottomBar;
}


#pragma mark - Notification Events

- (void)lsn_didChangeTextViewText:(id)sender {

    if (![[sender object] isEqual: self.bar.textView]) {
        return;
    }
    [self lsn_togglePublishButtonStatus];
    if (self.bar.frame.size.height != self.bar.appropriateHeight) {
        [self.inputBarHC setOffset:self.bar.appropriateHeight];
    }
}

- (void) lsn_willShowKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-[self lsn_appropriateKeyboardHeightFromNotification:notification]];
}
- (void) lsn_willHideKeyboard:(NSNotification*)notification {
    [_inputbarBottomMarginHC setOffset:-230];
}

- (void) lsn_didShowOrHideKeyboard:(NSNotification*)notification {
    
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
    return [self.bar.textView.text length] > 6;
}

- (BOOL)lsn_isMissionReady_reply {
    return [self.previewBar hasSourceMission];
}
- (BOOL)lsn_isPhotosReady_ask {
    return [self.previewBar hasSourcePHAsset];
}
- (BOOL)lsn_isPhotoReady_reply {
    return [self.previewBar hasSourcePHAsset];
}
- (BOOL)lsn_isPhotoReady_replyNoMissionSelection {
    return [self.previewBar hasSourcePHAsset];
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
    return  [self lsn_isTextReady] &&[self lsn_isSelectionsReady];
}
- (void)lsn_togglePublishButtonStatus {
    self.bar.rightButton.enabled = [self lsn_isPublishReady];
}

- (void)lsn_injectSourceForPreviewBar {

    if (self.type == LeesinViewControllerTypeAsk) {
        self.previewBar.source = self.selectedAssets;
    } else {
        NSMutableOrderedSet *source = [NSMutableOrderedSet orderedSet];


        if (self.selectedIndexOfMission != NSNotFound) {
            PIEPageVM   *vm = [_sourceMissions objectAtIndex:self.selectedIndexOfMission];
            [source addObject:vm];
        }
        if (self.selectedAssets.count > 0) {
            [source addObject:[self.selectedAssets objectAtIndex:0]];
        }
        
        self.previewBar.source = source;

    }
    
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
            view.tag = PIESwipeViewResueViewTypeMission;
            LeesinMissionCell* cell = [[LeesinMissionCell alloc]initWithFrame:view.bounds];
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
    

    if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
        
        if (self.type == LeesinViewControllerTypeAsk && [self lsn_isPhotosReady_ask]) {
            return;
        }
        else if (self.type == LeesinViewControllerTypeReply && [self lsn_isPhotoReady_reply]) {
            return;
        }
        

        else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection && [self lsn_isPhotoReady_replyNoMissionSelection]) {
            return;
        }
        
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
            }
        }
    } else     if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
        
        if (self.type == LeesinViewControllerTypeReply && [self lsn_isMissionReady_reply]) {
            return;
        }
        
        LeesinMissionCell *cell = [self lsn_getSubviewAsClass:[LeesinMissionCell class] fromView:view];
        PIEPageVM* vm = [_sourceMissions objectAtIndex:index];
        if (cell.selected) {
            cell.selected = NO;
            vm.selected = NO;
            _selectedIndexOfMission = NSNotFound;
        } else {
            if (_selectedIndexOfMission == NSNotFound) {
                cell.selected = YES;
                vm.selected = YES;
                _selectedIndexOfMission = index;
            }
        }
    }
    
    [self updateBottomBar];

}
- (void)togglePreviewBar {
    
    if ([self.previewBar isSourceEmpty]) {
        if (self.isPreviewShown == NO) {
            return;
        }
        //hide
        [self.previewBarMarginBC setOffset:38];
        self.isPreviewShown = NO;
    } else {
        //show or stay still
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


- (void)updateBottomBar {
    
    if (!self.bottomBar.label_confirmedCount.hidden) {
        self.bottomBar.label_confirmedCount.text = [NSString stringWithFormat:@"%zd",self.selectedAssets.count];
    }
    
    
    if (self.type == LeesinViewControllerTypeAsk) {
        if ([self lsn_isPhotosReady_ask]) {
             self.bottomBar.rightButtonType = LeesinBottomBarRightButtonTypeCancelEnable;
        } else {
            self.bottomBar.rightButtonType = self.selectedAssets.count > 0 ? LeesinBottomBarRightButtonTypeConfirmEnable:LeesinBottomBarRightButtonTypeConfirmDisable;
        }
    }
    
    else if (self.type == LeesinViewControllerTypeReply) {
        
        if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
            if ([self lsn_isPhotoReady_reply]) {
                self.bottomBar.rightButtonType = LeesinBottomBarRightButtonTypeCancelEnable;
            } else {
                self.bottomBar.rightButtonType = self.selectedAssets.count > 0 ? LeesinBottomBarRightButtonTypeConfirmEnable:LeesinBottomBarRightButtonTypeConfirmDisable;
            }
        }
        
        else if (self.bar.buttonType == LeesinTextInputBarButtonTypeMission) {
            
            if ([self lsn_isMissionReady_reply]) {
                self.bottomBar.rightButtonType = self.bottomBar.rightButtonType = LeesinBottomBarRightButtonTypeCancelEnable;
            } else {
                self.bottomBar.rightButtonType = self.selectedIndexOfMission != NSNotFound ? LeesinBottomBarRightButtonTypeConfirmEnable:LeesinBottomBarRightButtonTypeConfirmDisable;
            }
        }
    }
    
    
    else if (self.type == LeesinViewControllerTypeReplyNoMissionSelection) {
        
        if (self.bar.buttonType == LeesinTextInputBarButtonTypePHAsset) {
            if ([self lsn_isPhotoReady_replyNoMissionSelection]) {
                self.bottomBar.rightButtonType = LeesinBottomBarRightButtonTypeCancelEnable;
            } else {
                self.bottomBar.rightButtonType = self.selectedAssets.count > 0 ? LeesinBottomBarRightButtonTypeConfirmEnable:LeesinBottomBarRightButtonTypeConfirmDisable;
            }
        }
    }

}


@end
