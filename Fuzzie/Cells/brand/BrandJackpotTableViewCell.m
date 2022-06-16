//
//  BrandJackpotTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandJackpotTableViewCell.h"

@implementation BrandJackpotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGusture];

    
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(jackpotCellTapped)]) {
        [self.delegate jackpotCellTapped];
    }
}

@end
