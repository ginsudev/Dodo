#import <UIKit/UIKit.h>
#import <libgscommon/libgsutils.h>
#import <PeterDev/libpddokdo.h>
#import <AVKit/AVKit.h>
#include "MediaRemote.h"
#include "DarwinNotificationsManager.h"

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

#pragma mark - Fetching media data
@interface MRArtwork : NSObject
@property (copy, nonatomic) NSData *imageData;
@end

@interface MRContentItemMetadata : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * trackArtistName;
@end

@interface MRContentItem : NSObject
@property (retain, nonatomic) MRArtwork *artwork;
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
- (NSString *)nameOfPickedRoute;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (void)setNowPlayingInfo:(id)arg1;
@end

@interface AVRoutePickerView (Private)
- (void)_routePickerButtonTapped:(id)arg1;
@end

// MARK: - Alarm
@interface MTAlarm : NSObject
@property (nonatomic,readonly) NSUUID * alarmID;
@property (nonatomic,readonly) NSURL * alarmURL;
@property (nonatomic,readonly) NSDate * nextFireDate;
@property (nonatomic,readonly) NSString * displayTitle;
@property (assign,getter=isEnabled,nonatomic) BOOL enabled;
@end

@interface MTAlarmCache : NSObject
@property (nonatomic,retain) NSMutableArray * orderedAlarms;
@property (nonatomic,retain) NSMutableArray * sleepAlarms;
@property (nonatomic,retain) MTAlarm * nextAlarm;
@end

@interface MTAlarmManager : NSObject
@property (nonatomic,retain) MTAlarmCache * cache;
@end

@interface SBScheduledAlarmObserver : NSObject
+ (instancetype)sharedInstance;
@end

// MARK: - DND
@interface DNDState : NSObject
@property (getter=isActive,nonatomic,readonly) BOOL active;
@end

@interface DNDStateUpdate : NSObject
@property (nonatomic,copy,readonly) DNDState * state;
@end

@interface DNDNotificationsService : NSObject
@end

// MARK: - Flashlight
@interface AVFlashlight : NSObject
+ (BOOL)hasFlashlight;
@end

@interface SBUIFlashlightController : NSObject
+ (instancetype)sharedInstance;
- (void)turnFlashlightOnForReason:(id)arg1;
- (void)turnFlashlightOffForReason:(id)arg1;
- (void)warmUp;
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
+ (BOOL)_hasHomeButton;
+ (BOOL)currentIsIPad;
@end
