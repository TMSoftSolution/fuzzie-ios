//
//  RedPacketAddItemsViewController.m
//  Fuzzie
//
//  Created by Joma on 3/28/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketAddItemsViewController.h"
#import "RedPacketAddMessageViewController.h"
#import "RedPacketAddCreditsViewController.h"
#import "RedPacketAddTicketViewController.h"
#import "RedPacketPayViewController.h"
#import "RedPacketPaySuccessViewController.h"
#import "RedPacketPaySuccessJackpotViewController.h"
#import "JackpotLearnMoreViewController.h"

@interface RedPacketAddItemsViewController () <RedPacketAddMessageViewControllerDelegate, RedPacketAddCreditsViewControllerDelegate, RedPacketAddTicketViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbCredits;
@property (weak, nonatomic) IBOutlet UILabel *lbTickets;
@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UIView *creditsContainer;
@property (weak, nonatomic) IBOutlet UIView *ticketContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnPrepare;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCreditBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbMessageTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketBalance;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrowMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbEditMessage;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrowCredits;
@property (weak, nonatomic) IBOutlet UILabel *lbEditCredits;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrowTicket;
@property (weak, nonatomic) IBOutlet UILabel *lbEditTicket;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)messageButtonPressed:(id)sender;
- (IBAction)creditsButtonPressed:(id)sender;
- (IBAction)ticketButtonPressed:(id)sender;
- (IBAction)prepareButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;

@property (nonatomic, assign) BOOL isNoMessage;
@property (nonatomic, assign) BOOL isEditDiscard;

@end

@implementation RedPacketAddItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    self.isRandomMode = true;
    self.message = @"";
    self.ticketCount = [NSNumber numberWithInt:0];
    self.creditAmount = [NSNumber numberWithInt:0];
    self.user = [UserController sharedInstance].currentUser;
}

