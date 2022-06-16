//
//  JackpotSectionTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotSectionTableViewCell.h"

@implementation JackpotSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.lbCount withCornerRadius:8.0f];
    [self updateSortBy];
    [self updateRefine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSortBy) name:JACKPOT_SORT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRefine) name:JACKPOT_REFINE object:nil];
}

- (void)updateSortBy{
    self.lbSort.text = [FZData sharedInstance].jackpotListSortItemArray[[FZData sharedInstance].selectedJackpotSortIndex];
}

- (void)updateRefine{
    if ([FZData sharedInstance].selectedJackpotRefineSubCategoryIds.count == 0) {
        self.lbRefine.text = @"All";
        self.lbCount.hidden = YES;
    } else{
        self.lbRefine.text = @"Subcategories";
        self.lbCount.hidden = NO;
        self.lbCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[FZData sharedInstance].selectedJackpotRefineSubCategoryIds.count];
    }
}

- (IBAction)sortButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sortButtonPressed)]) {
        [self.delegate sortButtonPressed];
    }
}

- (IBAction)refineButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(refineButtonPressed)]) {
        [self.delegate refineButtonPressed];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_SORT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_REFINE object:nil];
}

@end
