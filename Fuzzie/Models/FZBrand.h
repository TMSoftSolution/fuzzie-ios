//
//  FZBrand.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FZBrand : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSNumber *subcategoryId;
@property (nonatomic, strong) NSArray *categoryIds;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *backgroundImage;
@property (nonatomic, strong) NSString *customImage;
@property (nonatomic, strong) NSNumber *halal;
@property (nonatomic, strong) NSString *online;
@property (nonatomic, strong) NSString *parentBrandId;
@property (nonatomic, strong) FZBrand *parentBrand;

@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *instagram;

@property (nonatomic, strong) NSMutableArray *likers;
@property (nonatomic, strong) NSNumber *likersCount;
@property (nonatomic, strong) NSNumber *isLiked;
@property (nonatomic, strong) NSNumber *isWishListed;

@property (nonatomic, strong) NSArray *stores;
@property (nonatomic, strong) NSArray *termsAndConditions;
@property (nonatomic, strong) NSArray *giftCards;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSArray *serviceCategories;

@property (nonatomic, strong) NSArray *othersAlsoBought;

@property (nonatomic, strong) NSNumber *percentage;
@property (nonatomic, strong) NSNumber *cashbackPercentage;
@property (nonatomic, strong) NSNumber *powerupPercentage;
@property (nonatomic, strong) NSNumber *isNewBrand;

@property (nonatomic, strong) NSNumber *tripadvisorReviewCount;
@property (nonatomic, strong) NSString *tripadvisorRating;
@property (nonatomic, strong) NSString *tripadvisorLink;

@property (nonatomic, strong) NSArray *textOptionGiftCard;
@property (nonatomic, strong) NSArray *textOptionPackage;
@property (nonatomic, strong) NSArray *coverPictures;
@property (nonatomic, strong) NSNumber *soldOut;

@property (nonatomic, strong) NSNumber *powerUp;

@property (nonatomic, strong) NSNumber *jackpotCouponsPresent;

@property (nonatomic, strong) NSNumber *couponOnly;
@property (nonatomic, strong) NSArray *coupons;

@property (nonatomic, strong) NSDictionary *brandLink;

@property (nonatomic, strong) NSNumber *isClubOnly;

- (BOOL)userIsInLikeList:(FZUser *)user;
- (void)addUserInLikers:(FZUser *)user;
- (void)removeUserInLikers:(FZUser *)user;
- (BOOL)isAllSoldOut;
- (BOOL)isAllSoldOutOnlyCard;

@end
