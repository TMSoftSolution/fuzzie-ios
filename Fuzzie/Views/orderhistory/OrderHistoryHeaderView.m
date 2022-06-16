//
//  OrderHistoryHeaderView.m
//  Fuzzie
//
//  Created by mac on 8/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderHistoryHeaderView.h"

@implementation OrderHistoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.lbTotalCashback.attributedText = [CommonUtilities getFormattedValue:[UserController sharedInstance].currentUser.cashbackEarned fontSize:40.0f smallFontSize:20.0f];
}

@end
