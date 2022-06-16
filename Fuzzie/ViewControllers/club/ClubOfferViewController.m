//
//  ClubOfferViewController.m
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferViewController.h"
#import "ClubOfferRedeemViewController.h"
#import "ClubOfferOnlineRedeemViewController.h"
#import "ClubSubscribeViewController.h"
#import "ClubStoreLocationViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "ClubOfferLocationConfirmViewController.h"

@interface ClubOfferViewController () <UIScrollViewDelegate, ClubStoreLocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnRedeem;
@property (weak, nonatomic) IBOutlet FZHeaderView *headerBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outletBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet TKRoundedView *outletView;
@property (weak, nonatomic) IBOutlet UIView *outletContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *ivOffer;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbEstSaving;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName1;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreAddress1;

@property (weak, nonatomic) IBOutlet UILabel *lbAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferType;
@property (weak, nonatomic) IBOutlet UIView *physicalInfoView;
@property (weak, nonatomic) IBOutlet UIView *onlineInfoView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)redeemButtonPressed:(id)sender;
- (IBAction)changeButtonPressed:(id)sender;
- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)ruleButtonPressed:(id)sender;

@end

@implementation ClubOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    if (self.isFlashSale) {
        
        self.moreStores = self.offer[@"stores"];
        if (self.moreStores.count > 0) {
            self.clubStore = self.moreStores[0];
        }
    }
    
    self.isOnline = [self.clubStore[@"online_brand"] boolValue];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.lbOfferType withCornerRadius:4.0f];
    [CommonUtilities setView:self.lbOfferType withBackground:[UIColor colorWithHexString:@"#CDCDCD"] withRadius:13.0f];
    [CommonUtilities setView:self.btnChange withCornerRadius:4.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
    [CommonUtilities setView:self.btnContinue withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    self.outletContainerView.hidden = YES;
    self.outletContainerView.alpha = 0.0f;
    self.outletBottomConstraint.constant = -480.0f;
    self.outletView.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerTopRight;
    self.outletView.cornerRadius = 10.0f;
    
    if (self.offer[@"image_url"] && ![self.offer
                                      [@"image_url"] isKindOfClass:[NSNull class]]) {
        
        [self.ivOffer sd_setImageWithURL:[NSURL URLWithString:self.offer[@"image_url"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
 
    self.lbOfferName.text = self.offer[@"name"];
    
    NSDictionary *brandType = [FZData getBrandType:self.offer[@"brand_type_id"]];
    if (brandType) {
        
        NSDictionary *offerType = [FZData getOfferType:self.offer[@"offer_type_id"] brandType:brandType];
        if (offerType) {
            
            self.lbOfferType.text = [NSString stringWithFormat:@"   %@   ", offerType[@"name"]];
            
        } else {
            
            self.lbOfferType.hidden = YES;
        }
        
    } else {
      
        self.lbOfferType.hidden = YES;
    }
    
    self.lbBrandName.text= self.clubStore[@"brand_name"];
    self.lbEstSaving.text = [[NSString stringWithFormat:@"Estimated savings: S$%.2f", [self.offer[@"estimated_savings"] floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.lbAvailable.text = self.offer[@"availability_options"][@"available_slots"];
    
    if ([self.offer[@"availability_options"][@"available_now"] boolValue]) {
        
        self.btnRedeem.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
        self.btnRedeem.enabled = YES;
        
    } else {
        
        self.btnRedeem.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3"];
        self.btnRedeem.enabled = NO;
    }
    
    if (self.isOnline) {
        
        self.physicalInfoView.hidden = YES;
        self.onlineInfoView.hidden = NO;
        
    } else {
        
        self.physicalInfoView.hidden = NO;
        self.onlineInfoView.hidden = YES;
        [self updateStoreInfo];
    }

}

- (void)updateStoreInfo{
    
    if (self.clubStore) {
        
        self.lbStoreName.text = self.clubStore[@"store_name"];
        self.lbStoreName1.text = self.clubStore[@"store_name"];

        FZStore *store = [FZData getStoreById:self.clubStore[@"id"]];
        if (store && store.address) {
            
            self.lbStoreAddress.text = store.address;
            self.lbStoreAddress1.text = store.address;
            
        } else {
            
            self.lbStoreAddress.text = @"";
            self.lbStoreAddress1.text = @"";
        }
    } else {
        
        self.lbStoreName.text = @"";
        self.lbStoreName1.text = @"";
        self.lbStoreAddress.text = @"";
        self.lbStoreAddress1.text = @"";
      
    }
    
}

- (void)showOutletConfirm:(BOOL)show{
    
    self.outletContainerView.hidden = NO;
    
    if (show) {
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            
            self.outletBottomConstraint.constant = 0.0f;
            self.outletContainerView.alpha = 1.0f;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            
            self.outletBottomConstraint.constant = -480.0f;
            self.outletContainerView.alpha = 0.0f;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.outletContainerView.hidden = YES;
        }];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat heightSlider = screenWidth * 0.75f - 64;
    
    int realPosition = scrollView.contentOffset.y+20;
    if (realPosition >= heightSlider) {
        float ratio = realPosition-heightSlider;
        double coef = MIN(1,ratio/32);
        self.headerBackground.alpha = (float)coef;
    } else {
        self.headerBackground.alpha = 0;
    }
}

#pragma mark - ClubStoreLocationViewControllerDelegate
- (void)storeSelected:(NSDictionary *)dict{
    
    self.clubStore = dict;
    [self updateStoreInfo];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    
    [super okButtonClicked];
    [self goClubSubscribe];
}

- (void)goClubSubscribe{
    
    ClubSubscribeViewController *subscribeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    [self.navigationController pushViewController:subscribeView animated:YES];
}

#pragma mark - IBActionHelper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)redeemButtonPressed:(id)sender {
    
    if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
        
        if (self.isOnline) {
            
            ClubOfferOnlineRedeemViewController *redeemView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferOnlineRedeemView"];
            redeemView.offer = self.offer;
            redeemView.clubStore = self.clubStore;
            [self.navigationController pushViewController:redeemView animated:YES];
            
        } else {
            
//            [self showOutletConfirm:YES];
            
            if ([CLLocationManager locationServicesEnabled]) {
                
                ClubOfferLocationConfirmViewController *locationConfirmView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferLocationConfirmView"];
                locationConfirmView.offer = self.offer;
                locationConfirmView.clubStore = self.clubStore;
                locationConfirmView.moreStores = self.moreStores;
                [self.navigationController pushViewController:locationConfirmView animated:YES];
                
            } else {
                
                UIViewController *locationEnableView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationEnableView"];
                [self presentViewController:locationEnableView animated:YES completion:nil];
            }
        }
        
    } else {
        
        [self showError:@"This offer is available for Fuzzie Club members only. Join the Club now to access all offers!" headerTitle:@"JOIN THE CLUB" buttonTitle:@"LEARN MORE" image:@"bear-club" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
    }


}

- (IBAction)changeButtonPressed:(id)sender {
    
    [self showOutletConfirm:NO];
    
    ClubStoreLocationViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
    locationView.clubStores = self.moreStores;
    locationView.delegate = self;
    [self.navigationController pushViewController:locationView animated:YES];
}

- (IBAction)continueButtonPressed:(id)sender {

    [self showOutletConfirm:NO];
    
    ClubOfferRedeemViewController *redeemView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferRedeemView"];
    redeemView.offer = self.offer;
    redeemView.clubStore = self.clubStore;
    [self.navigationController pushViewController:redeemView animated:YES];

}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self showOutletConfirm:NO];
}

- (IBAction)ruleButtonPressed:(id)sender {
    
    if (![UserController sharedInstance].currentUser.rules) {
        return;
    }
    
    TermsAndConditionsTableViewController *termsView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"TermsAndConditionsView"];
    NSArray *rules = [[NSArray alloc] initWithObjects:[UserController sharedInstance].currentUser.rules, nil];
    termsView.termsConditions = rules;
    termsView.titleString = @"RULES OF USE";
    [self.navigationController pushViewController:termsView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
