//
//  ActivateViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "ActivateViewController.h"
#import "ActivateSuccessViewController.h"
#import "ActivateSuccessJackpotViewController.h"

@interface ActivateViewController () <MDHTMLLabelDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *activateButton;

@property (weak, nonatomic) IBOutlet MDHTMLLabel *helpLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfActivateCode;
@property (weak, nonatomic) IBOutlet UIView *codeContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivBackground;

@property (strong, nonatomic) NSDictionary *successDict;
@property (strong, nonatomic) MFMailComposeViewController *mailer;

@property (assign, nonatomic) BOOL isClubReferralCode;
@property (assign, nonatomic) BOOL isClubMembershipCode;
@property (assign, nonatomic) BOOL force;

@property (strong, nonatomic) NSString *code;

- (IBAction)activateButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStyling];
}


#pragma mark - Button Actions
- (IBAction)activateButtonPressed:(id)sender {
    [self.view endEditing:YES];

    if (self.tfActivateCode.text.length != 0) {
        
        self.code = self.tfActivateCode.text;
        [self activateCode:self.tfActivateCode.text];
        
    } else {
        
        [self showEmptyError:@"You need to enter a code." buttonTitle:@"OK" window:YES];
    }
}

- (void)activateCode:(NSString*)code{
    
    [self showProcessing:YES];
    [GiftController activateGiftCardWithCode:code force:self.force withSuccess:^(NSDictionary *dictionary) {
        
        [self showSuccess:YES];
        self.tfActivateCode.text = @"";
        
        self.successDict = dictionary;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self hidePopView];
            
            if ([self.successDict[@"type"] isEqualToString:@"ActivationCode"]) {
                
                [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:YES with:^(NSArray *array, NSError *error) {
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                    }
                }];
            }
            
            if ([self.successDict[@"type"] isEqualToString:@"JackpotTicketCode"]) {
                
                ActivateSuccessJackpotViewController *jackpotView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateSuccessJackpotView"];
                jackpotView.successDict = self.successDict;
                [self.navigationController pushViewController:jackpotView animated:YES];
                
                
            } else if ([self.successDict[@"type"] isEqualToString:@"ClubMembershipActivationCode"]) {
                
                [UserController getUserProfileWithCompletion:nil];
                
                UIViewController *viewController = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribePaySuccessView"];
                [self.navigationController pushViewController:viewController animated:YES];
                
                
            } else {
                
                ActivateSuccessViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateSuccessView"];
                successView.successDict = self.successDict;
                
                [self.navigationController pushViewController:successView animated:YES];
                
            }
            
        });
        
        
    } failure:^(NSError *error) {
        
        if (error.code == 417) {
            [AppDelegate logOut];
            return ;
        }
        
        
        self.tfActivateCode.text = @"";
        
        if (error.code == 415) {
            
            [self showEmptyError:[error localizedDescription] buttonTitle:@"CLUB SUBSCRIBE" window:YES];
            self.popView.btnCancel.hidden = NO;
            [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
            
            self.isClubReferralCode = YES;
            
        } else if (error.code == 418){
            
            [self showEmptyError:[error localizedDescription] buttonTitle:@"YES" window:YES];
            self.popView.btnCancel.hidden = NO;
            [self.popView.btnCancel setTitle:@"No, cancel" forState:UIControlStateNormal];
            
            self.isClubMembershipCode = YES;
            
        } else {
            
            [self showFail:[error localizedDescription] buttonTitle:@"TRY AGAIN" window:YES];
        }
        
    }];
}


#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    
    [super okButtonClicked];
    
    if (self.isClubReferralCode) {
        
        self.isClubReferralCode = NO;
        
        UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (self.isClubMembershipCode){
        
        self.isClubMembershipCode = NO;
        self.force = YES;
        
        [self activateCode:self.code];
    }
}

- (void)cancelButtonClicked{
    
    [super cancelButtonClicked];
    
    self.isClubReferralCode = NO;
    self.isClubMembershipCode = NO;
    self.force = NO;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email Us" handler:^{
            
            self.mailer = [[MFMailComposeViewController alloc] init];
            self.mailer.mailComposeDelegate = self;
            [self.mailer setSubject: @"Help with code."];
            [self.mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            self.mailer.navigationBar.tintColor = [UIColor whiteColor];
            
            [self presentViewController:self.mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook Us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.tfActivateCode becomeFirstResponder];
    [self.view endEditing:YES];

    return YES;
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.helpLabel.delegate = self;
    self.helpLabel.htmlText = @"<a href='help'><u>Need help?</u></a>";
    self.helpLabel.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
    self.helpLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    self.codeContainerView.layer.cornerRadius = 5.0f;
    self.codeContainerView.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.10f].CGColor;
    self.codeContainerView.layer.borderWidth = 1.0f;
    self.codeContainerView.layer.masksToBounds = YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mar - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    if (result == MFMailComposeResultSent) {
        [self showSuccess:@"Email Sent!" window:@"OK"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidePopView];
            
        });
        
    }
    
    [self.mailer dismissViewControllerAnimated:YES completion:nil];
}

@end
