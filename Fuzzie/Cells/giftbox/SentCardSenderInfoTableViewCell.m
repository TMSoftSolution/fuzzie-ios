//
//  SentCardSenderInfoTableViewCell.m
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "SentCardSenderInfoTableViewCell.h"

@implementation SentCardSenderInfoTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWith:(NSDictionary *)dict{
    if (dict) {
        self.giftDict = dict;
        self.lbSenderName.text = dict[@"receiver"][@"name"];
        self.lbMessage.text = dict[@"message"];
    }
}

- (IBAction)editButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editButtonPressed)]) {
        [self.delegate editButtonPressed];
    }
}

@end
