//
//  FZTabBarViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTabBarItemShop,
    kTabBarItemNearBy,
    kTabBarItemClub,
    kTabBarItemWallet,
    kTabBarItemMe
} kTabBarItem;

@interface FZTabBarViewController : UITabBarController

@property (assign, nonatomic) BOOL showNotificationSetting;

@end
