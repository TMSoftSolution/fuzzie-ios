//
//  LocationEnableViewController.m
//  Fuzzie
//
//  Created by joma on 12/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "LocationEnableViewController.h"

@interface LocationEnableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnGoSetting;

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)goSettingButtonPressed:(id)sender;

@end

@implementation LocationEnableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnGoSetting withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

#pragma mark - IBAction Helper
- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)goSettingButtonPressed:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

@end
