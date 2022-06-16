//
//  StoreInfoView.h
//  Fuzzie
//
//  Created by mac on 7/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol StoreInfoViewDelegate <NSObject>

@optional
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state;
- (void)storeInfoViewTapped:(FZBrand*)brand;

@end

@interface StoreInfoView : UIView

@property (weak, nonatomic) id<StoreInfoViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nbLikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainer;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerUpZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;

@property (strong, nonatomic) FZBrand *brand;
@property (strong, nonatomic) FZStore *store;
@property (assign, nonatomic) BOOL isLiked;
- (void)setupWithBrand:(FZBrand *)brand store:(FZStore*) store;

@end
