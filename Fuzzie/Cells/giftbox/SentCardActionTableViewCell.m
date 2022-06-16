//
//  SentCardActionTableViewCell.m
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "SentCardActionTableViewCell.h"

@implementation SentCardActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnSend withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWith:(NSDictionary *)dict{
    if (dict) {
        self.giftDict = dict;
    
        NSDateFormatter *validityFormatter;
        if (!validityFormatter) {
            validityFormatter = [NSDateFormatter new];
            [validityFormatter setDateFormat:@"d MMM yyyy"];
        }
        
        NSDate *expiryDate = [[GlobalConstants standardFormatter] dateFromString:dict[@"expiration_date"]];
        self.lbValideDate.text = [NSString stringWithFormat:@"%@" , [validityFormatter stringFromDate:expiryDate]];
        
        NSDate *sentDate = [[GlobalConstants standardFormatter] dateFromString:dict[@"sent_time"]];
        self.lbSentDate.text = [NSString stringWithFormat:@"%@" , [validityFormatter stringFromDate:sentDate]];
        
        self.lbOrderNumber.text = [NSString stringWithFormat:@"%@" , dict[@"order_number"]];
    }
}

- (IBAction)sendButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendButtonPressed)]) {
        [self.delegate sendButtonPressed];
    }
}


@end
