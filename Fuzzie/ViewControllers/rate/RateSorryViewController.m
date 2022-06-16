//
//  RateSorryViewController.m
//  Fuzzie
//
//  Created by mac on 8/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "RateSorryViewController.h"

@interface RateSorryViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MFMailComposeViewController *mailer;

@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

@end

@implementation RateSorryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CommonUtilities setView:self.btnEmail withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnFacebook withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)emailButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    if ([MFMailComposeViewController canSendMail]) {
        
        self.mailer = [[MFMailComposeViewController alloc] init];
        self.mailer.mailComposeDelegate = self;
        [self.mailer setSubject: @"Feedback for Fuzzie"];
        [self.mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
        self.mailer.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:self.mailer animated:YES completion:nil];
    }
    
}

- (IBAction)facebookButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mar - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    
    [self.mailer dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
