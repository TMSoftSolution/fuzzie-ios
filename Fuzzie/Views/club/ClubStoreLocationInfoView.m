//
//  ClubStoreLocationInfoView.m
//  Fuzzie
//
//  Created by joma on 6/15/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreLocationInfoView.h"

@implementation ClubStoreLocationInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    
    if (self == [super init]) {
        
        [CommonUtilities setView:self withCornerRadius:4.0f];
        [CommonUtilities setView:self.ivBrand withCornerRadius:2.0f];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super initWithCoder:aDecoder]) {
        
        [CommonUtilities setView:self withCornerRadius:4.0f];
        [CommonUtilities setView:self.ivBrand withCornerRadius:2.0f];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [CommonUtilities setView:self withCornerRadius:4.0f];
        [CommonUtilities setView:self.ivBrand withCornerRadius:2.0f];
    }
    
    return self;
}

- (void)setViewWith:(NSDictionary *)dict brand:(FZBrand *)brand store:(FZStore *)store{
    
    if (brand) {
        
        self.lbBrandName.text = brand.name;
        [self.ivBrand sd_setImageWithURL:[NSURL URLWithString:brand.backgroundImage] placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
        
        if ([FZData sharedInstance].subCategoryArray) {
            
            NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
            for (NSDictionary *categoryDict in subCategoryArray) {
                if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:brand.subcategoryId]) {
                    
                    NSString *imageName = [NSString stringWithFormat:@"sub-category-black-96-%@",[categoryDict[@"id"] stringValue]];
                    self.ivCategory.image = [UIImage imageNamed:imageName];
                    self.lbCategory.text = categoryDict[@"name"];
                    
                    break;
                }
            }
            
        } else {
            self.ivCategory.image = nil;
            self.lbCategory.text = @"";
        }
        
    } else {
        
        self.lbBrandName.text = @"";
        self.lbCategory.text = @"";
        self.ivCategory.image = nil;
        
    }
    
    if (store) {
        
        self.lbStoreName.text = store.name;
        
    } else {
        
        self.lbStoreName.text = @"";
        
    }
    
    if (dict && dict[@"distance"] && ![dict[@"distance"] isKindOfClass:[NSNull class]]) {
        
        float distance = [dict[@"distance"] floatValue];
        self.lbDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
        
    } else {
        
        self.lbDistance.text = @"";
    }
}

@end
