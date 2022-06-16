//
//  ActivateSuccessViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 8/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "ActivateSuccessViewController.h"
#import "FZTabBarViewController.h"
#import "GiftBoxViewController.h"

@interface ActivateSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anotherCardHeightAnchor;
@property (weak, nonatomic) IBOutlet TKRoundedView *backroundView;

- (IBAction)shopButtonPressed:(id)sender;

@end

@implementation ActivateSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([self.successDict[@"type"] isEqualToString:@"PowerUpCode"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_RELOAD_HOME_DATA object:nil];
        
    } else {

        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
            
            [AppDelegate updateWalletBadge];
        }];
    }
    
    [self setStyling];
}

#pragma mark - Button Actions

- (IBAction)shopButtonPressed:(UIButton*)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    if ([self.successDict[@"type"] isEqualToString:@"ActivationCode"]) {
        
        FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabBarController setSelectedIndex:kTabBarItemWallet];
        UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];

        GiftBoxViewController *giftBoxView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftBoxView"];
        giftBoxView.fromDelivery = false;
        giftBoxView.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:giftBoxView animated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {

        FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabBarController setSelectedIndex:kTabBarItemShop];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (IBAction)anotherButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Helper Functions

- (void)setStyling {
    
    NSString *colorKey = @"color";
    NSString *locationKey = @"location";
    NSArray *gradientColorsAndLocations = (@[
                                             @{colorKey: [UIColor colorWithHexString:@"#37A7ED"],locationKey: @(0.0f)},
                                             @{colorKey: [UIColor colorWithHexString:@"#4260BB"],locationKey: @(1.0f)}
                                             ]);
    self.backroundView.fillColor = [UIColor colorWithHexString:@"37A7ED"];
    self.backroundView.gradientColorsAndLocations = gradientColorsAndLocations;
    self.backroundView.gradientDirection = TKGradientDirectionHorizontal | TKGradientDirectionDown;
    ;
    [CommonUtilities setView:self.shopButton withCornerRadius:4.0f];

    if (self.successDict) {
        if (self.successDict[@"credits"] && [self.successDict[@"credits"] floatValue] > 0) {
            self.iconImageView.hidden = YES;
            self.amountLabel.text = [NSString stringWithFormat:@"S$%.0f", [self.successDict[@"credits"] floatValue]];
            self.headerLabel.text = @"HAS BEEN CREDITED TO YOUR FUZZIE ACCOUNT";
            self.bodyLabel.text = @"Enjoy your shopping experience!";
            self.backroundView.hidden = YES;
            self.backgroundImageView.hidden = NO;
            
        } else if (self.successDict[@"type"]) {
            
            NSString *type = self.successDict[@"type"];
            if ([type isEqualToString:@"PowerUpCode"]) {
                
                self.backroundView.hidden = NO;
                self.backgroundImageView.hidden = YES;
                
                [self.shopButton setTitleColor:[UIColor colorWithHexString:@"#4594D4"] forState:UIControlStateNormal];
                
                self.amountLabel.text = @"";
                self.headerLabel.text = [NSString stringWithFormat:@"YOU'VE POWERED UP FOR %dH!", [self.successDict[@"time_to_expire"] intValue]];
                self.bodyLabel.text = @"Enjoy boosted cashback on all brands. Happy shopping!";
                self.bodyLabel.textColor = [UIColor whiteColor];
                
                if (self.fromPowerUpPack){
                    
                    self.anotherCardHeightAnchor.constant = 0.0f;
                    
                }
                
            }
            
            if ([type isEqualToString:@"ActivationCode"]) {
                
                self.backroundView.hidden = YES;
                self.backgroundImageView.hidden = NO;
                
                [self.iconImageView setImage:[UIImage imageNamed:@"UIImageViewCachChecked"]];
                self.amountLabel.text = @"";
                self.headerLabel.text = [[NSString stringWithFormat:@"%@-%@  ACTIVATED",self.successDict[@"brand_name"] ,self.successDict[@"gift_title"]] uppercaseString];
                self.bodyLabel.text = @"Your card has been added to your Gift Box";
                [self.shopButton setTitle:@"GO TO MY GIFTBOX" forState:UIControlStateNormal];

            }
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
