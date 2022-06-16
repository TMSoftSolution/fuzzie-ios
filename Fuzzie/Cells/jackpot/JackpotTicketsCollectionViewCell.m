//
//  JackpotTicketsCollectionViewCell.m
//  Fuzzie
//
//  Created by mac on 9/25/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsCollectionViewCell.h"
#import "SDVersion.h"

@implementation JackpotTicketsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.lbTicket withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"#E0E0E0"] withBorderWidth:1.0f];
     [CommonUtilities setView:self.lbCount withBackground:[UIColor whiteColor] withRadius:self.lbCount.bounds.size.width/2 withBorderColor:[UIColor colorWithHexString:@"#E0E0E0"] withBorderWidth:1.0f];
    
    if ([SDVersion deviceSize] >= Screen4Dot7inch) {
        self.ticketWidth.constant = 61.5f;
        self.ticketHeight.constant = 35.0f;
    } else{
        self.ticketWidth.constant = 64.0f;
        self.ticketHeight.constant = 36.0f;
    }
}

- (void)setCell:(NSString *)ticket count:(NSUInteger)count matched:(BOOL)matched{
    self.lbTicket.text = ticket;
    
    if (matched) {
        [CommonUtilities setView:self.lbTicket withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"#CC3334"] withBorderWidth:1.0f];
        self.lbTicket.textColor = [UIColor whiteColor];
    } else {
        [CommonUtilities setView:self.lbTicket withBackground:[UIColor whiteColor] withRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"#E0E0E0"] withBorderWidth:1.0f];
        self.lbTicket.textColor = [UIColor colorWithHexString:@"#3B3B3B"];
    }
    
    if (count > 1) {
        self.lbCount.hidden = NO;
        self.lbCount.text = [NSString stringWithFormat:@"%ldX", count];
    } else{
        self.lbCount.hidden = YES;
    }
}

@end
