//
//  ClubOfferOnlineRedeemViewController.m
//  Fuzzie
//
//  Created by joma on 10/1/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferOnlineRedeemViewController.h"
#import "FZWebView2Controller.h"

@interface ClubOfferOnlineRedeemViewController ()

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandNamee;
@property (weak, nonatomic) IBOutlet UILabel *lbValidDate;
@property (weak, nonatomic) IBOutlet UILabel *lbAvailable;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)copyButtonPressed:(id)sender;

@end

@implementation ClubOfferOnlineRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}


- (void)setStyling{
    
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3"];

    self.lbOfferName.text = self.offer[@"name"];
    self.lbBrandNamee.text = self.clubStore[@"brand_name"];
    self.lbAvailable.text = self.offer[@"availability_options"][@"available_slots"];
    self.lbValidDate.text = [NSString stringWithFormat:@"Valid till %@", [[GlobalConstants redeemStartEndFormatter] stringFromDate:[[GlobalConstants dateApiFormatter] dateFromString:self.offer[@"end_date"]]]];
    
    [CommonUtilities setView:self.codeView withCornerRadius:5.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
    [CommonUtilities setView:self.btnGo withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:5.0f];
    self.btnCopy.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{
        
        FZWebView2Controller *webView2Controller = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
        webView2Controller.URL = @"http://fuzzie.com.sg/faq.html";
        webView2Controller.titleHeader = @"FAQ";
        [self.navigationController pushViewController:webView2Controller animated:YES];
        
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                
                if (result == MFMailComposeResultSent) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Email sent!", nil)];
                }
                
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)copyButtonPressed:(id)sender {
}
@end
