//
//  RedeemValidTableViewCell.m
//  Fuzzie
//
//  Created by joma on 4/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedeemValidTableViewCell.h"

@implementation RedeemValidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(NSString *)validDate{

    if (validDate) {
        
        NSDate *redeemDate = [[GlobalConstants dateApiFormatter] dateFromString:validDate];
        NSDate *now = [NSDate date];
        
        if (redeemDate.hour > now.hour) {
            self.lbValid.text = [NSString stringWithFormat:@"Valid for %ld days from purchase", (long)[redeemDate daysFrom:now]];
        } else {
            self.lbValid.text = [NSString stringWithFormat:@"Valid for %ld days from purchase", (long)[redeemDate daysFrom:now] + 1];
        }
    }
}

@end
