//
//  JackpotTicketUseTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 1/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketUseTableViewCell.h"

@implementation JackpotTicketUseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnUse withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnGetMore withCornerRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];

}

- (void)initCell{
    
    NSString *tickets = @"";
    int availableCounts = [[UserController sharedInstance].currentUser.availableJackpotTicketsCount intValue];
    
    if (availableCounts <= 1) {
        tickets = [NSString stringWithFormat:@"%d JACKPOT TICKET", availableCounts];
    } else {
        tickets = [NSString stringWithFormat:@"%d JACKPOT TICKETS", availableCounts];
    }
    
    if(availableCounts == 0){
        
        [CommonUtilities setView:self.btnUse withBackground:[UIColor colorWithHexString:@"#4F4F4F"] withRadius:4.0f];
        self.btnUse.enabled = false;
        
    } else{
        
        [CommonUtilities setView:self.btnUse withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        self.btnUse.enabled = true;
    }
    
    NSString *available = [NSString stringWithFormat:@"%@ AVAILABLE", tickets];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:available attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EAB202"] range:[available rangeOfString:tickets]];
    
    self.lbTickets.attributedText = attributedString;
    
    if ([UserController sharedInstance].currentUser.jackpotTicketsExpirationDate){
        
        self.lbValid.text = [NSString stringWithFormat:@"Valid till %@", [[GlobalConstants jackpotTicketsValidFormatter] stringFromDate:[[GlobalConstants dateApiFormatter] dateFromString:[UserController sharedInstance].currentUser.jackpotTicketsExpirationDate]]];
        
    } else {
        
        self.lbValid.text = @"";
    }

    
}

- (IBAction)useButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(useButtonPressed)]) {
        
        [self.delegate useButtonPressed];
        
    }
    
}

- (IBAction)getMoreButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(getJackpotButtonPressed)]) {
        
        [self.delegate getJackpotButtonPressed];
        
    }
    
}
@end
