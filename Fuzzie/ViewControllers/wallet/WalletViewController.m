//
//  WalletViewController.m
//  Fuzzie
//
//  Created by mac on 9/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "WalletViewController.h"
#import "TopUpFuzzieCreditsViewController.h"
#import "GiftBoxViewController.h"
#import "JackpotTicketsViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "RedPacketHistoryViewController.h"

@interface WalletViewController ()

@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIButton *btnTopUp;
@property (weak, nonatomic) IBOutlet UIView *cardContainer;
@property (weak, nonatomic) IBOutlet UIView *ticketContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbCardBadge;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketBadge;
@property (weak, nonatomic) IBOutlet UIView *redPacketContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbRedPacketBadge;
@property (weak, nonatomic) IBOutlet UILabel *lbActiveGiftCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketCount;
@property (weak, nonatomic) IBOutlet UILabel *lbRedPacketCount;

- (IBAction)topUpButtonPressed:(id)sender;
- (IBAction)cardButtonPressed:(id)sender;
- (IBAction)ticketButtonPressed:(id)sender;
- (IBAction)redPacketButtonPressed:(id)sender;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:SHOULD_REFRESH_USER object:nil];
    
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshUserInfo];
}

- (void)setStyling{
    
    self.balanceView.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    
    [CommonUtilities setView:self.btnTopUp withBackground:[UIColor whiteColor] withRadius:14.0f];
    [CommonUtilities setView:self.lbCardBadge withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:self.lbCardBadge.bounds.size.height / 2];
    [CommonUtilities setView:self.lbTicketBadge withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:self.lbCardBadge.bounds.size.height / 2];
     [CommonUtilities setView:self.lbRedPacketBadge withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:self.lbCardBadge.bounds.size.height / 2];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self setShadow:self.cardContainer];
    [self setShadow:self.ticketContainer];
    [self setShadow:self.redPacketContainer];
}

- (void)setShadow:(UIView*)view{
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4.0f;
    view.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.05f].CGColor;
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    view.layer.shadowRadius = 6.0f;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

- (void)refreshUserInfo{
    
    self.user = [UserController sharedInstance].currentUser;
    
    [self setBalance];
    
    [self setCardBadge];
    [self setTicketBadge];
    [self setRedPacketBadge];
    
    [self setCardCount];
    [self setTicketCount];
    [self setRedPacketCount];
}

- (void)setBalance{
    
    self.lbBalance.attributedText = [CommonUtilities getFormattedValue:self.user.credits fontSize:30.0f smallFontSize:20.0f];

}

- (void)setCardBadge{
    
    if (self.user.unOpenedActiveGiftCount && self.user.unOpenedActiveGiftCount.intValue > 0) {
        self.lbCardBadge.hidden = NO;
        self.lbCardBadge.text = [NSString stringWithFormat:@"%d", self.user.unOpenedActiveGiftCount.intValue];
    } else{
        self.lbCardBadge.hidden = YES;
    }
}

- (void)setTicketBadge{
    
    if (self.user.unOpenedTicketCount && self.user.unOpenedTicketCount.intValue > 0) {
        self.lbTicketBadge.hidden = NO;
        self.lbTicketBadge.text = [NSString stringWithFormat:@"%d", self.user.unOpenedTicketCount.intValue];
    } else{
        self.lbTicketBadge.hidden = YES;
    }
}

- (void)setRedPacketBadge{
    
    if (self.user.unOpenedRedPacketCount && self.user.unOpenedRedPacketCount.intValue > 0) {
        self.lbRedPacketBadge.hidden = NO;
        self.lbRedPacketBadge.text = [NSString stringWithFormat:@"%d", self.user.unOpenedRedPacketCount.intValue];
    } else{
        self.lbRedPacketBadge.hidden = YES;
    }
}

- (void)setCardCount{
    
    if (self.user.activeGiftCount && self.user.activeGiftCount.intValue > 0) {
        
        if (self.user.activeGiftCount.intValue == 1) {
            
            self.lbActiveGiftCount.text = [NSString stringWithFormat:@"%d active card", self.user.activeGiftCount.intValue];
            
        } else {
            
            self.lbActiveGiftCount.text = [NSString stringWithFormat:@"%d active cards", self.user.activeGiftCount.intValue];
        }
   
        
    } else {
        
        self.lbActiveGiftCount.text = @"";
    }
}

- (void)setTicketCount{
    
    if (self.user.availableJackpotTicketsCount && self.user.availableJackpotTicketsCount.intValue > 0) {
        
        if (self.user.availableJackpotTicketsCount.intValue == 1) {
            
            self.lbTicketCount.text = [NSString stringWithFormat:@"%d ticket available", self.user.availableJackpotTicketsCount.intValue];
            
        } else {
            
            self.lbTicketCount.text = [NSString stringWithFormat:@"%d tickets available", self.user.availableJackpotTicketsCount.intValue];
        }
        
        
    } else {
        
        self.lbTicketCount.text = @"";
    }
}

- (void)setRedPacketCount{
    
    int count = self.user.unOpenedRedPacketCount.intValue + self.user.openedRedPAcketCount.intValue;
    
    if (count > 0) {
        
        if (count == 1) {
            
            self.lbRedPacketCount.text = [NSString stringWithFormat:@"%d packet received", count];
            
        } else {
            
            self.lbRedPacketCount.text = [NSString stringWithFormat:@"%d packets received", count];
        }
        
        
    } else {
        
        self.lbRedPacketCount.text = @"";
    }
}

#pragma mark - IBAction Helper
- (IBAction)topUpButtonPressed:(id)sender {

    TopUpFuzzieCreditsViewController *topUpView = [[GlobalConstants topUpStoryboard] instantiateViewControllerWithIdentifier:@"TopUpFuzzieCreditsView"];
    topUpView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topUpView animated:YES];
}

- (IBAction)cardButtonPressed:(id)sender {
    GiftBoxViewController *giftBoxView = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftBoxView"];
    giftBoxView.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:giftBoxView animated:YES];
}

- (IBAction)ticketButtonPressed:(id)sender {
    
    if ([FZData sharedInstance].enableJackpot) {

        JackpotTicketsViewController *ticketsView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotTicketsView"];
        ticketsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ticketsView animated:YES];
    }
}

- (IBAction)redPacketButtonPressed:(id)sender {
    
    RedPacketHistoryViewController *redPacketHistoryView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
    redPacketHistoryView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:redPacketHistoryView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
