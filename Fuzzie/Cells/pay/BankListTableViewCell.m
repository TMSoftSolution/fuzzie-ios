//
//  BankListTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BankListTableViewCell.h"

@implementation BankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGusture.delegate = self;
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:tapGusture];
}

- (void)setCellWith:(NSDictionary *)dict{
    
    if (dict) {
        
        self.dict = dict;
        
        [self.ivBank sd_setImageWithURL:dict[@"banner"] placeholderImage:nil];
    }
    
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        [self.delegate cellTapped:self.dict];
    }
}

@end
