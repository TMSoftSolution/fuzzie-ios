//
//  ClubFlashTableViewCell.m
//  Fuzzie
//
//  Created by joma on 7/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubFlashTableViewCell.h"

@implementation ClubFlashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivFlash withCornerRadius:4.0f];
}

- (void)setCell:(NSDictionary *)dict{

    if (dict) {
        
        self.dict = dict;
        
        if (dict[@"image_url"]) {
            
            [self.ivFlash sd_setImageWithURL:[NSURL URLWithString:dict[@"image_url"]] placeholderImage:[UIImage imageNamed:@"club-offer-placeholder"]];
        }
        
        FZBrand *brand = [FZData getBrandById:dict[@"brand_id"]];
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
