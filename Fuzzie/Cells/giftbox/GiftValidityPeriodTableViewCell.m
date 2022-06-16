//
//  GiftValidityPeriodTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 12/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftValidityPeriodTableViewCell.h"

@implementation GiftValidityPeriodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.offerView withBackground:[UIColor colorWithHexString:@"#D8D8D8"] withRadius:2.0f];
}

- (void)setCellWith:(NSDictionary *)dict{
    
}

@end
