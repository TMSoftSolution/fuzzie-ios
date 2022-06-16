//
//  ActivateSuccessJackpotViewController.m
//  Fuzzie
//
//  Created by Joma on 1/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ActivateSuccessJackpotViewController.h"
#import "JackpotTicketsUseViewController.h"
#import "FZTabBarViewController.h"

@interface ActivateSuccessJackpotViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbTicketsCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTickets;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)setButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation ActivateSuccessJackpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
        [AppDelegate updateWalletBadge];
    }];
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnSet withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnSave withCornerRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    
    if (self.successDict && self.successDict[@"number_of_jackpot_tickets"]) {
        
        int ticketsCount = [self.successDict[@"number_of_jackpot_tickets"] intValue];
        if (ticketsCount > 1) {
            self.lbTickets.text = @"JACKPOT TICKETS";
            self.lbBody.text = @"Your Jackpot tickets have been added to your wallet.";
        } else {
            self.lbTickets.text = @"JACKPOT TICKET";
            self.lbBody.text = @"Your Jackpot ticket has been added to your wallet.";
        }
        
        self.lbTicketsCount.text = [NSString stringWithFormat:@"X%d", ticketsCount];
        
    }
}

- (IBAction)setButtonPressed:(id)sender {
    
    JackpotTicketsUseViewController *useView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotTicketsUseView"];
    [self.navigationController pushViewController:useView animated:YES];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
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
