//
//  CheckoutViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 2/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "CheckoutViewController.h"
#import "PayViewController.h"

@interface CheckoutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)checkoutButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkoutButtonPressed:(id)sender {
    
    [self goNewPaymentPage];
}

- (IBAction)addButtonPressed:(id)sender {
    [self showProcessing:@"ADDING TO BAG" atWindow:YES];
    [GiftController addItemToShoppingBagWithID:self.giftDict[@"type"] withCompletion:^(NSError *error) {
        [self hidePopView];
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            [self showEmptyError:[error localizedDescription] window:YES];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(checkoutViewDidAddGiftToShoppingBag:)]) {
                [self.delegate checkoutViewDidAddGiftToShoppingBag:self.giftDict];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

- (void) goNewPaymentPage{

    PayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"PayView"];
    payView.brandArray = @[self.brand];
    payView.itemArray = @[self.giftDict];
    
    [self.navigationController pushViewController:payView animated:YES];
}

#pragma mark - Helper Functions

- (void)setStyling {

    [CommonUtilities setView:self.brandImageView withCornerRadius:7.5f];
    [CommonUtilities setView:self.checkoutButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.addButton withBackground:[UIColor whiteColor] withRadius:4.0f];

    
    if (self.brand && self.giftDict) {
        NSURL *imageURL = [NSURL URLWithString:self.brand.backgroundImage];
        [self.brandImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
        
        self.brandNameLabel.text = [self.brand.name uppercaseString];
        self.giftNameLabel.text = self.giftDict[@"name"];
    }

}

@end
