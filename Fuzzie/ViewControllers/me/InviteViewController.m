//
//  InviteViewController.m
//  Fuzzie
//
//  Created by joma on 10/5/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbCredits;
@property (weak, nonatomic) IBOutlet UILabel *lbTickets;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)fuzzieInviteButtonPressed:(id)sender;
- (IBAction)clubInviteButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *fuzzieInviteView;
@property (weak, nonatomic) IBOutlet UIView *clubInviteView;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.fuzzieInviteView withCornerRadius:4.0f];
    [CommonUtilities setView:self.clubInviteView withCornerRadius:4.0f];
    
    if ([UserController sharedInstance].currentUser.totalCreditsEarned) {
        
        self.lbCredits.text = [[NSString stringWithFormat:@"S$%.2f", [UserController sharedInstance].currentUser.totalCreditsEarned.floatValue] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
    } else {
        
        self.lbCredits.text = @"S$0";
        
    }
    
    if ([UserController sharedInstance].currentUser.totalJackpotTicketsEarned) {
        
        self.lbTickets.text = [NSString stringWithFormat:@"X %@", [UserController sharedInstance].currentUser.totalJackpotTicketsEarned];
        
    } else {
        
        self.lbTickets.text = @"X 0";
        
    }
    
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fuzzieInviteButtonPressed:(id)sender {
    
    UIViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsView"];
    [self.navigationController pushViewController:inviteView animated:YES];
}

- (IBAction)clubInviteButtonPressed:(id)sender {
    
    UIViewController *inviteView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubInviteView"];
    [self.navigationController pushViewController:inviteView animated:YES];
}
@end
