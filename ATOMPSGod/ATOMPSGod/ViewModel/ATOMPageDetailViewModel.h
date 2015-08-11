
#import <Foundation/Foundation.h>
#import "ATOMFollowPageViewModel.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHotDetailPageViewModel.h"

@interface ATOMPageDetailViewModel : NSObject
@property (nonatomic, assign) NSInteger pageID;
//type 1 求P ，2 作品
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSString *pageImageURL;
@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImage *pageImage;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;

@property (nonatomic, strong) NSMutableArray *labelArray;


-(void)setCommonViewModelWithAsk:(ATOMAskPageViewModel*)model;
//-(void)setCommonViewModelWithProduct:(ATOMHotDetailPageViewModel*)model;
-(void)setCommonViewModelWithFollow:(ATOMFollowPageViewModel*)model;
-(void)setCommonViewModelWithHotDetail:(ATOMHotDetailPageViewModel*)model;

- (void)toggleLike;
-(ATOMAskPageViewModel*)generateAskPageViewModel;

@end
