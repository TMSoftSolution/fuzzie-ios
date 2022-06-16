//
//  PaymentSuccessViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 28/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "FZTabBarViewController.h"
#import "DeliveryMethodViewController.h"
#import "GiftBoxViewController.h"
#import "JackpotPayViewController.h"
#import "JackpotPaySuccessViewController.h"
#import "PowerUpPaySuccessViewController.h"
#import "RedPacketPayViewController.h"
#import "RedPacketPaySuccessViewController.h"
#import "ClubSubscribePayViewController.h"

@interface PaymentSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *successHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *successDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButtonPressed:(id)sender;

@end

@implementation PaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)actionButtonPressed:(id)sender {
    
    if (self.topUp) {
        if ([FZData sharedInstance].backOriginalPaymentPage) {
            
            for (UIViewController *viewController in [self.navigationController viewControllers]) {
                if ([viewController isKindOfClass:[JackpotPayViewController class]] ||
                    [viewController isKindOfClass:[RedPacketPayViewController class]] ||
                    [viewController isKindOfClass:[ClubSubscribePayViewController class]]) {
                    [FZData sharedInstance].backOriginalPaymentPage = NO;
                    [self.navigationController popToViewController:viewController animated:YES];
                }
            }
            
        } else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else if (self.fromJackpot) {
        
        JackpotPaySuccessViewController *successView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotPaySuccessView"];
        successView.isPowerUpPack = self.isPowerUpPack;
        [self.navigationController pushViewController:successView animated:YES];
        
        
    } else if (self.fromRedPacket){
        
        RedPacketPaySuccessViewController *paySuccessView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketPaySuccessView"];
        paySuccessView.successDict = self.successDict;
        [self.navigationController pushViewController:paySuccessView animated:YES];
        
    } else if (self.showCashback) {
        if (self.gifted) {
            [self goDeliveryMethodView];
        } else {
            [self goToGiftBox];
        }
        
        
    } else if (self.successDict[@"cash_back"] && [self.successDict[@"cash_back"] floatValue] > 0) {
        
        PaymentSuccessViewController *successView = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentSuccessView"];
        successView.successDict = self.successDict;
        successView.showCashback = YES;
        successView.gifted = self.gifted;
        successView.receiver = self.receiver;
        [self.navigationController pushViewController:successView animated:YES];
        
    } else {
        [self goToGiftBox];
    }
    
}

- (void)goToGiftBox {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabBarController setSelectedIndex:kTabBarItemWallet];
    UINavigationController *navController = [[tabBarController viewControllers] objectAtIndex:kTabBarItemWallet];

    GiftBoxViewController *giftBoxView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftBoxView"];
    giftBoxView.fromDelivery = false;
    giftBoxView.hidesBottomBarWhenPushed = YES;
    [navController pushViewController:giftBoxView animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
 
}

- (void)goDeliveryMethodView{
    DeliveryMethodViewController *deliveryView = [self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryMethodView"];
    deliveryView.giftDict = self.successDict[@"gift"];
    deliveryView.receiver = self.receiver;
    [self.navigationController pushViewController:deliveryView animated:YES];
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [CommonUtilities setView:self.actionButton withCornerRadius:4.0f];

    if (self.successDict) {
        
        if (self.topUp) {
            
            self.giftImageView.hidden = YES;
            CGFloat credits = [self.successDict[@"value"] floatValue] + [self.successDict[@"cash_back"] floatValue];
            self.cashbackLabel.attributedText = [CommonUtilities getFormattedPaymentSuccessValue:[NSNumber numberWithFloat:credits] fontSize:60.0f smallFontSize:40.0f];
            
            self.successHeaderLabel.text = @"FUZZIE CREDITS ADDED TO YOUR ACCOUNT!";
            [self.successDescriptionLabel setText:[NSString stringWithFormat:@"Great job, %@!",[UserController sharedInstance].currentUser.firstName]];
            
            if ([FZData sharedInstance].backOriginalPaymentPage){
                [self.actionButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
            } else {
                [self.actionButton setTitle:@"START SHOPPING" forState:UIControlStateNormal];
            }
            
        } else if (self.fromJackpot || self.fromRedPacket){
            
            self.backgroundImageView.image = [UIImage imageNamed:@"success-bg-cashback"];
            
            self.giftImageView.hidden = YES;

            self.cashbackLabel.attributedText = [CommonUtilities getFormattedPaymentSuccessValue:self.successDict[@"cash_back"] fontSize:60.0f smallFontSize:40.0f];
            
            self.successHeaderLabel.text = @"CASHBACK HAS BEEN CREDITED TO YOUR FUZZIE ACCOUNT";
            self.successDescriptionLabel.text = @"Thanks for shopping with us!";
            
            [self.actionButton setTitleColor:[UIColor colorWithHexString:@"#388DD1"] forState:UIControlStateNormal];
            [self.actionButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
            
        } else {
            if (self.showCashback && self.successDict[@"cash_back"] && [self.successDict[@"cash_back"] floatValue] > 0) {
                
                self.giftImageView.hidden = YES;
       
                self.cashbackLabel.attributedText = [CommonUtilities getFormattedPaymentSuccessValue:self.successDict[@"cash_back"] fontSize:60.0f smallFontSize:40.0f];
                
                self.successHeaderLabel.text = @"CASHBACK HAS BEEN CREDITED TO YOUR FUZZIE ACCOUNT";
                self.successDescriptionLabel.text = @"Thanks for shopping with us!";
                
                self.backgroundImageView.image = [UIImage imageNamed:@"success-bg-cashback"];
                
                [self.actionButton setTitleColor:[UIColor colorWithHexString:@"#388DD1"] forState:UIControlStateNormal];
                if (self.gifted) {
                    [self.actionButton setTitle:@"SEND YOUR GIFT NOW" forState:UIControlStateNormal];
                } else{
                    [self.actionButton setTitle:@"GO TO MY WALLET" forState:UIControlStateNormal];
                }
                
            } else {
                self.cashbackLabel.text = @"";
                
                
                [self.giftImageView setImage:[UIImage imageNamed:@"success-gift"]];
                
                if (self.gifted) {
                    [self.successHeaderLabel setText:@"YOUR GIFT IS READY FOR DELIVERY!"];
                    [self.actionButton setTitle:@"SEND YOUR GIFT NOW" forState:UIControlStateNormal];
                    
                    
                } else{
                    
                    if (self.successDict[@"number_of_gifts"] && [self.successDict[@"number_of_gifts"] intValue] > 0) {
                        if ([self.successDict[@"number_of_gifts"] intValue] == 1) {
                            self.successHeaderLabel.text = @"YOUR GIFT CARD HAS BEEN ADDED TO YOUR WALLET";
                        } else {
                            self.successHeaderLabel.text = @"YOUR GIFT CARDS HAVE BEEN ADDED TO YOUR WALLET";
                        }
                        
                    }
                    
                    if (self.successDict[@"cash_back"] && [self.successDict[@"cash_back"] floatValue] > 0) {
                        [self.actionButton setTitle:@"VIEW CASHBACK EARNED" forState:UIControlStateNormal];
                    } else{
                        [self.actionButton setTitle:@"GO TO MY WALLET" forState:UIControlStateNormal];
                        
                    }
                    
                }
                
                [self.successDescriptionLabel setText:[NSString stringWithFormat:@"Great job, %@!",[UserController sharedInstance].currentUser.firstName]];
                
            }
        }
    }
    
    NSMutableAttributedString *attributedString = self.actionButton.titleLabel.attributedText.mutableCopy;
    [attributedString addAttribute:NSKernAttributeName value:@1.0f range:NSMakeRange(0, attributedString.length)];
    [self.actionButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (BOOL)floatHasDecimals:(CGFloat) f {
    return (f-(int)f != 0);
}

@end
