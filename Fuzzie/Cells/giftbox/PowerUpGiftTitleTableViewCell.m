//
//  PowerUpGiftTitleTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpGiftTitleTableViewCell.h"

@implementation PowerUpGiftTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(NSDictionary *)giftDict{
    
    if (giftDict) {
        
        if ([giftDict[@"time_to_expire"] intValue] == 1) {
            self.lbName.text = @"Power Up Card - 1 hour";
        } else {
            self.lbName.text = [NSString stringWithFormat:@"Power Up Card - %d hours", [giftDict[@"time_to_expire"] intValue]];
        }
    }
}
@end
