//
//  BankTermsViewController.m
//  Fuzzie
//
//  Created by mac on 8/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankTermsViewController.h"

@interface BankTermsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbBody;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation BankTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lbBody.text = self.dict[@"terms"];
}

#pragma mark IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
