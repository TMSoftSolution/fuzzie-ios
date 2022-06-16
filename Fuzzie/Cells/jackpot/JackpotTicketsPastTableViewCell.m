//
//  JackpotTicketsPastTableViewCell.m
//  Fuzzie
//
//  Created by joma on 4/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsPastTableViewCell.h"

@implementation JackpotTicketsPastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:gusture];
}

- (void)cellTapped{
    
    if ([self.delegate respondsToSelector:@selector(viewPastResultPressed)]){
        [self.delegate viewPastResultPressed];
    }
}

@end
