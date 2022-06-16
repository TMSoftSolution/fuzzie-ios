//
//  ClubFlashCollectionViewCell.m
//  Fuzzie
//
//  Created by joma on 6/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubFlashCollectionViewCell.h"

@implementation ClubFlashCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.contentView withCornerRadius:4.0f];
}

- (void)setCell:(NSDictionary *)offer{
    
    if (offer) {
        
        self.offer = offer;
        
        if (offer[@"image_url"] && ![offer[@"image_url"] isKindOfClass:[NSNull class]]) {
            
            [self.ivFlash sd_setImageWithURL:[NSURL URLWithString:offer[@"image_url"]] placeholderImage:[UIImage imageNamed:@"club-offer-placeholder"]];
        }
        
        FZBrand *brand = [FZData getBrandById:offer[@"brand_id"]];
        
        if (brand && [FZData sharedInstance].subCategoryArray) {
            
            NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
            for (NSDictionary *categoryDict in subCategoryArray) {
                if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:brand.subcategoryId]) {
                    
                    NSString *imageName = [NSString stringWithFormat:@"sub-category-white-96-%@",[categoryDict[@"id"] stringValue]];
                    self.ivCategory.image = [UIImage imageNamed:imageName];
                    self.lbCategory.text = categoryDict[@"name"];
                    
                    break;
                }
            }
            
        } else {
            self.ivCategory.image = nil;
            self.lbCategory.text = @"";
        }
    }
}

@end
