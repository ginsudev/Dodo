#import <UIKit/UIKit.h>
#import <PeterDev/libpddokdo.h>
#import <AVKit/AVKit.h>
#include "MediaRemote.h"
#include "DarwinNotificationsManager.h"

#pragma mark - Icon stuff

@interface SBHIconManager : NSObject
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)identifier;
@end

#pragma mark - Lock screen views
@interface CSCombinedListViewController : UIViewController
- (void) _updateListViewContentInset;
@end

@interface CSQuickActionsView : UIView
@end

@interface CSTeachableMomentsContainerView : UIView
@end

@interface SBDashBoardLockScreenEnvironment : NSObject
@end

@interface SBLockScreenViewControllerBase : NSObject
@end

@interface CSAdjunctItemView : UIView
@end

@interface NCNotificationStructuredListViewController : UIViewController
@property (nonatomic,readonly) CGSize effectiveContentSize;
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
@property (nonatomic,retain) NSMutableArray<MTAlarm *> * orderedAlarms;
@property (nonatomic,retain) NSMutableArray * sleepAlarms;
@property (nonatomic,retain) MTAlarm * nextAlarm;
@end

@interface MTAlarmManager : NSObject
@property (nonatomic,retain) MTAlarmCache * cache;
@end

@interface SBScheduledAlarmObserver : NSObject
+ (instancetype)sharedInstance;
@end

// MARK: - Timer
@interface MTMetrics : NSObject
+ (instancetype)_sharedPublicMetrics;
@end

@interface MTTimer : NSObject
@property (readonly, nonatomic) NSUUID *timerID;
@property (readonly, nonatomic) NSDate *fireDate;
@property (readonly, nonatomic) CGFloat remainingTime;
@end

@interface MTTimerCache : NSObject
@property (retain, nonatomic) MTTimer *nextTimer;
@end

@interface MTTimerManager : NSObject
@property (retain, nonatomic) MTTimerCache *cache;
- (instancetype)initWithMetrics:(MTMetrics *)metrics;
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

@interface HostingScrollView : UIScrollView

@end
