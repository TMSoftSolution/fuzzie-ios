//
//  ClubInviteViewController.m
//  Fuzzie
//
//  Created by joma on 6/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubInviteViewController.h"
#import "ReferralUsersViewController.h"

@interface ClubInviteViewController ()

@property (weak, nonatomic) IBOutlet TKRoundedView *contentView;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UILabel *lbReferralCount;
@property (weak, nonatomic) IBOutlet UILabel *lbReferralBonus;
@property (weak, nonatomic) IBOutlet UILabel *lbReferralCode;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)inviteButtonPressed:(id)sender;
- (IBAction)viewButtonPressed:(id)sender;

@end

@implementation ClubInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    NSString *colorKey = @"color";
    NSString *locationKey = @"location";
    NSArray *gradientColorsAndLocations = (@[
                                             @{colorKey: [UIColor colorWithHexString:@"#FA3E3F"],locationKey: @(0.0f)},
                                             @{colorKey: [UIColor colorWithHexString:@"#C92C2D"],locationKey: @(1.0f)}
                                             ]);
    self.contentView.gradientColorsAndLocations = gradientColorsAndLocations;
    self.contentView.gradientDirection = TKGradientDirectionVertical;
    
    [CommonUtilities setView:self.codeView withBackground:[UIColor colorWithHexString:@"#000000" alpha:0.2f] withRadius:3.0f];
    [CommonUtilities setView:self.btnInvite withCornerRadius:4.0f];
    [CommonUtilities setView:self.btnView withCornerRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    
    if ([UserController sharedInstance].currentUser.clubReferralCode) {
        
        self.lbReferralCode.text = [UserController sharedInstance].currentUser.clubReferralCode;
        
    } else{
        
        self.lbReferralCode.text = @"";
    }

    
    [self loadClubReferral];

}

- (void)loadClubReferral{

    [UserController getClubReferral:^(NSDictionary *dictionary, NSError *error) {
        
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
        }
        if (dictionary) {
            NSString *credits = [dictionary objectForKey:@"credits"];
            if (credits) {
                self.lbReferralBonus.text = [NSString stringWithFormat:@"S$%@", credits];
            } else{
                self.lbReferralBonus.text = @"S$0";
            }
            
            int referred_users_count = [[dictionary objectForKey:@"referred_users_count"] intValue];
            if (referred_users_count) {
                self.lbReferralCount.text = [NSString stringWithFormat:@"%d", referred_users_count];
            } else{
                self.lbReferralCount.text = @"0";
            }
        }
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)copyButtonPressed:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [UserController sharedInstance].currentUser.clubReferralCode;
    [self showClipboardCopy:@"Code copied to clipboard" window:NO];
    [self performSelector:@selector(hidePopView) withObject:self afterDelay:2.0];
}

- (IBAction)inviteButtonPressed:(id)sender {
    
    NSString *body = [NSString stringWithFormat:@"Check out the Fuzzie Club for cool 1-for-1 deals and more from popular restaurants, attractions, spas and online shopping sites. I’m using it to save a lot of money. Use my code to get an extra $10 credits when you subscribe. %@ www.fuzzie.com.sg/club", [UserController sharedInstance].currentUser.clubReferralCode];
    NSArray *activityItems = @[body];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)viewButtonPressed:(id)sender {
    
    ReferralUsersViewController *referralUsersView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ReferralUsersView"];
    referralUsersView.isClubReferral = YES;
    [self.navigationController pushViewController:referralUsersView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
