//
//  ReferralCodeActivateSuccessViewController.m
//  Fuzzie
//
//  Created by joma on 9/4/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ReferralCodeActivateSuccessViewController.h"

@interface ReferralCodeActivateSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbCredits;
@property (weak, nonatomic) IBOutlet UIButton *btnGot;

- (IBAction)gotButtonPressed:(id)sender;

@end

@implementation ReferralCodeActivateSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyle];
}

- (void)setStyle{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [CommonUtilities setView:self.btnGot withBackground:[UIColor whiteColor] withRadius:4.0f];
    
    self.lbCredits.attributedText = [CommonUtilities getFormattedPaymentSuccessValue:self.credits fontSize:60.0f smallFontSize:40.0f];
}

#pragma mark - IBAction Helper
- (IBAction)gotButtonPressed:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
