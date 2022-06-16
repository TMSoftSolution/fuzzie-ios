//
//  AppDelegate.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 16/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//


#import "InviteFriendsViewController.h"
#import "FZTabBarViewController.h"
#import "FriendsListViewController.h"
#import "MeViewController.h"
#import "UserProfileViewController.h"
#import "GiftBoxViewController.h"
#import "RateExperienceViewController.h"
#import "JackpotLiveNotiViewController.h"
#import "JackpotLiveDrawViewController.h"
#import "JackpotHomePageViewController.h"
#import "ShopViewController.h"
#import "RedPacketHistoryViewController.h"
#import "RedPacketSentDetailsViewController.h"
#import "WalletViewController.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate{
    
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;
    
    [iVersion sharedInstance].checkAtLaunch = NO;
    [iVersion sharedInstance].groupNotesByVersion = NO;
    [iVersion sharedInstance].updateAvailableTitle = @"Update Fuzzie";
    [iVersion sharedInstance].bodyText = @"The Bear has made some important improvements. Kindly update your app to continue.";
    [iVersion sharedInstance].downloadButtonLabel = @"Update Now";
    [iVersion sharedInstance].appStoreID = 969637423;
    [iVersion sharedInstance].applicationBundleID = @"sg.com.fuzzie.client-prod";
    [iVersion sharedInstance].updatePriority = iVersionUpdatePriorityMedium;
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [Fabric with:@[CrashlyticsKit]];
    
    [self setGlobalStyling];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    if ([APIClient sharedInstance].accessToken && [UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.phone) {
        
        self.window.rootViewController = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"TabBarView"];
        
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
        }];
        [PaymentController getPaymentMethodsWithCompletion:nil];
        
    }
    
    if ([self.window.rootViewController isKindOfClass:[FZTabBarViewController class]]) {
        
        [self checkAppStoreVersion];

    }
    
    [self loadHTTPCookies];
    
    [GMSServices provideAPIKey:GOOGLE_MAP_KEY];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    return YES;
}

