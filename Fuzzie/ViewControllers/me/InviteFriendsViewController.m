//
//  InviteFriendsViewController.m
//  Fuzzie
//
//  Created by Yevhen Strohanov on 4/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "ReferralUsersViewController.h"

@interface InviteFriendsViewController () <UITextFieldDelegate>{
    FZUser *user;
}

@property (weak, nonatomic) IBOutlet UIButton *btnInvite;

@property (assign, nonatomic) BOOL isRefreshing;

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStyling];
    [self loadReferralData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setInfo];
}

#pragma mark - IBAction Helper
- (IBAction)inviteFriendsTapped:(id)sender {
    
    [UserController callRatePush:nil];
    
    NSString *body = [NSString stringWithFormat:@"I’m using Fuzzie to get INSTANT cashback on Grab, Deliveroo, Qoo10 and many more brands. They have a weekly S$150,000 Jackpot too! Sign up with this link to enjoy FREE $5 credits to buy anything on Fuzzie: %@", user.referralUrl];
    NSArray *activityItems = @[body];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:activityItems applicationActivities:nil];

    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)copyTapped:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = user.referralCode;
    [self.pop showClipboardCopy:@"Code copied to clipboard"];
    [self performSelector:@selector(popHide) withObject:self afterDelay:2.0];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewButtonClicked:(id)sender {

    ReferralUsersViewController *referralUsersView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ReferralUsersView"];
    [self.navigationController pushViewController:referralUsersView animated:YES];
}

- (IBAction)refreshButtonPressed:(id)sender {
    self.isRefreshing = true;
    [self loadReferralData];
}

-(void)popHide{
    [self.pop hidePop];
}

- (void)setStyling {

    [CommonUtilities setView:self.btnInvite withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.codeView withCornerRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"E5E5E5"] withBorderWidth:1.0f];
    
    UIGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.referralCode addGestureRecognizer:gestureRecognizer];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"THEY GET $5 YOU GET $5"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FA3E3F"] range: NSMakeRange(9, 2)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FA3E3F"] range: NSMakeRange(20, 2)];
    [self.getTitle setAttributedText:string];
    
    NSMutableAttributedString *body = [[NSMutableAttributedString alloc] initWithString:@"When your friends sign up with your invite code, they get S$5 instantly. When they spend a total of S$25, you get S$5 too!"];
    [body addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13] range:NSMakeRange(62, 9)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    [body addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, body.length)];
    
    [self.bodyText setAttributedText:body];
    
    UINib *customNib = [UINib nibWithNibName:@"FZPopView" bundle:nil];
    self.pop = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.pop];
    self.pop.frame = window.frame;
    [self.pop hidePop];
 
}

- (void)setInfo{
    user = [UserController sharedInstance].currentUser;
    if (user) {
        self.referralCode.text = user.referralCode;
    }
}

- (void)loadReferralData{
    if(self.isRefreshing) {
         [self showLoader];
    } else {
        [self startActivities];
    }
    [UserController getFriendReferral:^(NSDictionary *dictionary, NSError *error) {
        
        if(self.isRefreshing) {
            [self hideLoader];
        } else {
            [self stopActivities];
        }
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
            }
        }
        if (dictionary) {
            NSString *credits = [dictionary objectForKey:@"credits"];
            if (credits) {
                self.creditsReward.text = [NSString stringWithFormat:@"S$%@", credits];
            } else{
                self.creditsReward.text = @"S$0";
            }
            
            int referred_users_count = [[dictionary objectForKey:@"referred_users_count"] intValue];
            if (referred_users_count) {
                self.totalReferralCount.text = [NSString stringWithFormat:@"%d", referred_users_count];
            } else{
                self.totalReferralCount.text = @"0";
            }
            
            int successful_referred_users_count = [[dictionary objectForKey:@"successful_referred_users_count"] intValue];
            if (successful_referred_users_count) {
                self.successfulReferralCount.text = [NSString stringWithFormat:@"%d", successful_referred_users_count];
            } else{
                self.successfulReferralCount.text = @"0";
            }
        }
    }];
}

- (void)startActivities{
    [self.successActivity startAnimating];
    [self.totalActivity startAnimating];
    [self.creditsAcitivy startAnimating];
    self.successfulReferralCount.hidden = YES;
    self.totalReferralCount.hidden = YES;
    self.creditsReward.hidden = YES;
}
- (void)stopActivities{
    [self.successActivity stopAnimating];
    [self.totalActivity stopAnimating];
    [self.creditsAcitivy stopAnimating];
    self.successfulReferralCount.hidden = NO;
    self.totalReferralCount.hidden = NO;
    self.creditsReward.hidden = NO;

}

#pragma mark - Gestures
- (void)longPressGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:recognizer.view.frame inView:recognizer.view.superview];
    [menuController setMenuVisible:YES animated:YES];
    [recognizer.view becomeFirstResponder];
}

@end
