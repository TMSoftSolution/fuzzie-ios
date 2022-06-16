//
//  ForceUpdateViewController.m
//  Fuzzie
//
//  Created by Joma on 1/16/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ForceUpdateViewController.h"

@interface ForceUpdateViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

- (IBAction)updateButtonPressed:(id)sender;

@end

@implementation ForceUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CommonUtilities setView:self.btnUpdate withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (IBAction)updateButtonPressed:(id)sender {

    [iVersion sharedInstance].applicationBundleID = @"sg.com.fuzzie.client-prod";
    [iVersion sharedInstance].updatePriority = iVersionUpdatePriorityHigh;
    [[iVersion sharedInstance] openAppPageInAppStore];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
