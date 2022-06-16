//
//  RateThanksViewController.m
//  Fuzzie
//
//  Created by mac on 8/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "RateThanksViewController.h"

@interface RateThanksViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIButton *laterButton;

@end

@implementation RateThanksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnSure withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.laterButton withCornerRadius:5.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sureButtonPressed:(id)sender {
    
    [UserController dontSendRateNotification];
    
    [FZData sharedInstance].isShowingRatePage = false;
    
    NSString *appstoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id969637423?action=write-review"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appstoreUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)laterButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    [UserController sendRateNotificationAfterDay:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
}


@end
