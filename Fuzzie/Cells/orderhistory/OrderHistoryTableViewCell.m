//
//  OrderHistoryTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderHistoryTableViewCell.h"

@implementation OrderHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    if (dict) {
        
        self.dict = dict;

        NSDate *orderDate = [[GlobalConstants standardFormatter] dateFromString:dict[@"created_at"]];
        NSString *orderDateString = [[GlobalConstants dateOrderHistoryFormatter] stringFromDate:orderDate];
        [self.lbDate setText:[[orderDateString stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"] stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]];
        
        [self.lbOrderNumber setText:[NSString stringWithFormat:@"#%@", dict[@"order_number"]]];
        
        NSNumber *totalPrice = dict[@"total_price"];
        self.lbTotalPrice.attributedText = [CommonUtilities getFormattedCashbackValue:totalPrice fontSize:13.0f smallFontSize:10.0f];
        
        NSNumber *totalCashBack = dict[@"total_cash_back"] ;
        if ([totalCashBack floatValue] <= 0) {
            self.cashbackView.hidden = YES;
        } else {
            self.cashbackView.hidden = NO;
            self.lbCashback.attributedText = [CommonUtilities getFormattedCashbackValue:totalCashBack fontSize:13.0f smallFontSize:10.0f];

        }
    }
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        [self.delegate cellTapped:self.dict];
    }
}

@end
