//
//  EditEmailViewController.m
//  Fuzzie
//
//  Created by mac on 7/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "EditEmailViewController.h"

@interface EditEmailViewController () <UITextFieldDelegate, FZPopViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *emailContainerView;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) FZUser *user;

@end

@implementation EditEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserController sharedInstance].currentUser;
    [self setStyling];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self updateEmail];
}

- (void) updateEmail{
    [self.view endEditing:YES];
    if (![CommonUtilities validateEmail:self.tfEmail.text]) {
        
        [self showFail:@"You need to enter a valid email address." buttonTitle:@"GOT IT" window:NO];
        return;
    }
    
    [self showProcessing:NO];
    [UserController updateEmail:self.tfEmail.text withCompletion:^(FZUser *user, NSError *error) {
        [self hidePopView];
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            } else{
                [self showFail:[error localizedDescription] buttonTitle:@"GOT IT" window:NO];
                return;
            }
        } else{
            [self showSuccess:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hidePopView];
                
            });
        }
        
    }];
}

- (void) setStyling{
    [CommonUtilities setView:self.emailContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    
    [self.tfEmail setText:self.user.email];
    [self.tfEmail addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self updateSaveButton];
}

- (void)updateSaveButton{
    if ([self.user.email isEqualToString:self.tfEmail.text]|| ![CommonUtilities validateEmail:self.tfEmail.text]) {
        self.saveButton.enabled = false;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    } else{
        
        self.saveButton.enabled = true;
        [CommonUtilities setView:self.saveButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return true;
}

- (void)textFieldDidChanged:(UITextField*) textField{
    [self updateSaveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
