//
//  VerificationCodeViewController.m
//  Fuzzie
//
//  Created by Joma on 1/4/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "VerificationCodeViewController.h"

@interface VerificationCodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputTextFields;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)resendButtonPressed:(id)sender;

@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void) setStyling{
    
    if (self.phone) {
        
        self.lbPhone.text = [NSString stringWithFormat:@"+65 %@", self.phone];
        
    } else {
        
        self.lbPhone.text = @"";
        
    }
    
    [CommonUtilities setView:self.resendButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    for (UITextField *textField in self.inputTextFields) {
        
        [CommonUtilities setView:textField withBackground:[UIColor whiteColor] withRadius:2.0f withBorderColor:[UIColor colorWithHexString:@"#000000" alpha:0.1f] withBorderWidth:1.0f];
    }
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
        
        [self loginWithPhoneIfCompleted];
    }
    
    return NO;
}

- (void) loginWithPhoneIfCompleted{
    
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
    
    [self showProcessing:YES];
    [UserController loginUserViaPhone:self.phone otp:OTP withSuccess:^(FZUser *user) {
        
        [self showSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self hidePopView];
            [self goHome];
            
        });
        
    } failure:^(NSError *error) {
        
        // Clear TextFields
        for (UITextField *textField in self.inputTextFields) {
            textField.text = @"";
        }
        
        [self showFail:[error localizedDescription] window:YES];
        
    }];
}

- (void)goHome{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_VIEWED] && [[[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_VIEWED] boolValue]) {
        UIViewController *loggedInView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarView"];
        [UIApplication sharedApplication].delegate.window.rootViewController = loggedInView;
    } else{
        UIViewController *tutoView = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialView"];
        [UIApplication sharedApplication].delegate.window.rootViewController = tutoView;
    }
}

#pragma mark - IBAction Helper

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resendButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    [self resendingCode:YES];
    [UserController checkPhoneRegistered:self.phone withCompletion:^(NSError *error) {
        
        if (error) {
            
            [self showFail:[error localizedDescription] window:YES];
            
        } else {
            
            [self showSuccess:@"A new code is on its way." buttonTitle:@"OK" window:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
