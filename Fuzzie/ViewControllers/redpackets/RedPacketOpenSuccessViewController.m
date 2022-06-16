//
//  RedPacketOpenSuccessViewController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketOpenSuccessViewController.h"
#import "RedPacketOpenChampionViewController.h"
#import "RedPacketReceiveDetailsViewController.h"

@interface RedPacketOpenSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UILabel *lbCredits;
@property (weak, nonatomic) IBOutlet UILabel *lbTicket;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditsContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ticketContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditsContainerBottomConstraint;

- (IBAction)continueButtonPressed:(id)sender;

@end

@implementation RedPacketOpenSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnContinue withBackground:[UIColor whiteColor] withRadius:4.0f];
    
    if (self.redPacket) {
        
        self.isChampion = [self.redPacket[@"champion"] boolValue];
        if (self.isChampion) {
            
            [self.btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
        
        } else {
            
            [self.btnContinue setTitle:@"GOT IT" forState:UIControlStateNormal];
            
        }
        
        NSNumber *credits = self.redPacket[@"value"];
        NSNumber *ticketCounts = self.redPacket[@"number_of_jackpot_tickets"];
        if (credits.floatValue > 0.0f) {
            
            self.lbCredits.attributedText = [CommonUtilities getFormattedValueWithPrice:self.redPacket[@"value"] mainFontName:FONT_NAME_LATO_BLACK mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:16.0f];
            
        } else{
            
            self.creditsContainerHeightConstraint.constant = 0.0f;
            self.creditsContainerBottomConstraint.constant = 0.0f;
        }
        
        if (ticketCounts.intValue > 0) {
            
            self.lbTicket.text = [NSString stringWithFormat:@"X%@", ticketCounts];
            
        } else{
            
            self.ticketContainerHeightConstraint.constant = 0.0f;
            
        }
        
        if (credits.floatValue > 0 && ticketCounts.intValue > 0) {
            
            NSAttributedString *creditString = [CommonUtilities getFormattedValueWithPrice:credits mainFontName:FONT_NAME_LATO_BLACK mainFontSize:14.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:14.0f];
            
            NSString *ticketString = @"";
            if (ticketCounts.intValue == 1) {
                ticketString = @"1 Jackpot Ticket";
            } else{
                ticketString = [NSString stringWithFormat:@"%@ Jackpot Tickets", ticketCounts];
            }
            
            NSString *string = [NSString stringWithFormat:@" Fuzzie Credits and %@ have been added to your account.", ticketString];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:14.0f] range:[string rangeOfString:ticketString]];
            
            NSMutableAttributedString *body = [[NSMutableAttributedString alloc] initWithAttributedString:creditString];
            [body appendAttributedString:attributedString];
            
            NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
            paragrapStyle.lineHeightMultiple = 1.2;
            paragrapStyle.alignment = NSTextAlignmentCenter;
            [body addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, body.length)];
            
            self.lbBody.attributedText = body;
            
        } else {
            
            if (credits.floatValue > 0.0f) {
                
                NSAttributedString *creditString = [CommonUtilities getFormattedValueWithPrice:self.redPacket[@"value"] mainFontName:FONT_NAME_LATO_BLACK mainFontSize:14.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:14.0f];
                
                NSString *string = @" Fuzzie Credits have been added to your account.";
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}];
                
                NSMutableAttributedString *body = [[NSMutableAttributedString alloc] initWithAttributedString:creditString];
                [body appendAttributedString:attributedString];
                
                NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
                paragrapStyle.lineHeightMultiple = 1.2;
                paragrapStyle.alignment = NSTextAlignmentCenter;
                [body addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, body.length)];
                
                self.lbBody.attributedText = body;
                
            } else if (ticketCounts.intValue > 0){
                
                NSString *ticketString = @"";
                if (ticketCounts.intValue == 1) {
                    ticketString = @"1 Jackpot Ticket";
                } else{
                    ticketString = [NSString stringWithFormat:@"%@ Jackpot Tickets", ticketCounts];
                }
                
                NSString *string = [NSString stringWithFormat:@"%@ have been added to your account.", ticketString];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:14.0f]}];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:14.0f] range:[string rangeOfString:ticketString]];
                
                NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
                paragrapStyle.lineHeightMultiple = 1.2;
                paragrapStyle.alignment = NSTextAlignmentCenter;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attributedString.length)];
                
                self.lbBody.attributedText = attributedString;
            }
        }

    }
}

#pragma mark - IBAction Helper
- (IBAction)continueButtonPressed:(id)sender {
    
    if (self.isChampion) {
        
        RedPacketOpenChampionViewController *championView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketOpenChampionView"];
        championView.redPacket = self.redPacket;
        [self.navigationController pushViewController:championView animated:YES];
        
    } else {
        
        [self goRedPacketHistoryPage];
    }

}

- (void)goRedPacketHistoryPage{

    UIViewController *walletView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"WalletView"];
    
    UIViewController *redPacketHistoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketHistoryView"];
    redPacketHistoryView.hidesBottomBarWhenPushed = YES;
    
    RedPacketReceiveDetailsViewController *receiveDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"RedPacketReceiveDetailsView"];
    receiveDetailsView.redPacket = self.redPacket;
    receiveDetailsView.hidesBottomBarWhenPushed = YES;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:walletView, redPacketHistoryView, receiveDetailsView, nil];
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
