//
//  EditProfileViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileImageViewController.h"
#import "EditPasswordViewController.h"
#import "EditEmailViewController.h"


@interface EditProfileViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *nameContainerView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIView *emailContainerView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;
@property (weak, nonatomic) IBOutlet UIView *birthdayContainerView;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;

@property (weak, nonatomic) IBOutlet UIView *genderContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *genderMaleImage;
@property (weak, nonatomic) IBOutlet UILabel *genderMaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderFemaleImage;
@property (weak, nonatomic) IBOutlet UILabel *genderFemaleLabel;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthdate;

@property (strong, nonatomic) FZUser *user;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserController sharedInstance].currentUser;
    
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setProfileInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cameraButtonPressed:(id)sender {
    
    UIAlertController *alertControllder = [[UIAlertController alloc] init];
    UIAlertAction *actionView = [UIAlertAction actionWithTitle:@"View image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EditProfileImageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileImageView"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alertControllder addAction:actionView];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self launchCamera];
        }];
        [alertControllder addAction:actionCamera];
    }
    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"Choose existing photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchPhotoLibrary];
    }];
    [alertControllder addAction:actionPhoto];
    
    UIAlertAction *actionRemove = [UIAlertAction actionWithTitle:@"Remove image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteProfileImage];
    }];
    [alertControllder addAction:actionRemove];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertControllder addAction:actionCancel];
    
    [self presentViewController:alertControllder animated:YES completion:nil];
    
}

- (IBAction)emailButtonPressed:(id)sender {
    EditEmailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEmailView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)passwordButtonPressed:(id)sender {
    EditPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPasswordView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)genderMaleButtonPressed:(id)sender {
    self.gender = @"m";
    [self updateGenderState];
    [self updateGender];
    
}

- (IBAction)genderFemaleButtonPressed:(id)sender {
    self.gender = @"f";
    [self updateGenderState];
    [self updateGender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.firstNameTextField) {
        [self updateFirstName];
    } else if (textField == self.lastNameTextField){
        [self updateLastName];
    }
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [CommonUtilities setView:self.nameContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    [CommonUtilities setView:self.emailContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    [CommonUtilities setView:self.profileImage withCornerRadius:self.profileImage.frame.size.width/2];
    [self.profileImageView setBackgroundColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
     [CommonUtilities setView:self.passwordContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
     [CommonUtilities setView:self.birthdayContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    [CommonUtilities setView:self.genderContainerView withCornerRadius:5.0f withBorderColor:[UIColor colorWithWhite:0.0f alpha:0.10f] withBorderWidth:1.0f];
    
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthdateTextField.inputView = self.datePicker;
    [self initDatePicker];
    
    UIToolbar *toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDoneButtonPressed:)];
    [toolBar setItems:@[space,doneButton]];
    toolBar.userInteractionEnabled = true;
    [toolBar sizeToFit];
    self.birthdateTextField.inputAccessoryView = toolBar;
    
}

- (void)setProfileInfo{
    if ([UserController sharedInstance].currentUser) {
        self.user = [UserController sharedInstance].currentUser;
        
        if (self.user.profileImage) {
            [self.profileImage sd_setImageWithURL:[NSURL URLWithString:self.user.profileImage] placeholderImage:[UIImage imageNamed:@"profile-image"]];
        }
        self.firstNameTextField.text = self.user.firstName;
        self.lastNameTextField.text = self.user.lastName;
        self.emailLabel.text = self.user.email;
        self.birthdateTextField.text = self.user.formatttedBirthday;
        if (self.user.gender) {
            self.gender = self.user.gender;
        } else{
            self.gender = @"";
        }
        
        [self updateGenderState];
    }
}

- (void)initDatePicker{
    
    if (self.user.birthday && ![self.user.birthday isEqualToString:@""]) {
        static NSDateFormatter *dateFormatter;
        if (!dateFormatter) {
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-d"];
        }
        [self.datePicker setDate:[dateFormatter dateFromString:self.user.birthday]];
    } else{
        [self.datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*25]];
    }
    
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
        [apidateFormatter setDateFormat:@"dd/MM/yyyy"];
    }
    
    self.birthdateTextField.text = [textFieldDateFormatter stringFromDate:datePicker.date];
    self.birthdate = [apidateFormatter stringFromDate:datePicker.date];
}

- (void)datePickerDoneButtonPressed:(id)sender {
    [self.birthdateTextField endEditing:NO];
    if (self.birthdate && ![self.birthdate isEqualToString:@""] && self.user.formatttedBirthday && ![self.user.formatttedBirthday isEqualToString:self.birthdate]) {
        [self updateBirthdate];
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


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            // Save Image to Library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        [self.profileImage setImage:image];
        
        [UserController updateProfileImageWithImage:image withCompletion:^(FZUser *user, NSError *error) {
            
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                
            } else {
                if (user) {
                    self.user = user;
                }
            }
            
        }];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.profileImage setImage:image];
        }];
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateGenderState{
    if ([self.gender isEqualToString:@"m"]) {
        self.genderMaleLabel.textColor = [UIColor colorWithHexString:@"#424242"];
        self.genderMaleImage.image = [UIImage imageNamed:@"bear-male-red"];
        self.genderFemaleLabel.textColor = [UIColor colorWithHexString:@"#BDBDBD"];
        self.genderFemaleImage.image = [UIImage imageNamed:@"bear-female-grey"];
    } else if ([self.gender isEqualToString:@"f"]){
        self.genderMaleLabel.textColor = [UIColor colorWithHexString:@"#BDBDBD"];
        self.genderMaleImage.image = [UIImage imageNamed:@"bear-male-grey"];
        self.genderFemaleLabel.textColor = [UIColor colorWithHexString:@"#424242"];
        self.genderFemaleImage.image = [UIImage imageNamed:@"bear-female-red"];
    }
}

- (void)updateFirstName{
    if (self.firstNameTextField.text.length != 0 && ![self.user.firstName isEqualToString:self.firstNameTextField.text]) {
        [UserController updateFirstName:self.firstNameTextField.text withCompletion:nil];
        [UserController updateFirstName:self.firstNameTextField.text withCompletion:^(FZUser *user, NSError *error) {
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
            }
            
            if (user) {
                self.user = user;
            }
            
        }];
    }
    
}

- (void)updateLastName{
     if (self.lastNameTextField.text.length != 0 && ![self.user.lastName isEqualToString:self.lastNameTextField.text]) {
         [UserController updateLastName:self.lastNameTextField.text withCompletion:^(FZUser *user, NSError *error) {
             if (error) {
                 if (error.code == 417) {
                     [AppDelegate logOut];
                     return ;
                 }
             }
             
             if (user) {
                 self.user = user;
             }

         }];
     }
}

- (void)updateGender{
    [UserController updateGender:self.gender withCompletion:^(FZUser *user, NSError *error) {
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
        }
        
        if (user) {
            self.user = user;
        }

    }];
}

- (void)updateBirthdate{
    [UserController updateBirthdate:self.birthdate withCompletion:^(FZUser *user, NSError *error) {
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
        }
        
        if (user) {
            self.user = user;
            [self initDatePicker];

            [[FZLocalNotificationManager sharedInstance] scheduleMyBirthdayNotification];
        }

    }];
}

- (void)deleteProfileImage{
    [UserController deleteProfileImage:^(FZUser *user, NSError *error) {
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
        }
        
        if (user) {
            self.user = user;
            [self.profileImage sd_setImageWithURL:[NSURL URLWithString:self.user.profileImage] placeholderImage:[UIImage imageNamed:@"profile-image"]];
        }
    }];
}

@end
