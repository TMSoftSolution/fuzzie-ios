//
//  BrandListCollectionViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandListCollectionViewCell.h"
#import "BrandController.h"

@interface BrandListCollectionViewCell() <UIGestureRecognizerDelegate>
@property (assign, nonatomic) BOOL isLiked;
@property (assign, nonatomic) BOOL isLoaded;
@property (assign, nonatomic) int nbLikes;
@end


@implementation BrandListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.hidden = YES;
    self.promoIcon.hidden = YES;
    self.nbLikesLabel.hidden = YES;
    self.likeButton.hidden = YES;
    
    [self disabledSpinner];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationWishList:) name:LIKE_ADDED_IN_BRAND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationWishList:) name:LIKE_REMOVED_IN_BRAND object:nil];
    
    self.imageView.layer.cornerRadius = 10;
    
    UIBezierPath *maskPathBackgroundImage = [UIBezierPath
                              bezierPathWithRoundedRect:self.imageView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(1.5, 1.5)
                              ];
    
    CAShapeLayer *maskLayerBackgroundImage = [CAShapeLayer layer];
    
    maskLayerBackgroundImage.frame = self.bounds;
    maskLayerBackgroundImage.path = maskPathBackgroundImage.CGPath;
    
    self.imageView.layer.mask = maskLayerBackgroundImage;
    
    
    [self roundedCashbackContainer];
    
}

- (void)enableSpinner {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)disabledSpinner {
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

- (void)setDataBrandBy:(NSString *)brandId {
    
    if (![self.brand.brandId isEqualToString:brandId]) {
        
        [self enableSpinner];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brandId == %@", brandId];
        NSArray *filteredArray = [[FZData sharedInstance].brandSet.allObjects filteredArrayUsingPredicate:predicate];
        
        if ([filteredArray count] == 0) {
            
            [BrandController getBrand:brandId withSuccess:^(FZBrand *brand, NSError *error) {
                [self disabledSpinner];
                self.isLoaded = YES;
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                        return ;
                    }
                    return;
                } else {
                    [self setDataWith:brand];
                    NSMutableSet *brandSet = [[FZData sharedInstance].brandSet mutableCopy];
                    [brandSet addObject:brand];
                    [FZData sharedInstance].brandSet = [brandSet copy];
                }
            }];
        } else {
            [self disabledSpinner];
            self.isLoaded = YES;
            [self setDataWith:[filteredArray objectAtIndex:0]];
        }
    }
}

