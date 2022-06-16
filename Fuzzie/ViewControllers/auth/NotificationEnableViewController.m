//
//  NotificationEnableViewController.m
//  Fuzzie
//
//  Created by mac on 5/11/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "NotificationEnableViewController.h"
#import "FZTabBarViewController.h"

@interface NotificationEnableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnGetNotify;

- (IBAction)enableButtonPressed:(id)sender;
- (IBAction)disableButtonPressed:(id)sender;

@end

@implementation NotificationEnableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CommonUtilities setView:self.btnGetNotify withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enableButtonPressed:(id)sender {
    FZTabBarViewController *loggedInView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    loggedInView.showNotificationSetting = true;
    [UIApplication sharedApplication].delegate.window.rootViewController = loggedInView;
}

- (IBAction)disableButtonPressed:(id)sender {
    FZTabBarViewController *loggedInView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    loggedInView.showNotificationSetting = false;
    [UIApplication sharedApplication].delegate.window.rootViewController = loggedInView;
}
@end
