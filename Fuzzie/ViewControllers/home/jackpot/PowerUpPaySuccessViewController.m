//
//  PowerUpPaySuccessViewController.m
//  Fuzzie
//
//  Created by Joma on 3/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpPaySuccessViewController.h"
#import "FZTabBarViewController.h"

@interface PowerUpPaySuccessViewController ()

@property (weak, nonatomic) IBOutlet TKRoundedView *container;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;

- (IBAction)goButtonPressed:(id)sender;
@end

@implementation PowerUpPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnGo withCornerRadius:4.0f];

    NSString *cards = @"1 Power Up Card";
    if ([self.coupon.powerUpPack[@"number_of_codes"] intValue] > 1) {
        cards = [NSString stringWithFormat:@"%@ Power Up Cards", self.coupon.powerUpPack[@"number_of_codes"]];
    }
    
    NSString *tickets = @"1 Jackpot Ticket";
    if (self.coupon.ticketCount.intValue > 1) {
        tickets = [NSString stringWithFormat:@"%@ Jackpot Tickets", self.coupon.ticketCount];
    }
    
    self.lbBody.text = [NSString stringWithFormat:@"%@ and %@ have been added to your wallet.", cards, tickets];
    
    NSString *colorKey = @"color";
    NSString *locationKey = @"location";
    NSArray *gradientColorsAndLocations = (@[
                                             @{colorKey: [UIColor colorWithHexString:@"#37A7ED"],locationKey: @(0.0f)},
                                             @{colorKey: [UIColor colorWithHexString:@"#4260BB"],locationKey: @(1.0f)}
                                             ]);
    self.container.fillColor = [UIColor colorWithHexString:@"37A7ED"];
    self.container.gradientColorsAndLocations = gradientColorsAndLocations;
    self.container.gradientDirection = TKGradientDirectionHorizontal | TKGradientDirectionDown;
    
}

- (IBAction)goButtonPressed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabBarController setSelectedIndex:kTabBarItemWallet];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
