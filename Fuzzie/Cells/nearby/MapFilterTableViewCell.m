//
//  MapFilterTableViewCell.m
//  Fuzzie
//
//  Created by mac on 7/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "MapFilterTableViewCell.h"

@implementation MapFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.checkImage.hidden = YES;
}

- (void)setCell:(NSDictionary *)dictionary{
    if (dictionary) {
        self.dictionary = dictionary;
        [self.iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sub-category-96-%@", dictionary[@"id"]]]];
        [self.nameLabel setText:dictionary[@"name"]];
        
        if ([[FZData sharedInstance].filterSubCategoryIds containsObject:dictionary[@"id"]]) {
            self.checkImage.hidden = NO;
            self.isSelected = TRUE;
        } else{
            self.checkImage.hidden = YES;
            self.isSelected = FALSE;
        }
    }
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:with:)]) {
        
        self.isSelected = !self.isSelected;
        [self updateCheckState];
        
        if (self.dictionary) {
            [self.delegate cellTapped:self with:self.dictionary];
        }
    }
}

- (void)updateCheckState{
    if (self.isSelected) {
        self.checkImage.hidden = NO;
    } else{
        self.checkImage.hidden = YES;
    }
}

@end
