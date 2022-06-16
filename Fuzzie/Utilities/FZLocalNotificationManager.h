//
//  FZLocalNotificationManager.h
//  Fuzzie
//
//  Created by mac on 10/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UserNotifications;

@interface FZLocalNotificationManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)checkScheduledNotification:(NSString*)notiId;
- (void)removePendingLiveDrawNotification:(NSArray*)identifiers;
- (void)scheduleLiveDrawNotification;
- (void)scheduleJackpotRemainderNotification;
- (void)scheduleMyBirthdayNotification;
- (void)scheduleFriendsBirthdayNotification;

@end
