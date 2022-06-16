//
//  RedPacketsViewController.m
//  Fuzzie
//
//  Created by Joma on 2/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketsViewController.h"
#import "FZTabBarViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "RedPacketAddItemsViewController.h"

@interface RedPacketsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLearnMore;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketsCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightAnchor;
@property (weak, nonatomic) IBOutlet UIButton *btnPerson;
@property (weak, nonatomic) IBOutlet UIButton *btnGroup;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)learnMoreButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)personButtonPressed:(id)sender;
- (IBAction)groupButtonPressed:(id)sender;

@end

@implementation RedPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnLearnMore withBackground:[UIColor clearColor] withRadius:13.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    [CommonUtilities setView:self.btnPerson withCornerRadius:4.0f];
    [CommonUtilities setView:self.btnGroup withCornerRadius:4.0f];
    
    if ([[UserController sharedInstance].currentUser.isFirstToSendRedPacket boolValue]) {
        
        self.bannerHeightAnchor.constant = 0.0f;
        
    } else {
        
        NSNumber *ticketsCount = [FZData sharedInstance].assignedTicketsCountWithRedPacketBundle;
        if (ticketsCount) {
            
            if ([ticketsCount intValue] == 1) {
                
                self.lbTicketsCount.text = [NSString stringWithFormat:@"GET %@ FREE JACKPOT TICKET", ticketsCount];
                
            } else {
                
                self.lbTicketsCount.text = [NSString stringWithFormat:@"GET %@ FREE JACKPOT TICKETS", ticketsCount];
            }
        }
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)learnMoreButtonPressed:(id)sender {
    
    JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    learnView.isRedPacket = YES;
    [self.navigationController pushViewController:learnView animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"Need help?"];
    
    [actionSheet bk_addButtonWithTitle:@"Read our FAQ" handler:^{

        JackpotLearnMoreViewController *learnView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
        learnView.isRedPacket = YES;
        [self.navigationController pushViewController:learnView animated:YES];
        
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        [actionSheet bk_addButtonWithTitle:@"Email us" handler:^{
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            [mailer setSubject: @"Fuzzie Support"];
            [mailer setToRecipients:@[@"support@fuzzie.com.sg"]];
            mailer.navigationBar.tintColor = [UIColor whiteColor];
            mailer.bk_completionBlock = ^( MFMailComposeViewController *mailer, MFMailComposeResult result, NSError* error) {
                
                if (result == MFMailComposeResultSent) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Email sent!", nil)];
                }
                
                [mailer dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:mailer animated:YES completion:nil];
            
        }];
    }
    
    [actionSheet bk_addButtonWithTitle:@"Facebook us" handler:^{
        NSURL *facebookURL = [NSURL URLWithString:@"http://m.me/fuzzieapp"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        }
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)personButtonPressed:(id)sender {
    
    RedPacketAddItemsViewController *addItemView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketAddItemsView"];
    addItemView.quantity = [NSNumber numberWithInt:1];
    [self.navigationController pushViewController:addItemView animated:YES];
}

- (IBAction)groupButtonPressed:(id)sender {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketQuantityView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