- (void)setStyling{
    
    self.lbQuantity.text = [NSString stringWithFormat:@"%d", self.quantity.intValue];
    
    self.lbMessage.numberOfLines = 2;
    
    [CommonUtilities setView:self.messageContainer withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
    [CommonUtilities setView:self.creditsContainer withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
    [CommonUtilities setView:self.ticketContainer withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
    
    [self updateMessage];
    [self updateCredits];
    [self updateJackpotTicket];
    [self updatePrepareButton];
}

- (void)updateCredits{
    
    if (self.creditAmount.floatValue > 0) {
        
        self.lbEditCredits.hidden = NO;
        self.ivArrowCredits.hidden = YES;
        
        self.lbCredits.attributedText = [CommonUtilities getFormattedValueWithPrice:self.creditAmount mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:(NSString *)FONT_NAME_LATO_BOLD secondFontSize:13.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
        if (self.quantity.intValue == 1) {
            
            self.lbCreditBalance.text = [NSString stringWithFormat:@"S$%.2f", self.creditAmount.floatValue];
            
        } else {
            
            if (self.isRandomMode) {
                self.lbCreditBalance.text = @"Split randomly";
            } else {
                
                float each = self.creditAmount.floatValue / self.quantity.intValue;
                self.lbCreditBalance.text = [NSString stringWithFormat:@"S$%.2f in each packet", each];
            }

        }
        
        self.lbCreditTitle.text = @"FUZZIE CREDITS";
        
    } else{
        self.lbEditCredits.hidden = YES;
        self.ivArrowCredits.hidden = NO;
        
        self.lbCredits.text = @"S$0";
        self.lbCreditBalance.text = [NSString stringWithFormat:@"S$%.2f available", self.user.cashableCredits.floatValue];
        
        self.lbCreditTitle.text = @"ADD FUZZIE CREDITS";
    }
}

- (void)updateJackpotTicket{
    
    if (self.ticketCount.intValue > 0) {
        self.lbEditTicket.hidden = NO;
        self.ivArrowTicket.hidden = YES;
        
        if (self.ticketCount.intValue == 1) {
            self.lbTicketBalance.text = @"1 Jackpot ticket per packet";
        } else {
            self.lbTicketBalance.text = [NSString stringWithFormat:@"%@ Jackpot tickets per packet", self.ticketCount];
        }

        self.lbTickets.text = [NSString stringWithFormat:@"%d", self.ticketCount.intValue * self.quantity.intValue];
        self.lbTicketTitle.text = @"JACKPOT TICKETS";
        
    } else{
        self.lbEditTicket.hidden = YES;
        self.ivArrowTicket.hidden = NO;
        
        if (self.user.availableJackpotTicketsCount.intValue <= 1) {
            
            self.lbTicketBalance.text = [NSString stringWithFormat:@"%d Jackpot ticket available", self.user.availableJackpotTicketsCount.intValue];
            
        } else {
            
            self.lbTicketBalance.text = [NSString stringWithFormat:@"%d Jackpot tickets available", self.user.availableJackpotTicketsCount.intValue];
        }
        
        self.lbTickets.text = @"0";
        self.lbTicketTitle.text = @"ADD JACKPOT TICKETS";
        
    }
}

- (void)updateMessage{
    
    if (self.message.length > 0) {
        self.lbEditMessage.hidden = NO;
        self.ivArrowMessage.hidden = YES;
        
        self.lbMessage.text = [self.message stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        self.lbMessageTitle.text = @"YOUR MESSAGE";
        
    } else {
        self.lbEditMessage.hidden = YES;
        self.ivArrowMessage.hidden = NO;
        
        self.lbMessage.text = @"";
        self.lbMessageTitle.text = @"ADD A MESSAGE";
    }
}

- (void)updatePrepareButton{
    
    if (self.creditAmount.intValue > 0 || self.ticketCount.intValue > 0) {
        [self.btnPrepare setEnabled:YES];
        [CommonUtilities setView:self.btnPrepare withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    } else {
        [self.btnPrepare setEnabled:false];
        [CommonUtilities setView:self.btnPrepare withBackground:[UIColor colorWithHexString:@"#DADADA"] withRadius:4.0f];
    }
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    if (self.message.length > 0 || self.creditAmount.floatValue > 0.0f || self.ticketCount.intValue > 0) {
        
        [self.view endEditing:YES];
        [self showError:@"Do you wish to discard your Lucky Packet?" headerTitle:@"DISCARD LUCKY PACKET?" buttonTitle:@"YES, DISCARD" image:@"bear-dead" window:YES];
        self.popView.btnCancel.hidden = NO;
        self.isEditDiscard = true;
        
    } else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)messageButtonPressed:(id)sender {
    
    RedPacketAddMessageViewController *messageView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketAddMessageView"];
    messageView.message = self.message;
    messageView.delegate = self;
    [self.navigationController pushViewController:messageView animated:YES];
}

#pragma mark - RedPacketAddMessageViewControllerDelegate
- (void)messageAdded:(NSString *)message{
    self.message = message;
    [self updateMessage];
}

- (IBAction)creditsButtonPressed:(id)sender {
    
    RedPacketAddCreditsViewController *creditsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketAddCreditsView"];
    creditsView.isRandomMode = self.isRandomMode;
    creditsView.creditAmount = self.creditAmount;
    creditsView.quantity = self.quantity;
    creditsView.delegate = self;
    [self.navigationController pushViewController:creditsView animated:YES];
}

#pragma mark - RedPacketAddCreditsViewControllerDelegate
- (void)creditAdded:(NSNumber *)credit isRandomMode:(BOOL)isRandomMode{
    self.creditAmount = credit;
    self.isRandomMode = isRandomMode;
    [self updateCredits];
    [self updatePrepareButton];
}

- (IBAction)ticketButtonPressed:(id)sender {
    
    RedPacketAddTicketViewController *ticketView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketAddTicketView"];
    ticketView.quantity = self.quantity;
    ticketView.ticketCount = self.ticketCount;
    ticketView.delegate = self;
    [self.navigationController pushViewController:ticketView animated:YES];
}

#pragma mark - RedPacketAddTicketViewControllerDelegate
- (void)ticketAdded:(NSNumber *)ticketCount{
    self.ticketCount = ticketCount;
    [self updateJackpotTicket];
    [self updatePrepareButton];
}

- (IBAction)prepareButtonPressed:(id)sender {
    
    if (self.message.length > 0) {
        
        if (self.creditAmount.floatValue > 0.0f) {
            [self goRedPacketPaymentPage];
        } else {
            [self processPayment];
        }
        
    } else {
        
        [self showError:@"Are you sure you want to send your Lucky Packet without a message?" headerTitle:@"NO MESSAGE?" buttonTitle:@"YES, CONTINUE" image:@"bear-normal" window:YES];
        self.popView.btnCancel.hidden = NO;
        self.isNoMessage = true;
    }
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

- (void)goRedPacketPaymentPage{

    RedPacketPayViewController *payView = [[GlobalConstants paymentStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketPayView"];
    payView.isRandomMode = self.isRandomMode;
    payView.message = self.message;
    payView.total = self.creditAmount;
    payView.quantity = self.quantity;
    payView.ticketCount = self.ticketCount;
    [self.navigationController pushViewController:payView animated:YES];
}

- (void)processPayment{
    
    NSString *splitType = @"";
    if (self.isRandomMode) {
        splitType = @"RANDOM";
    } else{
        splitType = @"EQUAL";
    }
    
    if (!self.message) {
        self.message = @"";
    }

    [self showProcessing:NO];
    
    [RedPacketController makeRedPacketsBundle:self.message numberOfRedPackets:[self.quantity intValue] splitType:splitType value:0 ticketCount:self.ticketCount promoCode:nil completion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hidePopView];
        
        [self handleSuccessfulPaymentWithDict:dictionary andError:error];
        
    }];
    
}


- (void)handleSuccessfulPaymentWithDict:(NSDictionary *)dictionary andError:(NSError *)error {
    
    if (dictionary) {
        
        [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
            if (error && error.code == 417) {
                [AppDelegate logOut];
            }
        }];
        
        if (dictionary[@"red_packet_bundle"]) {
            
            if ([FZData sharedInstance].sentRedPacketBundles) {
                [[FZData sharedInstance].sentRedPacketBundles insertObject:dictionary[@"red_packet_bundle"] atIndex:0];
            } else {
                [RedPacketController getSentRedPacketBundles:nil];
            }
        } else {
            [RedPacketController getSentRedPacketBundles:nil];
        }
        
        if ([[UserController sharedInstance].currentUser.isFirstToSendRedPacket boolValue]) {
            
            RedPacketPaySuccessViewController *paySuccessView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketPaySuccessView"];
            paySuccessView.successDict = dictionary;
            [self.navigationController pushViewController:paySuccessView animated:YES];
            
        } else {
            
            RedPacketPaySuccessJackpotViewController *paySuccessView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketPaySuccessJackpotView"];
            paySuccessView.successDict = dictionary;
            [self.navigationController pushViewController:paySuccessView animated:YES];
            
        }
    }
    
    if (error) {
        
        if (error.code == 417) {
            [AppDelegate logOut];
            return;
        }
        
        [self showError:[error localizedDescription] headerTitle:@"OOPS!" buttonTitle:@"OK" image:@"bear-dead" window:NO];
    }
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    [super okButtonClicked];
    
    if (self.isNoMessage) {
        if (self.creditAmount.floatValue > 0.0f) {
            [self goRedPacketPaymentPage];
        } else {
            [self processPayment];
        }
        self.isNoMessage = false;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelButtonClicked{
    [super cancelButtonClicked];
    
    self.isNoMessage = false;
    self.isEditDiscard = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
