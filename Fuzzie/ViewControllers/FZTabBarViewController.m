//
//  FZTabBarViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZTabBarViewController.h"
#import "WalletViewController.h"
#import "MeViewController.h"
#import "JoinViewController.h"

@interface FZTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation FZTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([UserController sharedInstance].currentUser) return YES;
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        
        if ([[navigationController.viewControllers firstObject] isKindOfClass:[WalletViewController class]] ||
            [[navigationController.viewControllers firstObject] isKindOfClass:[MeViewController class]]) {
            
            JoinViewController *joinView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"JoinView"];
            joinView.showCloseButton = YES;
            UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
            [self presentViewController:joinNavigation animated:YES completion:nil];
            
            return NO;
        }
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    [FZData sharedInstance].selectedTab = tabBarController.selectedIndex;

    if (tabBarController.selectedIndex != kTabBarItemNearBy) {
        [FZData sharedInstance].filterSubCategoryIds = [[NSMutableSet alloc] init];
        [FZData sharedInstance].isSelectedStore = NO;
        [FZData sharedInstance].isSelectedList = NO;
    }
    
    if (tabBarController.selectedIndex == kTabBarItemMe) {
        
        UINavigationController *navigationController = (UINavigationController *)viewController;
        MeViewController *meViewController = (MeViewController*)[navigationController.viewControllers firstObject];
        if (!meViewController.initinalized) {
            meViewController.initinalized = true;
        }
        
    } else {
        
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemMe];
        MeViewController *meViewController = (MeViewController*)[navigationController.viewControllers firstObject];
        meViewController.initinalized = false;
    }
    
}

@end
