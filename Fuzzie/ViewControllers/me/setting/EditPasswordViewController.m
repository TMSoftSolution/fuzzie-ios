//
//  EditPasswordViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "FZRedeemPopView.h"
#import "FZPasswordTextField.h"

@interface EditPasswordViewController () <UITextFieldDelegate,MDHTMLLabelDelegate, FZRedeemPopViewDelegate>

@property (weak, nonatomic) IBOutlet MDHTMLLabel *forgetPasswordLabel;

@property (weak, nonatomic) IBOutlet UIView *currentContainerView;
@property (weak, nonatomic) IBOutlet UITextField *tfCurrentPassworde;
@property (weak, nonatomic) IBOutlet UIView *anotherContainerView;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveButtonPressed:(id)sender;

@property (strong, nonatomic) FZRedeemPopView *redeemPopView;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)saveButtonPressed:(id)sender {
    [self updatgePassword];
}

- (void) updatgePassword{
    
    [self.view endEditing:YES];
    
    if (self.tfCurrentPassworde.text.length == 0) {
        [self showEmptyError:@"Missing Current Password." window:NO];
        return;
    } else if (self.tfNewPassword.text.length < 6) {
        [self showEmptyError:@"New password should be at least 6 characters." window:NO];
        return;
    } else if(![self.tfConfirmPassword.text isEqualToString:self.tfNewPassword.text]){
        [self showEmptyError:@"Password does not match" window:NO];
        return;
    }
    
    [self showProcessing:@"UPDATING" atWindow:NO];
    [UserController updatePasswordWithCurrentPassword:self.tfCurrentPassworde.text andNewPassword:self.tfNewPassword.text withCompletion:^(NSError *error) {
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showFail:[error localizedDescription] window:NO];
        } else {
            [self showSuccess:@"PASSWROD UPDATED!" window:NO];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hidePopView];

            });
            
        }
    }];
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    [self.view endEditing:YES];
    self.redeemPopView.hidden = NO;
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [CommonUtilities setView:self.currentContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    
    [CommonUtilities setView:self.anotherContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    
    self.forgetPasswordLabel.htmlText = @"<a href='forgot'>Forgot Password?</a>";
    self.forgetPasswordLabel.delegate = self;
    self.forgetPasswordLabel.linkAttributes = @{
                                                NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                                NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:self.forgetPasswordLabel.font.pointSize],
                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
    
    UINib *redeemPopViewNib = [UINib nibWithNibName:@"FZRedeemPopView" bundle:nil];
    self.redeemPopView = [[redeemPopViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.redeemPopView.delegate = self;
    [self.redeemPopView setResetPasswordStyle];
    [self.view addSubview:self.redeemPopView];
    self.redeemPopView.frame = self.view.frame;
    self.redeemPopView.hidden = YES;
    
    [self updateSaveButton];
 
}

- (void)updateSaveButton{
    if (self.tfCurrentPassworde.text.length != 0 && self.tfNewPassword.text.length != 0 && self.tfConfirmPassword.text.length != 0) {
        self.saveButton.enabled = true;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    } else{
        self.saveButton.enabled = false;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FZRedeemPopViewDelegate

- (void)redeemButtonPressed{
    self.redeemPopView.hidden = YES;
    [self showProcessing:NO];
    [UserController resetPasswordWithEmail:[UserController sharedInstance].currentUser.email withCompletion:^(NSError *error) {
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            [self showFail:[error localizedDescription] window:NO];
        } else {
            [self showSuccess:@"RESET EMAIL SENT!" window:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hidePopView];
                
            });
        }
        
    }];
    
}

- (void)cancelButtonPressed{
    self.redeemPopView.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tfCurrentPassworde) {
        [self.tfNewPassword becomeFirstResponder];
    } else if (textField == self.tfNewPassword){
        [self.tfConfirmPassword becomeFirstResponder];
    } else{
        [textField resignFirstResponder];
    }
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self updateSaveButton];
    return true;
}

@end
