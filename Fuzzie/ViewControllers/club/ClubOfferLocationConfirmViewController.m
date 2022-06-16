//
//  ClubOfferLocationConfirmViewController.m
//  Fuzzie
//
//  Created by joma on 12/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferLocationConfirmViewController.h"
#import "ClubStoreLocationViewController.h"
#import "ClubOfferRedeemViewController.h"

@interface ClubOfferLocationConfirmViewController () <ClubStoreLocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreAddress;


- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)changeButtonPressed:(id)sender;

@end

@implementation ClubOfferLocationConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnContinue withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    [self updateStoreInfo];
}

- (void)updateStoreInfo{
    
    if (self.clubStore) {
        
        self.lbStoreName.text = self.clubStore[@"store_name"];
        
        self.store = [FZData getStoreById:self.clubStore[@"id"]];
        if (self.store && self.store.address) {
            
            self.lbStoreAddress.text = self.store.address;
            
        } else {
            
            self.lbStoreAddress.text = @"";
        }
    } else {
        
        self.lbStoreName.text = @"";
        self.lbStoreAddress.text = @"";
        
    }
}

- (void)locationVerify{
    
    [UserController locationVerify:self.store.storeId withCompletion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLocationVerifyView];
        
        if (dictionary) {
            
            if (dictionary[@"is_nearest"] && [dictionary[@"is_nearest"] boolValue]) {
                
                [self goOfferReemPage];
                
            } else {
                
                [self showLocationNoMatchView];
            }
            
        } else {
            
            [self showLocationNoMatchView];
        }
    }];
}

- (void)goOfferReemPage{
    
    ClubOfferRedeemViewController *redeemView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferRedeemView"];
    redeemView.offer = self.offer;
    redeemView.clubStore = self.clubStore;
    
    [self.navigationController pushViewController:redeemView animated:YES];

}

#pragma mark - ClubStoreLocationViewControllerDelegate
- (void)storeSelected:(NSDictionary *)dict{
    
    self.clubStore = dict;
    [self updateStoreInfo];
}


#pragma mark - IBAction Helper
- (IBAction)closeButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)continueButtonPressed:(id)sender {
    
    if (self.store) {
        
        [self locationVerify];
        [self showLocationVerifyView];
    }
}

- (IBAction)changeButtonPressed:(id)sender {
    
    ClubStoreLocationViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
    locationView.clubStores = self.moreStores;
    locationView.delegate = self;
    [self.navigationController pushViewController:locationView animated:YES];
    
}

@end
