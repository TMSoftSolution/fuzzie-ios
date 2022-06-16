//
//  GiftItViewController.m
//  Fuzzie
//
//  Created by mac on 6/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftItViewController.h"
@import UITextView_Placeholder;
#import "PayViewController.h"
#import "FZWebView2Controller.h"
#import "FZRedeemPopView.h"

@interface GiftItViewController () <UITextFieldDelegate, UITextViewDelegate, FZRedeemPopViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;

@property (strong, nonatomic) FZRedeemPopView *confirmView;

@property (strong, nonatomic) FZUser *user;
@property (strong, nonatomic) FZFacebookFriend *receiver;
@property (strong, nonatomic) NSString *message;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)checkOutButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;

@end

@implementation GiftItViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserController sharedInstance].currentUser;
    self.receiver = [[FZFacebookFriend alloc] init];
    
    [self setStyling];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttn Action

- (IBAction)backButtonPressed:(id)sender {
    if (self.receiver.name.length != 0 || self.message.length > 0) {
         [self showConfirmWindow];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (IBAction)checkOutButtonPressed:(id)sender {

    PayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"PayView"];
    payView.brandArray = @[self.brand];
    payView.itemArray = @[self.giftDict];
    payView.gifted = true;
    payView.message = self.message;
    payView.receiver = self.receiver;
    
    [self.navigationController pushViewController:payView animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our Gifting FAQ" handler:^{
        [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":@"http://fuzzie.com.sg/faq.html#gifting",@"title":@"FAQ"}];
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

- (IBAction)infoButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    [self showError:@"We will display the receiver's name with what you enter here, for example, \"Rebecca Tan\". Don't add the email address or phone number here." headerTitle:@"PERSONALISE IT!" buttonTitle:@"GOT IT" image:@"bear-baby" window:YES];
}


- (void)setStyling{
    
    self.tvMessage.placeholder = @"Your warm & fuzzie message...";
    self.tvMessage.placeholderColor = [UIColor colorWithHexString:@"ADADAD"];
    self.tvMessage.delegate = self;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#FA3E3F"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:FONT_NAME_LATO_BOLD size:18.0f];
    button.frame=CGRectMake(0.0, 0.0, 60.0, 30.0);
    [button addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.tvMessage setInputAccessoryView:toolBar];
    
    [self.tfSearch addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tfSearch setInputAccessoryView:toolBar];
       
    [self updateCheckOut];
    
}

- (void)showConfirmWindow{
    
    UINib *nib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.confirmView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.confirmView.delegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.confirmView];
    self.confirmView.frame = window.frame;
    [self.confirmView setGiftItBackConfirmStyle];
    
    [self.view endEditing:YES];
}

- (void)hideConfirmView{
    [self.confirmView removeFromSuperview];
}


- (IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.tfSearch resignFirstResponder];
    return YES;
}

- (void)textFieldDidChanged:(UITextField*) textField{
    self.receiver.name = textField.text;
    [self updateCheckOut];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    self.message = textView.text;
    [self updateCheckOut];
}

#pragma mark - FZRedeemPopViewDelegate
- (void)redeemButtonPressed{
    [self hideConfirmView];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)cancelButtonPressed{
    [self hideConfirmView];
}

- (void)updateCheckOut{
    if (self.tfSearch.text.length != 0 && self.tvMessage.text.length > 0) {
        self.checkOutButton.enabled = true;
        [CommonUtilities setView:self.checkOutButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    } else{
        self.checkOutButton.enabled = false;
        [CommonUtilities setView:self.checkOutButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"pushToWebview"]) {
        if ([segue.destinationViewController isKindOfClass:[FZWebView2Controller class]]) {
            FZWebView2Controller *webView2Controller = (FZWebView2Controller *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"url"] isKindOfClass:[NSString class]]) {
                        webView2Controller.URL = ((NSString *)(NSDictionary *)sender[@"url"]);
                    }
                    if ([sender[@"title"] isKindOfClass:[NSString class]]) {
                        webView2Controller.titleHeader = ((NSString *)(NSDictionary *)sender[@"title"]);
                    }
                }
            }
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
