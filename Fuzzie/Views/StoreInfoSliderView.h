//
//  StoreInfoSliderView.h
//  Fuzzie
//
//  Created by mac on 7/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "FXPageControl.h"
#import "Masonry.h"
#import "StoreInfoView.h"

@protocol StoreInfoSliderViewDelegate <NSObject>

@optional
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state;
- (void)storeInfoViewTapped:(FZBrand*)brand;

@end

@interface StoreInfoSliderView : UIView <iCarouselDataSource, iCarouselDelegate, StoreInfoViewDelegate>

@property (weak, nonatomic) id<StoreInfoSliderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlHeightAnchor;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSArray* stores;
@property (nonatomic) BOOL isAlreadyInit;
@property (assign, nonatomic) BOOL firstScrolled;

- (void)initSliderIfNeeded;
- (void)setStoresInfo:(NSArray*)stores;

@end
