//
//  EmailSignUpViewController.m
//  Fuzzie
//
//  Created by Joma on 1/4/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "EmailSignUpViewController.h"
#import "OTPViewController.h"
#import "ReferralCodeActivateSuccessViewController.h"

@interface EmailSignUpViewController () <UITextFieldDelegate, MDHTMLLabelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbPhonePrefix;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *referralCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *termsLabel;

@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthdate;
@property (strong, nonatomic) NSString *referralCode;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *genderPicker;
@property (strong, nonatomic) NSArray *genders;

- (IBAction)profileImageButtonPressed:(id)sender;
- (IBAction)createButtonPressed:(id)sender;


@end

@implementation EmailSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.genders = @[@"Male", @"Female"];
    self.referralCode = @"";
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.lbPhonePrefix withBackground:[UIColor colorWithHexString:@"#E3E3E3"] withRadius:2.0f];
    [CommonUtilities setView:self.btnCreate withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.profileImageView.layer.cornerRadius = 35.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 5.0f;
    self.profileImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.profileImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.profileImageView.layer.shadowRadius = 5.0f;
    self.profileImageView.layer.shadowOpacity = 0.5f;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.termsLabel.delegate = self;
    self.termsLabel.htmlText = @"By joining Fuzzie, you agree with the Bear's <a href='http://fuzzie.com.sg/privacy'>Privacy Policy</a> and <a href='http://fuzzie.com.sg/terms'>Terms and Conditions.</a>";
    self.termsLabel.linkAttributes = @{
                                       NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                       NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:self.termsLabel.font.pointSize],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
    self.termsLabel.activeLinkAttributes = @{
                                             NSForegroundColorAttributeName: [UIColor colorWithHexString:HEX_COLOR_RED],
                                             NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:self.termsLabel.font.pointSize],
                                             NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
    [self setDatePickerInput];
    [self setGenderPickerInput];
    
    if (self.facebookNewUser) {
        
        if (self.facebookNewUser.profileImage) {
            NSURL *profileImageUrl = [NSURL URLWithString:self.facebookNewUser.profileImage];
            [self.profileImageView sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-image"]];
        }
        
        if (self.facebookNewUser.birthday) {
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            UIDatePicker *datePicker = [UIDatePicker new];
            datePicker.date = [dateFormatter dateFromString:self.facebookNewUser.birthday];
            [self datePickerValueChanged:datePicker];
        }
        
        if ([self.facebookNewUser.gender isEqualToString:@"m"]) {
            self.genderTextField.text = @"Male";
        } else if ([self.facebookNewUser.gender isEqualToString:@"f"]) {
            self.genderTextField.text = @"Female";
        }
        self.gender = self.facebookNewUser.gender;
        
        self.emailTextField.text = self.facebookNewUser.email;
        self.firstNameTextField.text = self.facebookNewUser.firstName;
        self.lastNameTextField.text = self.facebookNewUser.lastName;
       
        // This is to prevent constraint conflict.
        NSArray *subViews = [self.passwordContainerView subviews];
        if (subViews.count > 0) {
            for (UIView *subView in subViews) {
                [subView removeConstraints:[subView constraints]];
                [subView removeFromSuperview];
                [self.passwordContainerView addSubview:subView];
            }
        }
        
        self.passwordContainerHeightAnchor.constant = 0.0f;
    }
}

- (void) setDatePickerInput{
    
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*25]];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateTextField.inputView = self.datePicker;
    
    UIToolbar *toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDoneButtonPressed:)];
    [doneButton setTintColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    [toolBar setItems:@[space,doneButton]];
    toolBar.userInteractionEnabled = true;
    [toolBar sizeToFit];
    
    self.dateTextField.inputAccessoryView = toolBar;
    
}

- (void) setGenderPickerInput{
    
    self.genderPicker = [[UIPickerView alloc] init];
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    self.genderTextField.inputView = self.genderPicker;
    
    UIToolbar *toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(genderPickerDoneButtonPressed:)];
    [doneButton setTintColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    [toolBar setItems:@[space,doneButton]];
    toolBar.userInteractionEnabled = true;
    [toolBar sizeToFit];
    
    self.genderTextField.inputAccessoryView = toolBar;
    
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    
    static NSDateFormatter *textFieldDateFormatter;
    static NSDateFormatter *apidateFormatter;
    
    if (!textFieldDateFormatter) {
        textFieldDateFormatter = [NSDateFormatter new];
        [textFieldDateFormatter setDateFormat:@"d MMMM yyyy"];
    }
    
    if (!apidateFormatter) {
        apidateFormatter = [NSDateFormatter new];
        [apidateFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    self.dateTextField.text = [textFieldDateFormatter stringFromDate:datePicker.date];
    self.birthdate = [apidateFormatter stringFromDate:datePicker.date];
}

- (void)datePickerDoneButtonPressed:(id)sender {
    [self.dateTextField endEditing:NO];
}

- (void)genderPickerDoneButtonPressed:(id)sender{
    [self.genderTextField endEditing:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        if (self.facebookNewUser) { // There's no password field
            [self.phoneTextField becomeFirstResponder];
        } else {
            [self.passwordTextField becomeFirstResponder];
        }
        
    } else if (textField == self.referralCodeTextField){
        [self.view endEditing:YES];
        [self checkReferralCodeValidation];
        
    } else if (textField == self.passwordTextField) {
        [self.phoneTextField becomeFirstResponder];
    } else if (textField == self.phoneTextField) {
        [self.dateTextField becomeFirstResponder];
    }
    
    return YES;
}

- (void)checkReferralCodeValidation{
    
    NSString *code = self.referralCodeTextField.text;
    
    if (code.length > 0) {
        
        [self showProcessing:@"VALIDATING" atWindow:YES];
        [UserController checkReferralCodeValidation:code completion:^(NSDictionary *dictionary, NSError *error) {
            
            [self hidePopView];
            
            if (error) {
                
                self.referralCode = @"";
                self.referralCodeTextField.text = @"";
                NSString *errorMessage = [NSString stringWithFormat:@"Unknown Error Occurred - %ld", (long)error.code];
                if (error.localizedDescription) {
                    errorMessage = error.localizedDescription;
                }
                [self showEmptyError:errorMessage buttonTitle:error.code == 405 ? @"GOT IT" : @"TRY AGAIN" window:YES];
                
            } else {
                
                if (dictionary[@"credits"]) {
                 
                    self.referralCode = code;
                    ReferralCodeActivateSuccessViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferralCodeActivateSuccessView"];
                    successView.credits = dictionary[@"credits"];
                    [self.navigationController pushViewController:successView animated:YES];
                }
            }
        }];
        
    }

}

- (void)launchCamera {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:imagePicker animated:YES completion:nil];
    });
}

