//
//  BrandListRefineTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandListRefineTableViewCell.h"

@implementation BrandListRefineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.ivCheck.hidden = YES;
}

- (void)setCell:(NSDictionary *)dictionary{
    if (dictionary) {
        self.dictionary = dictionary;
        [self.ivSubCategory setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sub-category-96-%@", dictionary[@"id"]]]];
        [self.lbName setText:dictionary[@"name"]];
        
        if ([[FZData sharedInstance].selectedRefineSubCategoryIds containsObject:dictionary[@"id"]]) {
            self.ivCheck.hidden = NO;
            self.isSelected = TRUE;
        } else{
            self.ivCheck.hidden = YES;
            self.isSelected = FALSE;
        }
    }
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:withDict:)]) {
        
        self.isSelected = !self.isSelected;
        [self updateCheckState];
        
        if (self.dictionary) {
            [self.delegate cellTapped:self withDict:self.dictionary];
        }
    }
}

- (void)updateCheckState{
    if (self.isSelected) {
        self.ivCheck.hidden = NO;
    } else{
        self.ivCheck.hidden = YES;
    }
}

@end
