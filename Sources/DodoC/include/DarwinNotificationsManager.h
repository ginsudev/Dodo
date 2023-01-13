#import <Foundation/Foundation.h>

#ifndef DarwinNotifications_h
#define DarwinNotifications_h

@interface DarwinNotificationsManager : NSObject
@property (strong, nonatomic) id someProperty;
+ (instancetype)sharedInstance;
- (void)registerForNotificationName:(NSString *)name callback:(void (^)(void))callback;
- (void)postNotificationWithName:(NSString *)name;
- (void)unregisterForNotificationName:(NSString *)name;
@end

#endif
