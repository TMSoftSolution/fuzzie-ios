//
//  ClubTopBrandCollectionViewCell.m
//  Fuzzie
//
//  Created by Joma on 11/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "ClubTopBrandCollectionViewCell.h"

@implementation ClubTopBrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.contentView withCornerRadius:2.0f];
}

- (void)setCell:(FZBrand *)brand{
    
    if (brand) {
        
        NSURL *imageURL = [NSURL URLWithString:brand.customImage];
        [self.ivTopBrand sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
}

@end
