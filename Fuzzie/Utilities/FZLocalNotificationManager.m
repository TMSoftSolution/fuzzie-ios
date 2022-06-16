//
//  FZLocalNotificationManager.m
//  Fuzzie
//
//  Created by mac on 10/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZLocalNotificationManager.h"

@implementation FZLocalNotificationManager

+ (instancetype)sharedInstance {
    static FZLocalNotificationManager *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[FZLocalNotificationManager alloc] init];
    });
    
    return __sharedInstance;
}

- (void)scheduleLiveDrawNotification{
    
    NSDate *drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
    NSDate *now = [NSDate date];
    if (![drawTime isEarlierThan:now]) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"Jackpot live draw is starting";
        content.body = @"Join the crowd and see if you win. Good luck!";
        
        content.userInfo = @{@"notiId": NOTIFICATION_ID_JACKPOT_LIVE_DRAW};
        
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:drawTime];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                                                                          repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NOTIFICATION_ID_JACKPOT_LIVE_DRAW
                                                                              content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                DDLogError(@"%@: %@ : %@, %@",THIS_FILE,THIS_METHOD,@"Something went wrong: %@",error);
            } else{
                DDLogVerbose(@"%@: %@ : %@",THIS_FILE,THIS_METHOD,@"Jackpot Live Notification Scheduled.");
            }
        }];
    }
}

- (void) scheduleJackpotRemainderNotification{
    
    int currentTicketsCount = [[UserController sharedInstance].currentUser.currentJackpotTicketsCount intValue];
    int entitledTicketsCount = [FZData sharedInstance].ticketsLimitPerWeek;
    int reminder = entitledTicketsCount - currentTicketsCount;
    
    if (reminder > 0) {
      
        NSDate *drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:drawTime];
        triggerDate.hour = 12;
        triggerDate.minute = 0;
        
        NSDate *now = [NSDate date];
        if (![[triggerDate date] isEarlierThan:now]) {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.body = @"Jackpot live draw at 6.35pm. Get your 4D tickets ready. Good luck!";
            content.userInfo = @{@"notiId": NOTIFICATION_ID_JACKPOT_REMAINDER};
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                                                                              repeats:NO];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NOTIFICATION_ID_JACKPOT_REMAINDER
                                                                                  content:content trigger:trigger];
            
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    DDLogError(@"%@: %@ : %@, %@",THIS_FILE,THIS_METHOD,@"Something went wrong: %@",error);
                } else{
                    DDLogVerbose(@"%@: %@ : %@",THIS_FILE,THIS_METHOD,@"Jackpot Reminder Notification Scheduled.");
                }
            }];
        }
    } else{
        if ([self checkScheduledNotification:NOTIFICATION_ID_JACKPOT_REMAINDER]) {
            [self removePendingLiveDrawNotification:@[NOTIFICATION_ID_JACKPOT_REMAINDER]];
        }
    }

}

- (void) removePendingLiveDrawNotification:(NSArray*)identifiers{

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:identifiers];
}

- (BOOL)checkScheduledNotification:(NSString*)notiId{
    
    BOOL scheduled = false;
    
    NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in notifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            if ([[userInfo objectForKey:@"notiId"] isEqualToString:notiId]) {
                scheduled = true;
                break;
            }
        }
    }
    
    return scheduled;
}

- (void)scheduleMyBirthdayNotification{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    
    if (user.birthday && ![user.birthday isEqualToString:@""]) {
        
        NSDate *birthday = [[GlobalConstants dateApiFormatter] dateFromString:user.birthday];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute
                                         fromDate:[NSDate date]];
        triggerDate.month = birthday.month;
        triggerDate.day = birthday.day - 3;
        triggerDate.hour = 9;
        triggerDate.minute = 30;
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.body = @"Your birthday is in 3 days. Update your wishlist";
        content.userInfo = @{@"notiId": NOTIFICATION_ID_MY_BIRTHDAY};
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                                                                          repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NOTIFICATION_ID_MY_BIRTHDAY
                                                                              content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                DDLogError(@"%@: %@ :o %@, %@",THIS_FILE,THIS_METHOD,@"Something went wrong: %@",error);
            } else{
                DDLogVerbose(@"%@: %@ : %@",THIS_FILE,THIS_METHOD,@"My Birthday Notification Scheduled.");
            }
        }];
    }
}

- (void)scheduleFriendsBirthdayNotification{
    
    if ([FZData sharedInstance].fuzzieFriends && [FZData sharedInstance].fuzzieFriends.count > 0) {
        
        for (FZUser *user in [FZData sharedInstance].fuzzieFriends) {
            
            if (user.birthday && ![user.birthday isEqualToString:@""]) {
                
                NSDate *birthday = [[GlobalConstants dateApiFormatter] dateFromString:user.birthday];
                NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                                 components:NSCalendarUnitYear +
                                                 NSCalendarUnitMonth + NSCalendarUnitDay +
                                                 NSCalendarUnitHour + NSCalendarUnitMinute
                                                 fromDate:[NSDate date]];
                triggerDate.month = birthday.month;
                triggerDate.day = birthday.day;
                triggerDate.hour = 8;
                triggerDate.minute = 30;
                
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.body = [NSString stringWithFormat:@"Today is %@'s birthday. Send a gift instantly!", user.name];
                content.userInfo = @{@"userId": user.fuzzieId};
                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                                                                                  repeats:NO];
                
                NSString *notificationRequestId = [NSString stringWithFormat:@"%@_%@", NOTIFICATION_ID_FRIENDS_BIRTHDAY, user.fuzzieId];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationRequestId
                                                                                      content:content trigger:trigger];
                
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        DDLogError(@"%@: %@ :o %@, %@",THIS_FILE,THIS_METHOD,@"Something went wrong: %@",error);
                    } else{
                        DDLogVerbose(@"%@: %@ : %@",THIS_FILE,THIS_METHOD,@"Friends Birthday Notification Scheduled.");
                    }
                }];
                
            }
        }
    }
}

@end