- (void)launchPhotoLibrary {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:imagePicker animated:YES completion:nil];
    });
    
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    FZWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    if ([URL.absoluteString isEqualToString:@"http://fuzzie.com.sg/terms"]) {
        webView.title = @"TERMS OF SERVICE";
    } else {
        webView.title = @"PRIVACY POLICY";
    }
    webView.URL = URL;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            // Save Image to Library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        self.profileImageView.image = image;
        self.profileImage = image;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.genders.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.genders objectAtIndex:row];
    
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString *gender = [self.genders objectAtIndex:row];
    self.genderTextField.text = gender;
    self.gender = [[gender substringToIndex:1] lowercaseString];
}

#pragma mark - IBAction Helper
- (IBAction)profileImageButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet bk_addButtonWithTitle:@"Take photo" handler:^{
            [self launchCamera];
        }];
    }
    [actionSheet bk_addButtonWithTitle:@"Choose photo" handler:^{
        [self launchPhotoLibrary];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)createButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.firstNameTextField.text.length == 0 ||
        self.lastNameTextField.text.length == 0) {
        [self showEmptyError:@"We need your first name and last name" window:YES];
        return;
    } else if (self.emailTextField.text.length == 0) {
        [self showEmptyError:@"Your email is missing" window:YES];
        return;
    } else if ([CommonUtilities validateEmail:self.emailTextField.text] == NO) {
        [self showEmptyError:@"Invalid email address" window:YES];
        return;
    } else if (!self.facebookNewUser && self.passwordTextField.text.length < 6) {
        if (self.passwordTextField.text.length == 0) {
            [self showEmptyError:@"Your password is missing" window:YES];
        } else {
            [self showEmptyError:@"Your password is too short" window:YES];
        }
        return;
    } else if (self.phoneTextField.text.length == 0) {
        [self showEmptyError:@"Your mobile number is missing." window:YES];
        return;
    } else if ([CommonUtilities validatePhone:self.phoneTextField.text] == NO) {
        [self showEmptyError:@"Invalid mobile number" window:YES];
        return;
    }

    if (self.facebookNewUser) {
        
        NSMutableDictionary *userProfile = [@{
                                              @"first_name": self.firstNameTextField.text,
                                              @"last_name": self.lastNameTextField.text,
                                              @"email": self.emailTextField.text,
                                              @"phone": self.phoneTextField.text } mutableCopy];
        
        if (self.gender) {
            [userProfile setObject:self.gender forKey:@"gender"];
        }
        
        if (self.birthdate) {
            [userProfile setObject:self.birthdate forKey:@"birthdate"];
        }
        
        if (self.referralCode.length > 0) {
            [userProfile setObject:self.referralCode forKey:@"referred_by_code"];
        }
        
        [self showProcessing:YES];
        [UserController signUpNewFacebookUser:userProfile andProfileImage:self.profileImage withCompletion:^(FZUser *user, NSError *error) {
            
            if (user) {
                [self hidePopView];
                OTPViewController *activateView = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPView"];
                activateView.phoneNumber = self.phoneTextField.text;
                [self.navigationController pushViewController:activateView animated:YES];
                
            } else if (error) {
                [self showEmptyError:[error localizedDescription] window:YES];
                
            } else {
                [self showEmptyError:@"Unknown error occurred" window:YES];
            }
            
        }];
        
    } else {
        
        [self showProcessing:YES];
        [UserController signupUserViaEmail:self.emailTextField.text password:self.passwordTextField.text firstName:self.firstNameTextField.text lastName:self.lastNameTextField.text birthday:self.birthdate phoneNumber:self.phoneTextField.text profileImage:self.profileImage gender:self.gender referralCode:self.referralCode withSuccess:^(NSDictionary *dictionary) {
            
            [self hidePopView];
            
            OTPViewController *activateView = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPView"];
            activateView.phoneNumber = self.phoneTextField.text;
            [self.navigationController pushViewController:activateView animated:YES];
            
            
        } failure:^(NSError *error) {
            [self showFail:[error localizedDescription] withErrorCode:error.code window:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
