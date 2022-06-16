//
//  BrandViewController.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieViewController.h"
#import "MiniBannerCell.h"
#import "FZHeaderView.h"
#import "GiftingAvailableView.h"


@interface BrandViewController : FuzzieViewController <GiftingAvailableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundNav;
@property (weak, nonatomic) IBOutlet FZHeaderView *headerNav;
@property (strong, nonatomic) FZBrand *brand;
@property (weak, nonatomic) IBOutlet UILabel *titleNav;
@property (strong, nonatomic) NSArray *miniBannerArray;

@property (strong, nonatomic) GiftingAvailableView *giftingAvailableView;

- (void)showGiftingAvailableView;
@end
