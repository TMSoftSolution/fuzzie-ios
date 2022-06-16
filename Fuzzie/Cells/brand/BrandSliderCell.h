//
//  BrandSliderCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    BrandSliderCellModeGiftCard,
    BrandSliderCellModePackage,
    BrandSliderCellModeCoupon,
    BrandSliderCellModePowerUpPack
} BrandSliderCellMode;

@interface BrandSliderCell : UITableViewCell
- (void)initSliderIfNeeded;
- (void)setBrandInfo:(FZBrand *)brand withMode:(BrandSliderCellMode)mode showSoldOut:(BOOL)show;
- (void)setBrandInfo:(FZBrand *)brand withMode:(BrandSliderCellMode)mode package:(NSDictionary*)packageInfo showSoldOut:(BOOL)show;
- (void)setBrandInfo:(FZBrand*)brand withMode:(BrandSliderCellMode)mode coupon:(FZCoupon*)coupon;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutIcon;
@property (nonatomic) BOOL isAnimated;
@end
