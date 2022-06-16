//
//  ClubStoreListTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreListTableViewCell.h"

@implementation ClubStoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivStore withCornerRadius:2.0f];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGuesture];
}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict){
        
        self.dict = dict;
        
        self.lbBrandName.text = dict[@"brand_name"];
        self.lbStoreName.text = dict[@"store_name"];
        
        FZBrand *brand = [FZData getBrandById:dict[@"brand_id"]];
        if (brand) {
            
            [self.ivStore sd_setImageWithURL:[NSURL URLWithString:brand.backgroundImage] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
            
        }
        
        NSDictionary *brandType = [FZData getBrandType:dict[@"brand_type_id"]];
        if (brandType && brandType[@"image_black"] && ![brandType[@"image_black"] isKindOfClass:[NSNull class]]) {
            
            [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:brandType[@"image_black"]]];
            
        } else{
            
            self.ivCategory.image = nil;
        }
        
        NSArray *filters = dict[@"filter_components"];
        if (filters && filters.count > 0) {
            
            NSUInteger count = MIN(filters.count, 2);
            NSString *filterName = @"";
            for (int i = 0 ; i < count ; i ++) {
                
                filterName = [filterName stringByAppendingString:[NSString stringWithFormat:@"%@ ", [filters objectAtIndex:i][@"name"]]];
            }
            self.lbCategory.text = filterName;
            
        } else {
            
            self.lbCategory.text = @"";
        }
        
        if (dict[@"distance"] && ![dict[@"distance"] isKindOfClass:[NSNull class]]) {
            
            float distance = [dict[@"distance"] floatValue];
            self.lbDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
            
        } else {
            
            self.lbDistance.text = @"";
        }
    }
    
}

- (void)cellTapped{
    
    if ([self.delegate respondsToSelector:@selector(clubStoreListCellTapped:)]) {
        [self.delegate clubStoreListCellTapped:self.dict];
    }
}

@end
