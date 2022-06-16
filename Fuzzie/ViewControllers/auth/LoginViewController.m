//
//  LoginViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "LoginViewController.h"
#import "EmailSignUpViewController.h"
#import "VerificationCodeViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *facebookContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *phonePrefixLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;

- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setStyling];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

#pragma mark - Button Actions

- (IBAction)facebookButtonPressed:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends",@"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         if (error) {
            
             [self showFail:[error localizedDescription] window:YES];
         } else if (result.isCancelled) {
             
         } else {
             
             [self showProcessing:YES];
             [UserController loginUserWithFacebookToken:[FBSDKAccessToken currentAccessToken].tokenString withSuccess:^(FZUser *user) {
                 
                 // We detect signed up users if their phone is already set.
                 if (user.phone) {
                     [self showSuccess:YES];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         
                         [self hidePopView];
                         [self goHomeView];
                         
                     });
                 } else {
                     [self hidePopView];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         
                         EmailSignUpViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailSignUpView"];
                         signUpView.facebookNewUser = user;
                         [self.navigationController pushViewController:signUpView animated:YES];
                     });

                 }
                 
             } failure:^(NSError *error) {
 
                 [self showFail:[error localizedDescription] window:YES];
             }];
             
         }
     }]; // End Facebook Login
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.tfPhone.text.length == 0) {
     
        [self showEmptyError:@"Your mobile number is missing." window:YES];
        return;
        
    } else if (![CommonUtilities validatePhone:self.tfPhone.text]) {
        
        [self showEmptyError:@"Invalid mobile number." window:YES];
        return;
        
    }
    
    [self showProcessing:YES];
    
    [UserController checkPhoneRegistered:self.tfPhone.text withCompletion:^(NSError *error) {
        
        [self hidePopView];
        
        if (error) {
            
            if (error.code == 404) {
                
                [self showEmptyError:@"There's no Fuzzie account linked to this mobile number." window:YES];
                
            } else {
                
                [self showFail:[error localizedDescription] window:YES];
            }
            
            
        } else {
            
            VerificationCodeViewController *verificationCodeView = (VerificationCodeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"VerificationCodeView"];
            verificationCodeView.phone = self.tfPhone.text;
            [self.navigationController pushViewController:verificationCodeView animated:YES];
        }
     
    }];
    
}

- (void)goHomeView{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_VIEWED] && [[[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_VIEWED] boolValue]) {
        UIViewController *loggedInView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarView"];
        [UIApplication sharedApplication].delegate.window.rootViewController = loggedInView;
    } else{
        UIViewController *tutoView = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialView"];
        [UIApplication sharedApplication].delegate.window.rootViewController = tutoView;
    }
}

- (void)setStyling {
 
    [CommonUtilities setView:self.facebookContainerView withBackground:[UIColor colorWithHexString:@"#4267B2"] withRadius:4.0f];
    [CommonUtilities setView:self.loginButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.phonePrefixLabel withBackground:[UIColor colorWithHexString:@"#E3E3E3"] withRadius:2.0f];
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help?" style:UIBarButtonItemStylePlain target:self action:@selector(helpButtonPressed:)];
    self.navigationItem.rightBarButtonItem = helpButton;
   
}

- (IBAction)helpButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
 
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Send an email" handler:^{
            
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
    
    [actionSheet bk_addButtonWithTitle:@"Chat on Facebook" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
