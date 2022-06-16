//
//  FZBrand.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZBrand.h"

@implementation FZBrand

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"brandId": @"id",
              @"name": @"name",
              @"about": @"description",
              @"subcategoryId": @"sub_category_id",
              @"categoryIds" : @"category_ids",
              @"backgroundImage": @"background_image_url",
              @"halal": @"halal",
              @"online": @"online",
              @"parentBrandId": @"parent_brand_id",
              @"website": @"website",
              @"facebook": @"facebook_url",
              @"twitter": @"twitter_url",
              @"instagram": @"instagram_url",
              @"likers": @"likers",
              @"isLiked":@"liked",
              @"isWishListed":@"wish_listed",
              @"likersCount": @"likers_count",
              @"stores": @"stores",
              @"termsAndConditions": @"terms_and_conditions_text",
              @"giftCards": @"gift_cards",
              @"services": @"services",
              @"serviceCategories": @"service_categories",
              @"othersAlsoBought": @"others_also_bought",
              @"percentage": @"cash_back.percentage",
              @"cashbackPercentage": @"cash_back.cash_back_percentage",
              @"powerupPercentage": @"cash_back.power_up_percentage",
              @"isNewBrand": @"new",
              @"textOptionGiftCard": @"options_for_gift_cards",
              @"textOptionPackage": @"options_for_services",
              @"tripadvisorReviewCount": @"tripadvisor.reviews_count",
              @"tripadvisorRating": @"tripadvisor.rating",
              @"tripadvisorLink": @"tripadvisor.link",
              @"coverPictures": @"photos",
              @"soldOut":@"sold_out",
              @"powerUp":@"power_up",
              @"jackpotCouponsPresent":@"jackpot_coupons_present",
              @"couponOnly":@"jackpot_coupon_only",
              @"coupons":@"jackpot_coupon_templates",
              @"isClubOnly":@"club_only_vouchers"
              };
    
}

+ (NSValueTransformer *)likersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:FZUser.class];
}

+ (NSValueTransformer *)storesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:FZStore.class];
}

+ (NSValueTransformer *)couponsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:FZCoupon.class];
}

//- (BOOL)userIsInWishlist:(FZUser *)user {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fuzzieId == %@", user.fuzzieId];
//    NSArray *filteredArray = [self.likers filteredArrayUsingPredicate:predicate];
//    if ([filteredArray count] == 0) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

- (BOOL)userIsInLikeList:(FZUser *)user {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fuzzieId == %@", user.fuzzieId];
    NSArray *filteredArray = [self.likers filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)addUserInLikers:(FZUser *)user {
    NSMutableSet *newLiker = nil;
    if (self.likers == nil) {
      newLiker = [[NSMutableSet alloc] init];
    } else {
        newLiker = [[NSMutableSet alloc] initWithArray:self.likers];
    }
    [newLiker addObject:user];
    self.likers = [[NSMutableArray alloc] initWithArray:[newLiker allObjects]];
}

- (void)removeUserInLikers:(FZUser *)user {
    NSMutableSet *newLiker = nil;
    if (self.likers == nil) {
        newLiker = [[NSMutableSet alloc] init];
    } else {
        newLiker = [[NSMutableSet alloc] initWithArray:self.likers];
    }
    [newLiker removeObject:user];
    self.likers = [[NSMutableArray alloc] initWithArray:[newLiker allObjects]];
}

- (BOOL)isAllSoldOut {
    
    if (self.giftCards.count == 0 && self.services.count == 0) {
        
        return NO;
    }
    
    for (NSDictionary *giftCard in self.giftCards) {
        if ([giftCard[@"sold_out"] isEqual:@(NO)]) {
            return NO;
        }
    }
    
    
    for (NSDictionary *service in self.services) {
        if ([service[@"sold_out"] isEqual:@(NO)]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isAllSoldOutOnlyCard {
    for (NSDictionary *giftCard in self.giftCards) {
        if ([giftCard[@"sold_out"] isEqual:@(NO)]) {
            return NO;
        }
    }
    
    return YES;
}

@end
