//
//  BankTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankTableViewCell.h"

@implementation BankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGusture.delegate = self;
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:tapGusture];
}

- (void)setCellWith:(NSDictionary *)cardDict{
    
    if (cardDict) {
        
        self.cardDict = cardDict;
        
        [self.ivCard sd_setImageWithURL:cardDict[@"banner"] placeholderImage:[UIImage imageNamed:@"image-card"]];
        self.lbCardName.text = cardDict[@"title"];
        self.lbCashback.text = cardDict[@"preview_copy"];
    }
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        [self.delegate cellTapped:self.cardDict];
    }
}

@end
