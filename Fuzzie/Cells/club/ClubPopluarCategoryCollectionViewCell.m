//
//  ClubPopluarCategoryCollectionViewCell.m
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubPopluarCategoryCollectionViewCell.h"

@implementation ClubPopluarCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.contentView withCornerRadius:2.0f];
}

- (void)setCell:(NSDictionary *)category{
    
    if (category) {
        
        self.category = category;
        
        if (category[@"picture"] && ![category[@"picture"] isKindOfClass:[NSNull class]]) {
            
            [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:category[@"picture"]] placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
        }
        
        self.lbCategory.text = [category[@"name"] uppercaseString];
    }
}

- (void)setCellWith:(NSDictionary *)category checked:(BOOL)checked{
    
    if (category) {
        
        self.category = category;
        
        if (category[@"picture"] && ![category[@"picture"] isKindOfClass:[NSNull class]]) {
            
            [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:category[@"picture"]] placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
        }
        
        self.lbCategory.text = [category[@"name"] uppercaseString];
    }
    
    if (checked) {
        
        self.selectedBackground.hidden = NO;
        
    } else {
        
        self.selectedBackground.hidden = YES;
    }
}

@end