- (void)checkAppStoreVersion {
    
    [[APIClient sharedInstance] GET:@"app/version/ios" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE, THIS_METHOD, responseObject);
        
        if (responseObject && responseObject[@"force"]) {
            if ([responseObject[@"force"] isEqualToString:@"true"]) {
                
                if (responseObject[@"version"]) {
                    
                    NSNumber *appStoreVersion = responseObject[@"version"];
                    NSNumber *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                    
                    if ([appStoreVersion intValue] > [version intValue]) {
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Rate" bundle:nil];
                        UIViewController *forceUpdateView = [storyboard instantiateViewControllerWithIdentifier:@"ForceUpdateView"];
                        
                        [self.window.rootViewController presentViewController:forceUpdateView animated:YES completion:nil];
                    }
                    
                }
   
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveHTTPCookies];
    
    if ([self.window.rootViewController isKindOfClass:[FZTabBarViewController class]]) {
        FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
        UINavigationController *navController = [rootController selectedViewController];
        if ([navController.topViewController isKindOfClass:[JackpotHomePageViewController class]]
            || [navController.topViewController isKindOfClass:[ShopViewController class]]) {
            [FZData sharedInstance].isInBackground = true;
        } else{
            [FZData sharedInstance].isInBackground = false;
        }
    }

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self loadHTTPCookies];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotification:[NSNotification notificationWithName:@"appDidEnterForeground" object:nil]];

    if ([FZData sharedInstance].enableJackpot && [FZData sharedInstance].isInBackground) {
        [FZData sharedInstance].isInBackground = false;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        NSDate *drawTime = [dateFormatter dateFromString:[FZData sharedInstance].jackpotDrawTime];
        NSDate *now = [NSDate date];
        if ([drawTime secondsFrom:now] <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_RELOAD_HOME_DATA object:nil];
        }
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.-
    [self saveHTTPCookies];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([[url scheme] isEqualToString:@"fuzzie"]) {
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        
        NSString *queryId = [self valueForKey:@"id" fromQueryItems:queryItems];
        NSString *type = [self valueForKey:@"type" fromQueryItems:queryItems];
        
        if (queryId && type) {
            
            if ([type isEqualToString:@"gift"]) {
                
                [self confirmGift:queryId];
                
            } else if ([type isEqualToString:@"red_packet"]){
                
                [self confirmReceivedRedPacket:queryId];
            }
        }
        
    }
    
    BOOL netsHandled = [PaymentRequestManager handleOpenURLWithAppDelegate:self
                                                                        url:url];
    
    BOOL facebookHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];

    return netsHandled || facebookHandled;
}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"TOKEN%@", hexToken);
    if ([APIClient sharedInstance].accessToken) {
        [UserController saveToken:hexToken withCompletion:^(NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_REFRESH_SHOTS object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [self handleRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    if (notification) {
        NSString *notiId = notification.request.identifier;
        if (notiId) {
            DDLogVerbose(@"%@ %@ %@", THIS_FILE, THIS_METHOD, notiId);
            
            if ([notiId isEqualToString:NOTIFICATION_ID_JACKPOT_LIVE_DRAW]) {
                
                if (![FZData sharedInstance].isLiveDraw) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_LIVE_DRAW_START object:nil];

                    JackpotLiveNotiViewController *availableView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLiveNotiView"];
                    [self.window.rootViewController presentViewController:availableView animated:YES completion:nil];
                }

            }
        }
        
        NSDictionary *userInfo = notification.request.content.userInfo;
        if (userInfo) {
            [self handleRemoteNotification:userInfo];
        }

    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    if (response) {
        NSString *notiId = response.notification.request.identifier;
        if (notiId) {
            DDLogVerbose(@"%@ %@ %@", THIS_FILE, THIS_METHOD, notiId);
            
            if ([notiId isEqualToString:NOTIFICATION_ID_JACKPOT_LIVE_DRAW]) {
                
                if ([self.window.rootViewController isKindOfClass:[FZTabBarViewController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_LIVE_DRAW_START object:nil];
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    UINavigationController *navController = [rootController selectedViewController];
                    
                    JackpotLiveDrawViewController *jackpotLiveView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLiveDrawView"];
                    jackpotLiveView.hidesBottomBarWhenPushed = YES;
                    [navController pushViewController:jackpotLiveView animated:YES];
                    
                }

            } else if ([notiId isEqualToString:NOTIFICATION_ID_MY_BIRTHDAY]) {
                
                if ([self.window.rootViewController isKindOfClass:[FZTabBarViewController class]]) {
                    
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    
                    UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
                    [navController popToRootViewControllerAnimated:NO];
                    
                    [rootController setSelectedIndex:kTabBarItemMe];
                    UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemMe];
                    
                    MeViewController *meView = [[navController1 viewControllers] objectAtIndex:0];
                    meView.selectWishlist = true;
                }
                
            } else if ([notiId rangeOfString:NOTIFICATION_ID_FRIENDS_BIRTHDAY].location != NSNotFound) {
                
                UNNotificationContent *content = response.notification.request.content;
                if (content && content.userInfo) {
                    
                    NSDictionary *userInfo = content.userInfo;
                    if (userInfo[@"userId"]) {
                        
                        NSString *userId = userInfo[@"userId"];
                        
                        if ([self.window.rootViewController isKindOfClass:[FZTabBarViewController class]]) {
                            
                            FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                            UINavigationController *navController = [rootController selectedViewController];
                            
                            UserProfileViewController *vc = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                            vc.userId = userId;
                            vc.selectWishList = false;
                            vc.hidesBottomBarWhenPushed = YES;
                            [navController pushViewController:vc animated:YES];
                            
                            
                        }
                    }
                }
            }
            
            NSDictionary *userInfo = response.notification.request.content.userInfo;
            if (userInfo) {
                [self handleRemoteNotification:userInfo];
            }
        }
    }
}

- (void)handleRemoteNotification:(NSDictionary*)userInfo{
    
    NSLog(@"Data Message: %@", userInfo);
    if ([UserController sharedInstance].currentUser) {
        
        NSString *redirect_to;
        if ([userInfo objectForKey:@"redirect_to"]) {
            redirect_to = [userInfo objectForKey:@"redirect_to"];
            
            if ([redirect_to isEqualToString:@"referrals"]) {
                
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    UINavigationController *navController = [rootController selectedViewController];
                    
                    InviteFriendsViewController *vc = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"InviteFriendsView"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [navController pushViewController:vc animated:YES];
                }
            } else if([redirect_to isEqualToString:@"friends"]){
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    UINavigationController *navController = [rootController selectedViewController];
                    
                    FriendsListViewController *vc = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"FriendsListView"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [navController pushViewController:vc animated:YES];
                }
                
            } else if([redirect_to isEqualToString:@"wishlist"]){
                
                NSString *userId = [userInfo objectForKey:@"user_id"];
                
                if (userId) {
                    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                        FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                        UINavigationController *navController = [rootController selectedViewController];
                        
                        UserProfileViewController *vc = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
                        vc.userId = userId;
                        vc.selectWishList = true;
                        vc.hidesBottomBarWhenPushed = YES;
                        [navController pushViewController:vc animated:YES];
                    }
                    
                    
                } else{
                    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                        FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                        [rootController setSelectedIndex:kTabBarItemMe];
                        UINavigationController *navController = [[rootController viewControllers] objectAtIndex:kTabBarItemMe];
                        if (!navController.beingPresented) {
                            [navController popToRootViewControllerAnimated:YES];
                        }
                        MeViewController *meView = [[navController viewControllers] objectAtIndex:0];
                        meView.selectWishlist = true;
                        
                    }
                }
                
            } else if([redirect_to isEqualToString:@"giftbox_for_friends"]){
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    
                    UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
                    [navController popToRootViewControllerAnimated:NO];
                    
                    [rootController setSelectedIndex:kTabBarItemWallet];
                    UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemWallet];
                    
                    GiftBoxViewController *giftBoxView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftBoxView"];
                    giftBoxView.fromDelivery = true;
                    giftBoxView.hidesBottomBarWhenPushed = YES;
                    [navController1 pushViewController:giftBoxView animated:YES];
                    
                }
            } else if ([redirect_to isEqualToString:@"rate_app"]){
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    if (![FZData sharedInstance].isShowingRatePage) {
                        [FZData sharedInstance].isShowingRatePage = true;
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Rate" bundle:nil];
                        RateExperienceViewController *rateView = [storyboard instantiateViewControllerWithIdentifier:@"RateExperienceView"];
                        [self.window.rootViewController presentViewController:rateView animated:YES completion:nil];
                    }
                    
                }
            } else if ([redirect_to isEqualToString:@"lucky_packets"]){
                
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    
                    FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
                    
                    UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
                    [navController popToRootViewControllerAnimated:NO];
                    
                    [rootController setSelectedIndex:kTabBarItemWallet];
                    UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemWallet];
                    
                    RedPacketHistoryViewController *historyView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
                    historyView.hidesBottomBarWhenPushed = YES;
                    
                    NSString *bundleId = [userInfo objectForKey:@"red_packet_bundle_id"];
                    if (bundleId) {
                        
                        historyView.fromDelivery = true;
                        
                        RedPacketSentDetailsViewController *sentDetailsView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketSentDetailsView"];
                        sentDetailsView.bundleId = bundleId;
                        sentDetailsView.hidesBottomBarWhenPushed = YES;
                        
                        WalletViewController *walletView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"WalletView"];
                        NSArray *viewControllers = [NSArray arrayWithObjects:walletView, historyView, sentDetailsView, nil];
                        [navController1 setViewControllers:viewControllers animated:YES];
                        
                        
                    } else {
                        
                        [navController1 pushViewController:historyView animated:YES];
                    }
                    
                }
            }
        }
        
    }
}

