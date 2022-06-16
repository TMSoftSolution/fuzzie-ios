//
//  StoreInfoView.m
//  Fuzzie
//
//  Created by mac on 7/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "StoreInfoView.h"

@implementation StoreInfoView

- (void) awakeFromNib{
    [super awakeFromNib];

    [CommonUtilities setView:self.promoLabel withCornerRadius:2.5f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeInfoViewTapped)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)setupWithBrand:(FZBrand *)brand store:(FZStore *)store{
    
    self.brand = brand;
    self.store = store;
    
    if (self.brand && self.brand.likersCount) {
        [self updateNbLikes:self.brand.likersCount];
    } else {
        [self updateNbLikes:0];
    }
    
    if ([self.brand.isLiked isEqual:@1]) {
        [self setFilledHeart];
    } else {
        [self setEmptyHeart];
    }
    
    NSURL *imageURL = [NSURL URLWithString:brand.backgroundImage];
    [self.backgroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    
    if (brand.cashbackPercentage && brand.powerupPercentage) {
        
        NSNumber *cashbackPercent = brand.cashbackPercentage;
        NSNumber *powerupPercent = brand.powerupPercentage;
        
        self.promoLabel.hidden = !((powerupPercent.floatValue > 0) && ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]));
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            
            if (cashbackPercent.floatValue > 0 && powerupPercent.floatValue > 0) {
                
                [self roundedCashbackContainer];
                [self roundedPowerupContainer];
                
            } else {
                
                if (cashbackPercent.floatValue > 0) {
                    
                    [self fullRoundedCashbackContainer];
                    
                } else if (powerupPercent.floatValue > 0){
                    
                    [self fullRoundedPowerupContainer];
                }
            }
            
            if (cashbackPercent.floatValue > 0) {
                self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:cashbackPercent fontSize:13 decimalFontSize:13];
                self.cashbackZeroWidthConstraint.priority = 200;
            } else {
                self.cashbackLabel.text = @"";
                self.cashbackZeroWidthConstraint.priority = 999;
            }
            
            if (powerupPercent.floatValue > 0) {
                self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                self.powerUpZeroWidthConstraint.priority = 200;
            } else {
                self.powerUpLabel.text = @"";
                self.powerUpZeroWidthConstraint.priority = 999;
            }
            
        } else {
            self.promoLabel.hidden = YES;
            self.cashbackLabel.text = @"";
            self.cashbackZeroWidthConstraint.priority = 999;
            self.powerUpLabel.text = @"";
            self.powerUpZeroWidthConstraint.priority = 999;
        }
        
    } else {
        self.promoLabel.hidden = YES;
        self.cashbackLabel.text = @"";
        self.cashbackZeroWidthConstraint.priority = 999;
        self.powerUpLabel.text = @"";
        self.powerUpZeroWidthConstraint.priority = 999;
    }
    
    if ([FZData sharedInstance].subCategoryArray) {
        NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
        for (NSDictionary *categoryDict in subCategoryArray) {
            if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:brand.subcategoryId]) {
                
                NSString *imageName = [NSString stringWithFormat:@"sub-category-white-96-%@",[categoryDict[@"id"] stringValue]];
                self.iconImageView.image = [UIImage imageNamed:imageName];
            }
        }
        
    } else {
        self.iconImageView.image = nil;
    }
    
    [self.nameLabel setText:brand.name];
    
    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:[store.latitude doubleValue] longitude:[store.longitude doubleValue]];
    if ([FZData sharedInstance].currentLocation) {
        [self.distanceLabel setText: [self calcDistance:[FZData sharedInstance].currentLocation and:storeLocation]];
        [self.storeNameLabel setText:[NSString stringWithFormat:@" - %@", store.name]];
    } else{
        [self.distanceLabel setText:@""];
        [self.storeNameLabel setText:[NSString stringWithFormat:@"%@", store.name]];
    }
  
}

- (void)roundedCashbackContainer {
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerBottomLeft;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)roundedPowerupContainer{
    
    self.powerUpContainer.roundedCorners = TKRoundedCornerTopRight | TKRoundedCornerBottomRight;
    self.powerUpContainer.drawnBordersSides =  TKDrawnBorderSidesTop | TKDrawnBorderSidesRight | TKDrawnBorderSidesBottom;
    self.powerUpContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerUpContainer.cornerRadius = 2.0f;
    self.powerUpContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
    
}

- (void)fullRoundedPowerupContainer{
    
    self.powerUpContainer.roundedCorners = TKRoundedCornerAll;
    self.powerUpContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerUpContainer.cornerRadius = 2.0f;
    self.powerUpContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
}

- (IBAction)likeButtonPressed:(id)sender {

    if ([self.delegate respondsToSelector:@selector(likeButtonTappedOn:WithState:)]) {
        if (self.isLiked) {
            [self setEmptyHeart];
            [self updateNbLikes:[NSNumber numberWithInt:([self.brand.likersCount intValue] - 1) ]];
            self.isLiked = NO;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:LIKE_REMOVED_IN_BRAND
             object:nil
             userInfo:@{@"brand":self.brand, @"nbLike":self.brand.likersCount}];
        } else {
            [self setFilledHeart];
            [self updateNbLikes:[NSNumber numberWithInt:([self.brand.likersCount intValue] + 1) ]];
            self.isLiked = YES;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:LIKE_ADDED_IN_BRAND
             object:nil
             userInfo:@{@"brand":self.brand, @"nbLike":self.brand.likersCount}];
        }
        
        [self.delegate likeButtonTappedOn:self.brand WithState:self.isLiked];
    }
}

- (void)storeInfoViewTapped{
    if ([self.delegate respondsToSelector:@selector(storeInfoViewTapped:)]) {
        if (self.brand) {
            [self.delegate storeInfoViewTapped:self.brand];
        }
    }
}

- (void)updateNbLikes:(NSNumber *)nbLikes {
    self.brand.likersCount = nbLikes;
    if (nbLikes < 0) {
        self.nbLikesLabel.text = @"0";
        self.brand.likersCount = @0;
    } else {
        self.nbLikesLabel.text = [NSString stringWithFormat:@"%@",self.brand.likersCount];
    }
}

- (void)setEmptyHeart {
    __weak __typeof__(self) weakSelf = self;
    self.isLiked = NO;
    self.brand.isLiked = @(NO);
    [UIView transitionWithView:weakSelf.likeButton
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.likeButton setImage:[UIImage imageNamed:@"heart-icon-red"] forState:UIControlStateNormal];
                        weakSelf.isLiked = NO;
                    } completion:nil];
}

- (void)setFilledHeart {
    __weak __typeof__(self) weakSelf = self;
    self.isLiked = YES;
    self.brand.isLiked = @(YES);
    [UIView transitionWithView:self.likeButton
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.likeButton setImage:[UIImage imageNamed:@"heart-icon-red-filled"] forState:UIControlStateNormal];
                        weakSelf.isLiked = YES;
                    } completion:nil];
}

- (NSString *)calcDistance:(CLLocation *) location1 and:(CLLocation *) location2{
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    if (distance < 100) {
        return [NSString stringWithFormat:@"%d m", (int)distance];
    } else{
    
        return [NSString stringWithFormat:@"%.1f km", distance/1000];
    }
}


@end
