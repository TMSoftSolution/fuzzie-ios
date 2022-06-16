//
//  MiniBannerCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "MiniBannerCell.h"
#import "iCarousel.h"
#import "FXPageControl.h"
#import "Masonry.h"
#import "MiniBannerSliderItemView.h"

@interface MiniBannerCell() <iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (strong, nonatomic)  NSArray *bannerArray;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isAlreadyInit;
@end

@implementation MiniBannerCell

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
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSlider) name:RESET_MINI_BABBER_SLIDER object:nil];

    }
    [self bringSubviewToFront:self.carousel];
    
}

- (void)setBanner:(NSArray *)bannerArray {
    self.bannerArray = bannerArray;
    int nbOfBanner = (int) [self.bannerArray count];
    if([self.bannerArray count] == 1) {
        self.carousel.pagingEnabled = false;
        self.carousel.scrollEnabled = false;
    }
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = nbOfBanner;
    [self.carousel reloadData];
    
    if (self.bannerArray.count > 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(moveToNext)
                                                    userInfo:nil
                                                     repeats:NO];
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
        UINib *customNib = [UINib nibWithNibName:@"MiniBannerSliderItemView" bundle:nil];
        view = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.frame = self.frame;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerItemClicked:)];
        pan.delegate = self;
        [view addGestureRecognizer:pan];
        
    }
    
    if ([view isKindOfClass:[MiniBannerSliderItemView class]]) {
        
        MiniBannerSliderItemView *viewItemSlider = (MiniBannerSliderItemView *)view;

        [viewItemSlider.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[[self.bannerArray objectAtIndex:(NSUInteger)index] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];

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
    self.timer = nil;
    if (self.bannerArray.count > 1) {
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

- (void)bannerItemClicked:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(miniBannerClicked:)]) {
        [self.delegate miniBannerClicked:self.bannerArray[self.carousel.currentItemIndex]];
    }
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESET_MINI_BABBER_SLIDER object:nil];
}

@end