- (void)setGlobalStyling {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                             NSFontAttributeName: [UIFont fontWithName:FONT_NAME_BLACK size:15.0f] }];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class], [UIToolbar class]]] setTintColor:[UIColor whiteColor]];
     [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:14.0f]} forState:UIControlStateNormal];
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"FF4B4D"]];
    [[UITabBar appearance] setTranslucent:NO];
    
    [UITextView appearance].linkTextAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithHexString:HEX_COLOR_RED] };
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setFont:[UIFont fontWithName:FONT_NAME_REGULAR size:14.0f]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
}

-(void)loadHTTPCookies
{
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

-(void)saveHTTPCookies
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logOut{
    [UserController sharedInstance].currentUser = nil;
    [PaymentController sharedInstance].paymentMethods = nil;
    [APIClient sharedInstance].accessToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN_KEY];
    [FZData resetSharedInstance];
    
    UIViewController *loginView = [[GlobalConstants mainStoryboard] instantiateInitialViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = loginView;
}

+ (void)updateWalletBadge{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    
    if (user) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            
            int giftCardCounts = 0;
            int redPacketCounts = 0;
            int ticketCounts = 0;
            int badgeCounts = 0;
            
            if (user.unOpenedActiveGiftCount) {
                giftCardCounts = user.unOpenedActiveGiftCount.intValue;
            }
            
            if (user.unOpenedRedPacketCount) {
                redPacketCounts = user.unOpenedRedPacketCount.intValue;
            }
            
            if (user.unOpenedTicketCount) {
                ticketCounts = user.unOpenedTicketCount.intValue;
            }
            
            badgeCounts = giftCardCounts + redPacketCounts + ticketCounts;
            
            FZTabBarViewController *rootController = (FZTabBarViewController*) window.rootViewController;
            
            if (badgeCounts > 0) {
                [rootController.tabBar.items[3] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCounts]];

            } else{
                [rootController.tabBar.items[3] setBadgeValue:NULL];
            }
        
        }
    }

}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (void)confirmGift:(NSString *)giftId{
    
    if ([UserController sharedInstance].currentUser) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            
            FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
            
            UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
            [navController popToRootViewControllerAnimated:NO];
            
            [rootController setSelectedIndex:kTabBarItemWallet];
            UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemWallet];
            
            GiftBoxViewController *giftBoxView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftBoxView"];
            giftBoxView.fromDelivery = false;
            giftBoxView.hidesBottomBarWhenPushed = YES;
            [navController1 pushViewController:giftBoxView animated:YES];
        }
        
        [GiftController addGiftedGift:giftId withCompletion:^(NSError *error) {
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                } else if(error.code == 401 || error.code == 403){
                    [self showPop:error.localizedDescription];
                }
            } else{
                
                [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                }];
            }
            
        }];
    }
}

