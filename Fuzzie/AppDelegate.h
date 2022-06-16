//
//  AppDelegate.h
//  Fuzzie
//
//  Created by Nur Iman Izam thman on 16/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZPopView.h"
@import UserNotifications;
@import CoreLocation;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FZPopViewDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSTimer *redeemTimer;

@property (strong, nonatomic) FZPopView *pop;

@property (nonatomic) BOOL videoIsInFullscreen;

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (AppDelegate*)sharedAppDelegate;

+ (void)logOut;
+ (void)updateWalletBadge;

- (void)startLocationService;
- (void)stopLocationService;

@end

