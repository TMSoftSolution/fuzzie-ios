//
//  ClubStoreTopTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreTopTableViewCell.h"

@implementation ClubStoreTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

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
//    [self bringSubviewToFront:self.carousel];
 
}

- (void)setCell:(FZBrand *)brand dict:(NSDictionary *)dict{
    
    if (brand && dict) {
        
        self.brand = brand;
        self.dict = dict;
        self.bannerArray = brand.coverPictures;
        
        self.lbBrandName.text = brand.name;
        
        int nbOfBanner = (int) [self.bannerArray count];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = nbOfBanner;
        [self.carousel reloadData];
        
        if([self.bannerArray count] <= 1) {
            [self.carousel setScrollEnabled:NO];
            self.pageControl.hidden = YES;
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(moveToNext)
                                                        userInfo:nil
                                                         repeats:NO];
        }
        
        if ([FZData sharedInstance].subCategoryArray) {
            NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
            for (NSDictionary *categoryDict in subCategoryArray) {
                if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:self.brand.subcategoryId]) {
                    
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
        
    }
    
    self.bookmarked = [[UserController sharedInstance].currentUser.bookmarkedStoreIds containsObject:dict[@"id"]];
    [self updateBookmark];
}

- (void)updateBookmark{
    
    if (self.bookmarked) {
    
        [UIView transitionWithView:self.btnBookmark duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.btnBookmark setImage:[UIImage imageNamed:@"icon-store-bookmark-selected"] forState:UIControlStateNormal];
        } completion:nil];
  
        
    } else {
        
        [UIView transitionWithView:self.btnBookmark duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.btnBookmark setImage:[UIImage imageNamed:@"icon-store-bookmark"] forState:UIControlStateNormal];
            
        } completion:nil];
      
    }
}

- (IBAction)bookmarkPressed:(id)sender {
    
    if (self.bookmarked) {
        
        [ClubController storeUnBookmark:self.dict[@"id"] completion:nil];

    } else {
        
        [ClubController storeBookmark:self.dict[@"id"] completion:nil];
    }

    self.bookmarked = !self.bookmarked;
    
    if ([self.delegate respondsToSelector:@selector(bookmarkPressed:)]) {
        [self.delegate bookmarkPressed:self.bookmarked];
    }
    
    [UserController bookmarkStoreWithId:self.dict[@"id"] bookmark:self.bookmarked];
    [self updateBookmark];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLUB_STORE_BOOK_MARK_CHANGED object:nil];
}


- (void)resetSlider {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.carousel reloadData];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 1;
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
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
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
