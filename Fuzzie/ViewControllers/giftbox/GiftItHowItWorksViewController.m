//
//  GiftItHowItWorksViewController.m
//  Fuzzie
//
//  Created by mac on 7/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftItHowItWorksViewController.h"

@interface GiftItHowItWorksViewController ()

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation GiftItHowItWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
