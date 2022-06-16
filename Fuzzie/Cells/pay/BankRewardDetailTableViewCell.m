//
//  BankRewardDetailTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankRewardDetailTableViewCell.h"

@implementation BankRewardDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.symbolView withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:3.0f];
}

@end