- (void)setDataWith:(FZBrand *)brand {
    
    if (brand) {
        
        self.brand = brand;
        [self disabledSpinner];
        self.brandId = brand.brandId;
        
        if (brand.cashbackPercentage && brand.powerupPercentage) {
            
            NSNumber *cashbackPercent = brand.cashbackPercentage;
            NSNumber *powerupPercent = brand.powerupPercentage;
            
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
                    self.cashbackContainerWidthAnchor.priority = 200;
                    
                } else {
                    self.cashbackLabel.text = @"";
                    self.cashbackContainerWidthAnchor.priority = 999;
                }
                if (powerupPercent.floatValue > 0) {
                    self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                    self.powerupContainerWidthAnchor.priority = 200;
                } else {
                    self.powerUpLabel.text = @"";
                    self.powerupContainerWidthAnchor.priority = 999;
                }
            } else {
                
                self.cashbackLabel.text = @"";
                self.cashbackContainerWidthAnchor.priority = 999;
                self.powerUpLabel.text = @"";
                self.powerupContainerWidthAnchor.priority = 999;
                
                if (brand.brandLink && [brand.brandLink[@"type"] isEqualToString:@"jackpot_coupon"]) {
                    
                    FZCoupon *coupon = [FZData getCouponById:brand.brandLink[@"jackpot_coupon_template_id"]];
                    
                    if (coupon && coupon.cashbackPercentage && coupon.cashbackPercentage.floatValue > 0.0f) {
                        
                        self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:coupon.cashbackPercentage fontSize:13 decimalFontSize:13];
                        self.cashbackContainerWidthAnchor.priority = 200;
                        [self fullRoundedCashbackContainer];
                    }
                }
            }
            
        } else {
            
            self.cashbackLabel.text = @"";
            self.cashbackContainerWidthAnchor.priority = 999;
            self.powerUpLabel.text = @"";
            self.powerupContainerWidthAnchor.priority = 999;
        }
        
        if ([brand.powerupPercentage floatValue] > 0 && ([UserController sharedInstance].currentUser.powerUpExpiryDate || [brand.powerUp boolValue])) {
            self.promoIcon.hidden = NO;
            if ([brand.isNewBrand boolValue]) {
                [self.promoIcon setImage:[UIImage imageNamed:@"icon-brand-new"]];
            } else{
                [self.promoIcon setImage:[UIImage imageNamed:@"icon-promo"]];
            }
        } else{
            if ([brand.isNewBrand boolValue]) {
                self.promoIcon.hidden = NO;
                [self.promoIcon setImage:[UIImage imageNamed:@"icon-brand-new"]];
            } else{
                self.promoIcon.hidden = YES;
            }
        }
        
        
        if (brand.likersCount) {
            if (brand.likersCount < 0) {
                brand.likersCount = @0;
                self.nbLikesLabel.text = @"0";
            } else {
                self.nbLikesLabel.text = [NSString stringWithFormat:@"%i",[brand.likersCount intValue]];
            }
        }
        
        if ([brand.isLiked isEqual:@1]) {
            [self setFilledHeart];
        } else {
            [self setEmptyHeart];
        }
        
        NSURL *imageURL;
        imageURL = [NSURL URLWithString:brand.backgroundImage];
        self.nameLabel.text = brand.name;
        [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (cacheType == SDImageCacheTypeNone) {
                self.imageView.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    self.imageView.alpha = 1;
                }];
            } else {
                self.imageView.alpha = 1;
            }
        }];
        
        if ([FZData sharedInstance].subCategoryArray) {
            NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
            for (NSDictionary *categoryDict in subCategoryArray) {
                if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:brand.subcategoryId]) {
                    
                    NSString *imageName = [NSString stringWithFormat:@"sub-category-white-96-%@",[categoryDict[@"id"] stringValue]];
                    self.categoryImageView.image = [UIImage imageNamed:imageName];
                }
            }
            
        } else {
            self.categoryImageView.image = nil;
        }
        
        self.nameLabel.hidden = NO;
        self.nbLikesLabel.hidden = NO;
        self.likeButton.hidden = NO;
        
        self.ivClubMember.hidden = ![self.brand.isClubOnly boolValue];
    }
    
}

- (void)roundedCashbackContainer {
    
    self.cashbackContainerView.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerBottomLeft;
    self.cashbackContainerView.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainerView.cornerRadius = 2.0f;
}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainerView.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainerView.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainerView.cornerRadius = 2.0f;
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

- (IBAction)heartTapped:(id)sender {
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




- (void)updateNbLikes:(NSNumber *)nbLikes {
    if (nbLikes < 0) {
        self.nbLikesLabel.text = @"0";
        self.brand.likersCount = @0;
    } else {
        self.brand.likersCount = nbLikes;
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


- (void)getNotificationWishList:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:LIKE_ADDED_IN_BRAND]) {
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        
        NSNumber *nbLike = [notification.userInfo objectForKey:@"nbLike"];
        
        [self setFilledHeart];
        [self updateNbLikes:(nbLike)];
        self.isLiked = YES;
        
    } else if ([[notification name] isEqualToString:LIKE_REMOVED_IN_BRAND]){
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        
        NSNumber *nbLike = [notification.userInfo objectForKey:@"nbLike"];
        
        [self setEmptyHeart];
        [self updateNbLikes:(nbLike)];
        self.isLiked = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIKE_ADDED_IN_BRAND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIKE_REMOVED_IN_BRAND object:nil];
}
@end
