//
//  OrderDetailsDateTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderDetailsDateTableViewCell.h"

@implementation OrderDetailsDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    if (dict) {
        
        NSDate *orderDate = [[GlobalConstants standardFormatter] dateFromString:dict[@"created_at"]];
        NSString *orderDateString = [[GlobalConstants dateOrderHistoryFormatter] stringFromDate:orderDate];
        [self.lbDate setText:[[orderDateString stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"] stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]];
        
        [self.lbOrderNumber setText:[NSString stringWithFormat:@"#%@", dict[@"order_number"]]];

    }
}

@end
