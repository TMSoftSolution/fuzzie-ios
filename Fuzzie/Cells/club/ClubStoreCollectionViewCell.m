//
//  ClubStoreCollectionViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreCollectionViewCell.h"

@implementation ClubStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIBezierPath *maskPathBackgroundImage = [UIBezierPath
                                             bezierPathWithRoundedRect:self.ivStore.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                             cornerRadii:CGSizeMake(5, 5)
                                             ];
    
    CAShapeLayer *maskLayerBackgroundImage = [CAShapeLayer layer];
    
    maskLayerBackgroundImage.frame = self.bounds;
    maskLayerBackgroundImage.path = maskPathBackgroundImage.CGPath;
    
    self.ivStore.layer.mask = maskLayerBackgroundImage;
    
    self.infoView.roundedCorners = TKRoundedCornerBottomLeft | TKRoundedCornerBottomRight;
    self.infoView.drawnBordersSides =  TKDrawnBorderSidesLeft | TKDrawnBorderSidesRight | TKDrawnBorderSidesBottom;
    self.infoView.borderColor = [UIColor colorWithHexString:@"#E4E4E4"];
    self.infoView.cornerRadius = 2.0f;
    self.infoView.borderWidth = 1.0f;
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
            
            if (distance != 0.0f) {
                
                self.lbDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
                
            } else {
                
                self.lbDistance.text = @"";
            }
           
            
        } else {
            
            self.lbDistance.text = @"";
        }
    }
}
@end
