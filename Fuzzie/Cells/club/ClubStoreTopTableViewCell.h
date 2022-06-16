//
//  ClubStoreTopTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "FXPageControl.h"
#import "BrandSliderItemView.h"

@protocol ClubStoreTopTableViewCellDelegate <NSObject>

- (void)bookmarkPressed:(BOOL)bookmarked;

@end

@interface ClubStoreTopTableViewCell : UITableViewCell <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) id<ClubStoreTopTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UIView *bottomSeprator;

- (IBAction)bookmarkPressed:(id)sender;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isAlreadyInit;

@property (strong, nonatomic) FZBrand *brand;
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSArray *bannerArray;
@property (assign, nonatomic) BOOL bookmarked;

- (void)initSliderIfNeeded;
- (void)setCell:(FZBrand*)brand dict:(NSDictionary*)dict;

@end
