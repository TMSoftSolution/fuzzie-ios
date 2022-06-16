//
//  UserProfilePhotoViewController.m
//  Fuzzie
//
//  Created by mac on 6/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserProfilePhotoViewController.h"

@interface UserProfilePhotoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation UserProfilePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setStyling{
    if (_userInfo && _userInfo.profileImage) {
        NSURL *profileImageUrl = [NSURL URLWithString:_userInfo.profileImage];
        [self.photo sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"profile-image"]];
    } else {
        self.photo.image = [UIImage imageNamed:@"profile-image"];
    }
    if (_userInfo && _userInfo.name) {
        [self.name setText:[_userInfo.name uppercaseString]];
    } else{
        [self.name setText:@""];
    }
}

@end
