#import <UIKit/UIKit.h>
#import <libgscommon/libgsutils.h>
#import <libgsweather/GSWeather.h>
#import <AVKit/AVKit.h>
#include "MediaRemote.h"

#pragma mark - Icon stuff
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyUnlockDevice;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyActivateSuspended;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyPromptUnlockDevice;

struct SBIconImageInfo {
    struct CGSize size;
    double scale;
    double continuousCornerRadius;
};

@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
- (id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
- (Class)iconImageViewClassForLocation:(id)arg1 ;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
+ (instancetype)sharedInstance;
@end

@interface FBSSystemService : NSObject
+ (instancetype)sharedService;
- (void)openApplication:(NSString *)app options:(NSDictionary *)options withResult:(void (^)(void))result;
@end

#pragma mark - Lock screen views
@interface CSCombinedListViewController : UIViewController
-(void) _updateListViewContentInset;
@end

@interface CSQuickActionsView : UIView
@end

@interface CSTeachableMomentsContainerView : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface NCNotificationStructuredListViewController : UIViewController
@end

@interface SBFLockScreenDateView : UIView
@end

@interface SBFLockScreenDateViewController : UIViewController
@end

@interface SBUIProudLockIconView : UIView
@end

@interface SBUICallToActionLabel : UIView
@end

@interface CSHomeAffordanceView : UIView
@end

@interface CSPageControl : UIView
@end

@interface CSCoverSheetViewController : UIViewController
@end

#pragma mark - Checking if LS is active
@interface SBLockScreenManager : NSObject
- (BOOL)isLockScreenActive;
@end

@interface SBFLockScreenWakeAnimator : NSObject
@end

@interface SBWakeLogger : NSObject
@end

#pragma mark - Fetching media data
@interface MRContentItemMetadata : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * trackArtistName;
@property CGFloat calculatedPlaybackPosition;
@property (assign,nonatomic) double duration;
@property (assign,nonatomic) float playbackRate;
@end

@interface MRContentItem : NSObject
@property (nonatomic,copy) MRContentItemMetadata * metadata;
- (instancetype)initWithNowPlayingInfo:(NSDictionary *)nowPlayingInfo;
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

@interface SpringBoard : UIApplication
@end

@interface SBMediaController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)nowPlayingApplication;
- (BOOL)isPaused;
- (NSString *)nameOfPickedRoute;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (void)setNowPlayingInfo:(id)arg1;
@end

@interface AVRoutePickerView (Private)
-(void)_routePickerButtonTapped:(id)arg1;
@end

#ifndef SPRINGBOARDSERVICES_H_
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);
#endif

@interface SBMainSwitcherViewController : UIViewController
+ (instancetype)sharedInstanceIfExists;
- (void)addAppLayoutForDisplayItem:(id)arg1 completion:(/*^block*/id)arg2 ;
@end

@interface SBDisplayItem : NSObject
+ (instancetype)displayItemWithType:(long long)arg1 bundleIdentifier:(id)arg2 uniqueIdentifier:(id)arg3;
@end

#pragma mark - Private
@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end

@interface UIDevice (Private)
+ (BOOL)currentIsIPad;
@end
