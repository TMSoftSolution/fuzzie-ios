//
//  ClubOfferRedeemViewController.m
//  Fuzzie
//
//  Created by joma on 6/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferRedeemViewController.h"
#import "FZWebView2Controller.h"
#import "ClubOfferRedeemSuccessViewController.h"

@interface ClubOfferRedeemViewController ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *pinTextFields;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandNamee;
@property (weak, nonatomic) IBOutlet UILabel *lbValidDate;
@property (weak, nonatomic) IBOutlet UILabel *lbAvailable;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;

@end

@implementation ClubOfferRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3"];
    
    for (UITextField *textField in self.pinTextFields) {
        textField.layer.cornerRadius = 5.0f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 1.0f;
        textField.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.1f].CGColor;
    }
    
    self.lbOfferName.text = self.offer[@"name"];
    self.lbBrandNamee.text = self.clubStore[@"brand_name"];
    self.lbAvailable.text = self.offer[@"availability_options"][@"available_slots"];
    self.lbValidDate.text = [NSString stringWithFormat:@"Valid till %@", [[GlobalConstants redeemStartEndFormatter] stringFromDate:[[GlobalConstants dateApiFormatter] dateFromString:self.offer[@"end_date"]]]];
}

- (void)submitPinIfCompleted {
    
    BOOL completed = YES;
    NSString *marchantPin = @"";
    for (UITextField *textField in self.pinTextFields) {
        if (textField.text.length == 0) {
            completed = NO;
        } else {
            marchantPin = [marchantPin stringByAppendingString:textField.text];
        }
    }
    
    if (!completed) return;

    [self.view endEditing:YES];
    [self showProcessing:YES];
    
    [ClubController offerRedeem:self.offer[@"id"] pin:marchantPin completion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        if (dictionary) {
            
            ClubOfferRedeemSuccessViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferRedeemSuccessView"];
            successView.dict = dictionary;
            [self.navigationController pushViewController:successView animated:YES];
            
        }
        
        if (error) {
            
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            // Clear TextFields
            for (UITextField *textField in self.pinTextFields) {
                textField.text = @"";
            }
            
            [self showEmptyError:[error localizedDescription] buttonTitle:@"TRY AGAIN" window:YES];
        }
    }];
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = finalString;
    
    if (finalString.length > 0) {
        NSInteger tag = textField.tag;
        
        if (tag != 3) {
            UITextField *nextTextField = self.pinTextFields[tag+1];
            [nextTextField becomeFirstResponder];
        }
        
        [self submitPinIfCompleted];
    }
    
    return NO;
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [self hidePopView];
    [self.pinTextFields[0] becomeFirstResponder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
