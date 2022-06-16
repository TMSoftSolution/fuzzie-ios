//
//  StoreInfoSliderView.m
//  Fuzzie
//
//  Created by mac on 7/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "StoreInfoSliderView.h"

@implementation StoreInfoSliderView 

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)initSliderIfNeeded{
    if (!self.isAlreadyInit){
        self.carousel.frame = self.frame;
        self.carousel.dataSource = self;
        self.carousel.delegate = self;
        self.carousel.type = iCarouselTypeLinear;
        self.carousel.decelerationRate = 0.5f;
        self.carousel.centerItemWhenSelected = NO;
        self.isAlreadyInit = true;
        self.firstScrolled = false;
    }
    [self bringSubviewToFront:self.carousel];
}

- (void)setStoresInfo:(NSArray *)stores{
    if (stores) {
        self.stores = stores;
    }
    
    self.firstScrolled = false;
    int nbOfStores = (int) [self.stores count];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = nbOfStores;
    [self.carousel reloadData];

    if (self.stores.count == 1) {
        [self.carousel setScrollEnabled:NO];
        self.pageControlHeightAnchor.constant = 0;
    } else{
        [self.carousel setScrollEnabled:YES];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(moveToNext) userInfo:nil repeats:NO];
        self.pageControlHeightAnchor.constant = 20;
    }
    
}

- (void)moveToNext {
    [self.carousel scrollByNumberOfItems:1 duration:0.45];
    self.firstScrolled = true;
}

- (void)resetSlider {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.carousel reloadData];
}

#pragma - mark iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.stores.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    if (view == nil) {
        UINib *nib = [UINib nibWithNibName:@"StoreInfoView" bundle:nil];
        view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.frame = self.frame;
        view.userInteractionEnabled = YES;
        
    }
    
    if ([view isKindOfClass:[StoreInfoView class]]) {
        StoreInfoView *storeInfoView = (StoreInfoView*)view;
        storeInfoView.delegate = self;
        FZStore *store = [self.stores objectAtIndex:index];
        FZBrand *brand = [FZData getBrandById:store.brandId];
        if (store && brand) {
            [storeInfoView setupWithBrand:brand store:store];
        }
    }
    
    return view;
}

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
    
    if([self.stores count] > 1) {
        self.timer = nil;
        if (self.firstScrolled) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(moveToNext)
                                                        userInfo:nil
                                                         repeats:NO];
        } else{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(moveToNext)
                                                        userInfo:nil
                                                         repeats:NO];
        }
        
    }
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.pageControl.currentPage = carousel.currentItemIndex;
}

#pragma mark - StoreInfoViewDelegate
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state{
    if ([self.delegate respondsToSelector:@selector(likeButtonTappedOn:WithState:)]) {
        [self.delegate likeButtonTappedOn:brand WithState:state];
    }
}

- (void)storeInfoViewTapped:(FZBrand*)brand{
    if ([self.delegate respondsToSelector:@selector(storeInfoViewTapped:)]) {
        [self.delegate storeInfoViewTapped:brand];
    }
}


- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
