//
//  BrandSliderCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandSliderCell.h"
#import "iCarousel.h"
#import "FXPageControl.h"
#import "Masonry.h"
#import "BrandSliderItemView.h"
#import "THLabel.h"

@interface BrandSliderCell () <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) FZBrand *brand;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *iconCategory;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) THLabel  *categoryText;
@property (weak, nonatomic) THLabel  *extraInfoText;
@property (nonatomic) BOOL isAlreadyInit;
@property (strong, nonatomic) NSArray *bannerArray;
@end



@implementation BrandSliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initSliderIfNeeded {
    if (!self.isAlreadyInit){
        self.carousel.frame = self.frame;
        self.carousel.dataSource = self;
        self.carousel.delegate = self;
        self.carousel.type = iCarouselTypeLinear;
        self.carousel.decelerationRate = 0.5f;
        self.carousel.centerItemWhenSelected = NO;
        self.isAlreadyInit = true;
    }
    [self bringSubviewToFront:self.carousel];
    
}

- (void)setBrandInfo:(FZBrand *)brand withMode:(BrandSliderCellMode)mode package:(NSDictionary*)packageInfo showSoldOut:(BOOL)show {
    if (self.brand) {
        return;
    }

    if (show) {
        
        if (mode == BrandSliderCellModePackage && packageInfo[@"sold_out"]) {
            if (packageInfo && packageInfo[@"sold_out"]) {
                if ([packageInfo[@"sold_out"] isEqual:@(YES)]) {
                    self.soldOutIcon.hidden = NO;
                } else {
                    self.soldOutIcon.hidden = YES;
                }
            }
        }
        
    } else {
        self.soldOutIcon.hidden = YES;
    }

    [self setBrandInfo:brand withMode:mode showSoldOut:show];
}

- (void)setBrandInfo:(FZBrand *)brand withMode:(BrandSliderCellMode)mode showSoldOut:(BOOL)show{
    
    if (self.brand) {
        return;
    }
    
    self.brand = brand;

    if (show) {
     
        if (mode == BrandSliderCellModeGiftCard) {
            if ([self.brand.soldOut boolValue]) {
                self.soldOutIcon.hidden = NO;
            } else {
                self.soldOutIcon.hidden = YES;
            }
        }
        
    } else {
        
        self.soldOutIcon.hidden = YES;
        
    }
    
    self.bannerArray = self.brand.coverPictures;
    
    int nbOfBanner = (int) [self.bannerArray count];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = nbOfBanner;
    [self.carousel reloadData];
    
    if([self.bannerArray count] <= 1) {
        self.userInteractionEnabled = NO;
        self.pageControl.hidden = YES;
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                      target:self
                                                    selector:@selector(moveToNext)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    
    
    self.categoryText.text = [self.brand.name uppercaseString];
    
    if ([FZData sharedInstance].subCategoryArray) {
        NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
        for (NSDictionary *categoryDict in subCategoryArray) {
            if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:self.brand.subcategoryId]) {
                
                NSString *imageName = [NSString stringWithFormat:@"sub-category-white-96-%@",[categoryDict[@"id"] stringValue]];
                self.iconCategory.image = [UIImage imageNamed:imageName];
                self.categoryText.text = categoryDict[@"name"];
            }
        }
        
    } else {
        self.iconCategory.image = nil;
        //self.categoryLabel.text = @"";
    }
    
    if (self.extraInfoText && self.brand.halal.boolValue) {
        self.extraInfoText.hidden = NO;
    } else {
        self.extraInfoText.hidden = YES;
    }
    
}

- (void)setBrandInfo:(FZBrand *)brand withMode:(BrandSliderCellMode)mode coupon:(FZCoupon *)coupon{
    
    if (mode == BrandSliderCellModeCoupon) {
        
        if (self.brand) {
            return;
        }
        
        self.brand = brand;
        
        if ([coupon.soldOut boolValue]) {
            self.soldOutIcon.hidden = NO;
        } else {
            self.soldOutIcon.hidden = YES;
        }
        
        self.bannerArray = coupon.coverPictures;
        
        int nbOfBanner = (int) [self.bannerArray count];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = nbOfBanner;
        [self.carousel reloadData];
        
        if([self.bannerArray count] <= 1) {
            self.userInteractionEnabled = NO;
            self.pageControl.hidden = YES;
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                          target:self
                                                        selector:@selector(moveToNext)
                                                        userInfo:nil
                                                         repeats:NO];
        }
        
        if ([FZData sharedInstance].subCategoryArray) {
            NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
            for (NSDictionary *categoryDict in subCategoryArray) {
                if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:self.brand.subcategoryId]) {
                    
                    NSString *imageName = [NSString stringWithFormat:@"sub-category-white-96-%@",[categoryDict[@"id"] stringValue]];
                    self.iconCategory.image = [UIImage imageNamed:imageName];
                    self.categoryText.text = categoryDict[@"name"];
                }
            }
            
        } else {
            self.iconCategory.image = nil;
            //self.categoryLabel.text = @"";
        }
        
        self.extraInfoText.hidden = YES;
    
    } else if (mode == BrandSliderCellModePowerUpPack){
        
        if ([coupon.soldOut boolValue]) {
            self.soldOutIcon.hidden = NO;
        } else {
            self.soldOutIcon.hidden = YES;
        }
        
        self.bannerArray = coupon.coverPictures;
        
        int nbOfBanner = (int) [self.bannerArray count];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = nbOfBanner;
        [self.carousel reloadData];
        
        if([self.bannerArray count] <= 1) {
            self.userInteractionEnabled = NO;
            self.pageControl.hidden = YES;
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                          target:self
                                                        selector:@selector(moveToNext)
                                                        userInfo:nil
                                                         repeats:NO];
        }
        
        self.iconCategory.hidden = YES;
        self.categoryText.hidden = YES;
        self.extraInfoText.hidden = YES;
    }
}

- (void)resetSlider {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.carousel reloadData];
}
- (void)enabledInteraction {
    self.userInteractionEnabled = YES;
}
- (void)desabledInteraction {
    self.userInteractionEnabled = NO;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return (int)[self.bannerArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        UINib *customNib = [UINib nibWithNibName:@"BrandSliderItemView" bundle:nil];
        view = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.frame = self.frame;
        view.userInteractionEnabled = YES;
        ((BrandSliderItemView *)view).shadowLayer.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    }
    
    if ([view isKindOfClass:[BrandSliderItemView class]]) {
        BrandSliderItemView *viewItemSlider = (BrandSliderItemView *)view;
        NSURL *imageURL = [NSURL URLWithString:self.bannerArray[index][@"url"]];
        [viewItemSlider.backgroundImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }
    
    return view;
}


#pragma -mark delegare iCarousel
- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}


- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    [self.timer invalidate];
    
    if([self.bannerArray count] > 1) {
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                      target:self
                                                    selector:@selector(moveToNext)
                                                    userInfo:nil
                                                     repeats:NO];
    }

}
    
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.pageControl.currentPage = carousel.currentItemIndex;
}

- (void)moveToNext {
    [self.carousel scrollByNumberOfItems:1 duration:0.45];
}



- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESET_BRAND_SLIDER object:nil];
}

@end