- (void)confirmReceivedRedPacket:(NSString*)redPacketId{
    
    if ([UserController sharedInstance].currentUser) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            
            [RedPacketController confirmReceivedRedPacket:redPacketId completion:^(NSDictionary *dictionary, NSError *error) {
                
                if (error) {
                    
                    if (error.code == 417) {
                        [AppDelegate logOut];
                    } else {
                        [self showPop:error.localizedDescription];
                    }
                    
                }
                
                if(dictionary) {
      
                    [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
                        [AppDelegate updateWalletBadge];
                    }];
                    
                    [RedPacketController getReceivedRedPackets:^(NSArray *array, NSError *error) {
                        
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVED_RED_PACKETS_REFRESHED object:nil];
                        }
                        
                    }];
                    
                }
                
            }];
            
            FZTabBarViewController *rootController = (FZTabBarViewController*) self.window.rootViewController;
            
            UINavigationController *navController = [[rootController viewControllers] objectAtIndex:[FZData sharedInstance].selectedTab];
            [navController popToRootViewControllerAnimated:NO];
            
            [rootController setSelectedIndex:kTabBarItemWallet];
            UINavigationController *navController1 = [[rootController viewControllers] objectAtIndex:kTabBarItemWallet];
            
            RedPacketHistoryViewController *historyView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
            historyView.hidesBottomBarWhenPushed = YES;
            [navController1 pushViewController:historyView animated:YES];
        }
    }
}

- (void)showPop:(NSString*)message{
    UINib *nib = [UINib nibWithNibName:@"FZPopView" bundle:nil];
    self.pop = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.pop.delegate = self;
    [self.window addSubview:self.pop];
    self.pop.frame = self.window.frame;
    [self.pop showEmptyError:message];
}

- (void)hidePop{
    [self.pop removeFromSuperview];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePop];
}

- (void)startLocationService{
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 50;
    
    if ([self.locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

}

- (void)stopLocationService{
    
    if (self.locationManager) {
        
        [self.locationManager stopUpdatingLocation];
    }

}

#pragma  mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [self startLocationService];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    NSLog(@"My Location %f-%f", location.coordinate.latitude, location.coordinate.longitude);
    
    [FZData sharedInstance].currentLocation = location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    [FZData sharedInstance].currentLocation = nil;
}

@end
