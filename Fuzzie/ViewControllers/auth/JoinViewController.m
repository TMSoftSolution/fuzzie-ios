//
//  JoinViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "JoinViewController.h"
#import "EmailSignUpViewController.h"

@interface JoinViewController () <MDHTMLLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *facebookContainerView;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *loginLabel;

- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
             
             [self showCrafting:YES];
             [UserController loginUserWithFacebookToken:[FBSDKAccessToken currentAccessToken].tokenString withSuccess:^(FZUser *user) {
                 
                 [self hidePopView];
                 // We detect signed up users if their phone is already set.
                 if (user.phone) {
      
                     UIViewController *tutoView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"TutorialView"];
                     [UIApplication sharedApplication].delegate.window.rootViewController = tutoView;
                 } else {
                     
                     EmailSignUpViewController *signUpView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"EmailSignUpView"];
                     signUpView.facebookNewUser = user;
                     [self.navigationController pushViewController:signUpView animated:YES];
                 }
                 
             } failure:^(NSError *error) {
          
                 [self showFail:[error localizedDescription] window:YES];
                 
             }];
             
         }
     }]; // End Facebook Login
}

- (IBAction)emailButtonPressed:(id)sender {
    
    UIViewController *signUpView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"EmailSignUpView"];
    [self.navigationController pushViewController:signUpView animated:YES];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {

    UIViewController *loginView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    if (!self.showCloseButton) {
        self.navigationItem.rightBarButtonItems = nil;
    }

    [CommonUtilities setView:self.facebookContainerView withBackground:[UIColor colorWithHexString:@"#4267B2"] withRadius:4.0f];
    [CommonUtilities setView:self.emailButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];  
       
    self.loginLabel.htmlText = @"Already a Fuzzie member? <a href='signin'>Sign in here</a>";
    self.loginLabel.delegate = self;
    self.loginLabel.linkAttributes = @{
                                       NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                       NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:self.loginLabel.font.pointSize],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
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

@end
