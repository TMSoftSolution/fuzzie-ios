//
//  EditProfileImageViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "EditProfileImageViewController.h"

@interface EditProfileImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (IBAction)editButtonPressed:(id)sender;

@end

@implementation EditProfileImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)editButtonPressed:(id)sender {
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            // Save Image to Library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        [self.profileImageView setImage:image];
        
        [SVProgressHUD showWithStatus:@"Uploading Profile Image..."];
        [UserController updateProfileImageWithImage:image withCompletion:^(FZUser *user, NSError *error) {
            [SVProgressHUD dismiss];
            
            if (error) {
                if (error.code == 417) {
                    [AppDelegate logOut];
                    return ;
                }
                
                [self showErrorAlertTitle:@"Profile Image Uploading" message:[error localizedDescription]  buttonTitle:@"OK"];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Functions

- (void)setStyling {
    
    FZUser *user = [UserController sharedInstance].currentUser;
    if (user && user.profileImage) {
        NSURL *profileImageUrl = [NSURL URLWithString:user.profileImage];
        [self.profileImageView sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-image"]];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"profile-image"];
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

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
