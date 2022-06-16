//
//  ClubOfferRedeemSuccessViewController.m
//  Fuzzie
//
//  Created by joma on 6/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferRedeemSuccessViewController.h"

@interface ClubOfferRedeemSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;

- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation ClubOfferRedeemSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLUB_OFFER_REDEEMED object:nil];
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnDone withBackground:[UIColor whiteColor] withRadius:4.0f];
    self.lbOrderNumber.text = [NSString stringWithFormat:@"#%@", self.dict[@"order_number"]];
}

#pragma mark - IBAction Helper
- (IBAction)doneButtonPressed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
