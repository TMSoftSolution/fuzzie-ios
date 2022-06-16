//
//  BannerSliderCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BannerSliderCell.h"
#import "iCarousel.h"
#import "FXPageControl.h"
#import "Masonry.h"
#import "BannerSliderItemView.h"


@interface BannerSliderCell () <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isAlreadyInit;
@end

@implementation BannerSliderCell

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSlider) name:RESET_BRAND_SLIDER object:nil];
    }
    [self bringSubviewToFront:self.carousel];

}

- (void)setBanner:(NSArray *)bannerArray {
    self.bannerArray = bannerArray;
    int nbOfBanner = (int) [self.bannerArray count];
    if(nbOfBanner == 1) {
        self.carousel.pagingEnabled = false;
        self.carousel.scrollEnabled = false;
        self.pageControl.hidden = YES;
    } else {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(moveToNext)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = nbOfBanner;
    [self.carousel reloadData];

    
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
        UINib *customNib = [UINib nibWithNibName:@"BannerSliderItemView" bundle:nil];
        view = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.frame = self.frame;
        view.userInteractionEnabled = YES;
        ((BannerSliderItemView *)view).shadowLayer.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerItemClicked:)];
        pan.delegate = self;
        [view addGestureRecognizer:pan];
        
    }
    
    if ([view isKindOfClass:[BannerSliderItemView class]]) {
        
        BannerSliderItemView *viewItemSlider = (BannerSliderItemView *)view;
        NSString *headerString = [[[self.bannerArray objectAtIndex:(NSUInteger)index] objectForKey:@"header"] uppercaseString];
        NSString *subHeaderString = [[self.bannerArray objectAtIndex:(NSUInteger)index] objectForKey:@"sub_header"];
        
        
        if ([headerString isEqual: @""] && [subHeaderString isEqual: @""]){
            viewItemSlider.shadowLayer.hidden = YES;
            viewItemSlider.header.text = @"";
            viewItemSlider.subHeader.text = @"";
        } else {
            viewItemSlider.shadowLayer.hidden = NO;
            viewItemSlider.header.text = headerString;
            viewItemSlider.subHeader.text = subHeaderString;
        }
        
        [viewItemSlider.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[[self.bannerArray objectAtIndex:(NSUInteger)index] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:viewItemSlider.subHeader.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineHeightMultiple = 1.4;
        style.alignment = NSTextAlignmentCenter;
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attrString.length)];
        viewItemSlider.subHeader.attributedText = attrString;
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
    if ( [self.bannerArray count] > 1) {
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
    if ([self.delegate respondsToSelector:@selector(bannerClicked:)]) {
        [self.delegate bannerClicked:self.bannerArray[self.carousel.currentItemIndex]];
    }
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESET_BRAND_SLIDER object:nil];
}

@end
