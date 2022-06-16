//
//  OTPViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "OTPViewController.h"

@interface OTPViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputTextFields;

@property (weak, nonatomic) IBOutlet UIButton *resendButton;

- (IBAction)resendButtonPressed:(id)sender;

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITextField *firstTextField = [self.inputTextFields firstObject];
    [firstTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)resendButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self resendingCode:YES];
    [UserController resentOTPWithSuccess:^(NSDictionary *dictionary) {
    
        [self showSuccess:@"A new code is on its way." buttonTitle:@"OK" window:YES];
        
    } failure:^(NSError *error) {

        [self showFail:[error localizedDescription] window:YES];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = finalString;
    
    if (finalString.length > 0) {
        NSInteger tag = textField.tag;
        
        if (tag != 3) {
            UITextField *nextTextField = self.inputTextFields[tag+1];
            [nextTextField becomeFirstResponder];
        }
        
        [self submitOTPIfCompleted];
    }
    
    return NO;
}

#pragma mark - Helper Functions

- (void)submitOTPIfCompleted {
    BOOL completed = YES;
    NSString *OTP = @"";
    for (UITextField *textField in self.inputTextFields) {
        if (textField.text.length == 0) {
            completed = NO;
        } else {
            OTP = [OTP stringByAppendingString:textField.text];
        }
    }
    
    if (!completed) return;
    
    [self.view endEditing:YES];
    
    if (self.isNumberUpdate) {
        [self showVerifying:YES];
        [UserController verifyNewPhoneNumberWithOTP:OTP withCompletion:^(FZUser *user, NSError *error) {
            
            if (user) {
                [self hidePopView];
                [self goHomeView];
            } else if (error) {
                [self showFail:[error localizedDescription] window:YES];
            } else {
               [self showFail:@"Unknown Error Occurred." window:YES];
            }
        }];
        
    } else {
        [self showVerifying:YES];
        [UserController activateAccountWithOTP:OTP withSuccess:^(FZUser *user) {
            [self hidePopView];
            [self goHomeView];
            
        } failure:^(NSError *error) {
            
            // Clear TextFields
            for (UITextField *textField in self.inputTextFields) {
                textField.text = @"";
            }
            
            [self showFail:[error localizedDescription] window:YES];
        }];
    }
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
  
    self.phoneLabel.text = [NSString stringWithFormat:@"+65 %@", self.phoneNumber];
    
    for (UITextField *textField in self.inputTextFields) {
        textField.layer.cornerRadius = 4.0f;
        textField.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.10f].CGColor;
        textField.layer.borderWidth = 1.0f;
        textField.layer.masksToBounds = YES;
    }

    [CommonUtilities setView:self.resendButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    NSMutableAttributedString *attributedString = self.resendButton.titleLabel.attributedText.mutableCopy;
    [attributedString addAttribute:NSKernAttributeName value:@2.5f range:NSMakeRange(0, attributedString.length)];
    [self.resendButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
}

@end
