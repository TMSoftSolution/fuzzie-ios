//
//  BrandTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandTableViewCell.h"

@interface BrandTableViewCell ()
@property (assign, nonatomic) BOOL isLiked;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutIcon;

@end

@implementation BrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:LIKE_ADDED_IN_BRAND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:LIKE_REMOVED_IN_BRAND object:nil];
    
    self.cashbackPowerUpContainer.layer.cornerRadius = 2.5f;
    self.cashbackPowerUpContainer.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithBrand:(FZBrand *)brand {
    
    self.brand = brand;
    
    if ([self.brand isAllSoldOut]) {
        self.soldOutIcon.hidden = NO;
    } else {
        self.soldOutIcon.hidden = YES;
    }
    
    
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
    
    self.nameLabel.text = brand.name;
    
    NSURL *imageURL = [NSURL URLWithString:brand.backgroundImage];
    [self.backgroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (cacheType == SDImageCacheTypeNone) {
            self.backgroundImageView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.backgroundImageView.alpha = 1;
            }];
        } else {
            self.backgroundImageView.alpha = 1;
        }
    }];
    
    if (brand.cashbackPercentage && brand.powerupPercentage) {
        
        NSNumber *cashbackPercent = brand.cashbackPercentage;
        NSNumber *powerupPercent = brand.powerupPercentage;
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            self.cashbackPowerUpContainer.hidden = NO;
            
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
                self.cashbackContainer.hidden = NO;
                self.cashbackZeroWidthConstraint.priority = 250;
            } else {
                self.cashbackLabel.text = @"";
                self.cashbackContainer.hidden = YES;
                self.cashbackZeroWidthConstraint.priority = 999;
            }
            
            if (powerupPercent.floatValue > 0) {
                self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                self.powerUpContainer.hidden = NO;
                self.powerUpZeroWidthConstraint.priority = 250;
            } else {
                self.powerUpLabel.text = @"";
                self.powerUpContainer.hidden = YES;
                self.powerUpZeroWidthConstraint.priority = 999;
            }
            
        } else {
            
            self.cashbackPowerUpContainer.hidden = YES;
            
            if (brand.brandLink && [brand.brandLink[@"type"] isEqualToString:@"jackpot_coupon"]) {
                
                FZCoupon *coupon = [FZData getCouponById:brand.brandLink[@"jackpot_coupon_template_id"]];
                
                if (coupon && coupon.cashbackPercentage && coupon.cashbackPercentage.floatValue > 0.0f) {
                    
                    self.cashbackPowerUpContainer.hidden = NO;
                    self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:coupon.cashbackPercentage fontSize:13 decimalFontSize:13];
                    self.cashbackZeroWidthConstraint.priority = 250;
                    [self fullRoundedCashbackContainer];
                    self.powerUpLabel.text = @"";
                    self.powerUpContainer.hidden = YES;
                    self.powerUpZeroWidthConstraint.priority = 999;
                }
            }
        }
        
    } else {
        self.cashbackPowerUpContainer.hidden = YES;
    }
    
    self.ivClubMember.hidden = ![self.brand.isClubOnly boolValue];
    
    if ([brand.powerupPercentage floatValue] > 0 && ([UserController sharedInstance].currentUser.powerUpExpiryDate || [brand.powerUp boolValue])) {
        self.ivPromo.hidden = NO;
        if ([brand.isNewBrand boolValue]) {
            [self.ivPromo setImage:[UIImage imageNamed:@"icon-brand-new"]];
        } else{
            [self.ivPromo setImage:[UIImage imageNamed:@"icon-promo"]];
        }
    } else{
        if ([brand.isNewBrand boolValue]) {
            self.ivPromo.hidden = NO;
            [self.ivPromo setImage:[UIImage imageNamed:@"icon-brand-new"]];
        } else{
            self.ivPromo.hidden = YES;
        }
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
    
    if (brand.stores.count > 0) {
        if (brand.stores.count == 1) {
            FZStore *store = [brand.stores objectAtIndex:0];
            self.priceLabel.text = store.name;
        } else{
            self.priceLabel.text = [NSString stringWithFormat:@"%lu Stores", (unsigned long)brand.stores.count];
        }
    } else{
        self.priceLabel.text = @"Online";
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
    
    if ([self.delegate respondsToSelector:@selector(likeButtonTappedOn:WithState:cell:)]) {
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
        [self.delegate likeButtonTappedOn:self.brand WithState:self.isLiked cell:self];
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

- (void)getNotification:(NSNotification *)notification
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
