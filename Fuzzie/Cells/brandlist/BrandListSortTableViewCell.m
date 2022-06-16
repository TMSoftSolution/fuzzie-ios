//
//  BrandListSortTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandListSortTableViewCell.h"

@implementation BrandListSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.ivCheck.hidden = YES;
}

- (void)setCellWith:(int)position withSelect:(BOOL)selected{
    
    self.position = position;
    self.isSelected = selected;
    
    if (selected) {
        self.ivCheck.hidden = NO;
    } else{
        self.ivCheck.hidden = YES;
    }
    
    self.lbName.text = [[FZData sharedInstance].brandListSortItemArray objectAtIndex:position];
    
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        [self.delegate cellTapped:self.position];
    }
}


@end
