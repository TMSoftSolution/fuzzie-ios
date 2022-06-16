//
//  RedPacketPaySuccessViewController.m
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketPaySuccessViewController.h"
#import "RedPacketDeliveryViewController.h"
#import "FZTabBarViewController.h"
#import "RedPacketHistoryViewController.h"

@interface RedPacketPaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnNow;

- (IBAction)nowButtonPressed:(id)sender;
- (IBAction)laterButtonPressed:(id)sender;

@end

@implementation RedPacketPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnNow withBackground:[UIColor whiteColor] withRadius:4.0f];
}

#pragma mark - IBAction Helper
- (IBAction)nowButtonPressed:(id)sender {
    
    RedPacketDeliveryViewController *deliveryView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketDeliveryView"];
    deliveryView.dictionary = self.successDict[@"red_packet_bundle"];
    [self.navigationController pushViewController:deliveryView animated:YES];
    
}

- (IBAction)laterButtonPressed:(id)sender {
    [self goRedPacketHistoryPage];
}

- (void)goRedPacketHistoryPage{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
        
        FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabBarController setSelectedIndex:kTabBarItemWallet];
        UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];
        RedPacketHistoryViewController *historyView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
        historyView.fromDelivery = true;
        historyView.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:historyView animated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
