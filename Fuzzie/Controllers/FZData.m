//
//  FZData.m
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZData.h"

static FZData *sharedInstance = nil;

@implementation FZData

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FZData alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    self.filterSubCategoryIds = [[NSMutableSet alloc] init];
    self.selectedTab = 0;
    self.selectedPaymentMethod = nil;
    
    self.brandListSortItemArray = @[@"Trending",
                                    @"Likes",
                                    @"Cashback Percentage",
                                    @"Name"];
    self.selectedSortIndex = 0;
    self.selectedCategoryIds = [[NSMutableSet alloc] init];
    self.selectedRefineSubCategoryIds = [[NSMutableSet alloc] init];
    
    self.jackpotListSortItemArray = @[@"Trending",
                                      @"Price (high)",
                                      @"Price (low)",
                                      @"Lowest cost per ticket",
                                      @"Jackpot tickets given",
                                      @"Cashback",
                                      @"Name (A to Z)"];
    self.selectedJackpotSortIndex = 0;
    self.selectedJackpotRefineSubCategoryIds = [[NSMutableSet alloc] init];
        
    return self;
}

+ (void)resetSharedInstance{
    sharedInstance = [[FZData alloc] init];
}

+ (void)removeActiveGift:(NSDictionary *)gift{
    
    for (NSDictionary *dict in [FZData sharedInstance].activeGiftBox) {
        if ([dict[@"id"] isEqualToString:gift[@"id"]]) {
            [[FZData sharedInstance].activeGiftBox removeObject:dict];
            break;
        }
    }
    
}

+ (void)removeUsedGift:(NSDictionary *)gift{
    
    for (NSDictionary *dict in [FZData sharedInstance].usedGiftBox) {
        if ([dict[@"id"] isEqualToString:gift[@"id"]]) {
            [[FZData sharedInstance].usedGiftBox removeObject:dict];
            break;
        }
    }
}

+ (FZBrand*)getBrandById:(NSString *)brandId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brandId == %@", brandId];
    NSArray *filteredArray = [[FZData sharedInstance].brandSet.allObjects filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] == 0) {
        return nil;
    } else{
        return [filteredArray objectAtIndex:0];
    }
}

+ (NSArray*)getUpcomingBirthdays{
    
    NSArray *upcomingBirthdays = [[NSArray alloc] init];
    NSMutableArray *friendsToday = [[NSMutableArray alloc] init];
    NSMutableArray *friendsAfter = [[NSMutableArray alloc] init];
    NSMutableArray *friendsBefore = [[NSMutableArray alloc] init];
    
    NSDate *today = [NSDate date];
    
    for (FZUser *user in [FZData sharedInstance].fuzzieFriends) {
        
        NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:user.birthday];
        
        if ([birthdayDate month] == [today month]) {
            
            if ([birthdayDate day] == [today day]) {
                
                [friendsToday addObject:user];
                
            } else if ([birthdayDate day] > [today day]){
                
                [friendsAfter addObject:user];
                
            } else{
                
                [friendsBefore addObject:user];
                
            }
            
        } else if([birthdayDate month] > [today month]){
            
            [friendsAfter addObject:user];
            
        } else{
            
            [friendsBefore addObject:user];
            
        }
    }
    
    upcomingBirthdays = [[[friendsToday arrayByAddingObjectsFromArray:friendsToday] arrayByAddingObjectsFromArray:friendsAfter] arrayByAddingObjectsFromArray:friendsBefore];
    
    return upcomingBirthdays;
}

+ (FZUser*)getDummyUser{
    FZUser *user = [[FZUser alloc] init];
    user.bearAvatar = [NSString stringWithFormat:@"icon-more-upcoming"];
    return user;
}

+ (NSArray*)getStoreArray{
    NSArray *storeArray = [[NSArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (FZBrand *brand in [FZData sharedInstance].brandArray) {
        if (brand.stores) {
            for (FZStore *store in brand.stores) {
                if (brand.subcategoryId) {
                    [store setSubCategoryId:brand.subcategoryId];
                } else{
                    [store setSubCategoryId:[NSNumber numberWithInteger:30]];

                }
                [array addObject:store];
            }
        }
    }
    
    storeArray = array;
    
    return storeArray;
}


+ (NSDictionary*)getSortedStores:(NSArray*)storeArray{
    NSMutableDictionary *storeDict = [[NSMutableDictionary alloc] init];
    for (FZStore *store in storeArray) {
        NSString *keyString = [NSString stringWithFormat:@"%@-%@", store.latitude, store.longitude];
        if ([storeDict objectForKey:keyString]) {
            NSMutableArray *storeArray = [storeDict valueForKey:keyString];
            [storeArray addObject:store];
        } else{
            NSMutableArray *storeArray = [[NSMutableArray alloc] init];
            [storeArray addObject:store];
            [storeDict setObject:storeArray forKey:keyString];
        }
        
    }
    
    return storeDict;
}

+ (FZStore*) getStoreById:(NSString *)storeId{
    NSArray *storeArray = [FZData getStoreArray];
    for (FZStore *store in storeArray) {
        if ([store.storeId isEqualToString:storeId]) {
            return store;
            break;
        }
    }
    
    return nil;
}

+ (NSArray*)getUsedSubCategories{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (FZStore *store in [FZData getStoreArray]) {
        [array addObject:store.subCategoryId];
    }
    
    NSSet *subCategorySet = [[NSSet alloc] initWithArray:array];
    
    NSArray *sortedArray = [[subCategorySet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSArray *usedSubCategoryArray = [[NSArray alloc] init];
    NSMutableArray *usedSubCategoryArrayTemp = [[NSMutableArray alloc] init];
    
    for (NSNumber *subId in sortedArray) {
        for (NSDictionary *dict in [FZData sharedInstance].subCategoryArray) {
            if ([subId isEqualToNumber:dict[@"id"]]) {
                [usedSubCategoryArrayTemp addObject:dict];
                break;
            }
        }
    }
    
    usedSubCategoryArray = usedSubCategoryArrayTemp;
    
    return usedSubCategoryArray;
}

+ (NSArray*) getUsedSubCategoryIds{
     NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [FZData getUsedSubCategories]) {
        if (dict[@"id"]) {
            [array addObject:dict[@"id"]];
        }
    }
    
    NSArray *subCategoryIds = array;
    return subCategoryIds;
}

+ (void)setFullFilterSubCategoris{
    [FZData sharedInstance].filterSubCategoryIds = [[NSMutableSet alloc] initWithArray:[FZData getUsedSubCategoryIds]];
    
}

+ (NSArray*)getSubCategoriesWith:(NSArray *)brandArray{
    
    NSArray *subCategories = [[NSArray alloc] init];
    NSMutableArray *tempSubCategories = [[NSMutableArray alloc] init];
    NSMutableSet *categoryIds = [[NSMutableSet alloc] init];
    for (FZBrand *brand in brandArray) {
        if (![categoryIds containsObject:brand.subcategoryId]) {
            [categoryIds addObject:brand.subcategoryId];
        }
    }
    
    for (NSNumber *subCategoryId in categoryIds) {
        for (NSDictionary *dict in [FZData sharedInstance].subCategoryArray) {
            if ([subCategoryId isEqualToNumber:dict[@"id"]]) {
                [tempSubCategories addObject:dict];
                break;
            }
        }
    }
    
    subCategories = tempSubCategories;
    
    return subCategories;
}

+ (NSArray*) getCategoriesWith:(NSArray *)brandArray{
    NSArray *categories = [[NSArray alloc] init];
    NSMutableArray *tempCategories = [[NSMutableArray alloc] init];
    NSMutableSet *categoryIds = [[NSMutableSet alloc] init];
    for (FZBrand *brand in brandArray) {
        for (NSString *string in brand.categoryIds) {
            [categoryIds addObject:string];
        }
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *categoryId in categoryIds) {
        NSNumber *numberId = [formatter numberFromString:categoryId];
        for (NSDictionary *dict in [FZData sharedInstance].categoryArray) {
            if ([numberId isEqual:dict[@"id"]]) {
                [tempCategories addObject:dict];
                break;
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    categories = [tempCategories sortedArrayUsingDescriptors:@[descriptor]];
    
    return categories;
}

+ (NSArray *)getSubCategoriesWithCouponArray:(NSArray *)couponArray{
    NSArray *subCategories = [[NSArray alloc] init];
    NSMutableArray *tempSubCategories = [[NSMutableArray alloc] init];
    NSMutableSet *categoryIds = [[NSMutableSet alloc] init];
    for (FZCoupon *coupon in couponArray) {
        if (coupon.subcategoryId && ![categoryIds containsObject:coupon.subcategoryId]) {
            [categoryIds addObject:coupon.subcategoryId];
        }
    }
    
    for (NSNumber *subCategoryId in categoryIds) {
        for (NSDictionary *dict in [FZData sharedInstance].subCategoryArray) {
            if ([subCategoryId isEqualToNumber:dict[@"id"]]) {
                [tempSubCategories addObject:dict];
                break;
            }
        }
    }
    
    subCategories = tempSubCategories;
    
    return subCategories;
}

+ (NSArray *)getPowerUpPacks{
    
    NSArray *powerupPacks = [[NSArray alloc] init];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if ([FZData sharedInstance].coupons) {
        for (FZCoupon *coupon in [FZData sharedInstance].coupons) {
            if (coupon.powerUpPack) {
                [temp addObject:coupon];
            }
        }
    }
    
    powerupPacks = temp;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"powerUpPack.sequence" ascending:YES];
    NSArray *sortDescriptor = [NSArray arrayWithObject:sort];
    return [powerupPacks sortedArrayUsingDescriptors:sortDescriptor];
    
}

+ (void)saveWinningResult:(NSDictionary *)dictonary{
    [[NSUserDefaults standardUserDefaults] setObject:dictonary forKey:@"winning"];
}

+ (NSDictionary*)getWinningResult{
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"winning"];
    return dictionary;
}

+ (BOOL)alreadyShownWinningPage:(NSDictionary *)winningDictionary{
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"winning"];
    if (dictionary) {
        if (dictionary[@"identifier"] && [dictionary[@"identifier"] isEqualToString:winningDictionary[@"identifier"]]) {
            return true;
        }
    }
    
    return false;
}

+ (BOOL)isCuttingOffLiveDraw{
    
    NSDate *drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
    NSDate *now = [NSDate date];
    
    if ([now isLaterThanOrEqualTo:[drawTime dateByAddingMinutes:-15]]) {
        return true;
    }

    return false;
}

+ (FZCoupon*)getCouponById:(NSString *)couponId{
    
    if ([FZData sharedInstance].coupons && [FZData sharedInstance].coupons.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"couponId == %@", couponId];
        NSSet *couponSet = [[NSSet alloc] initWithArray:[FZData sharedInstance].coupons];
        NSArray *filteredArray = [couponSet.allObjects filteredArrayUsingPredicate:predicate];
        if ([filteredArray count] == 0) {
            return nil;
        } else{
            return [filteredArray objectAtIndex:0];
        }
    }
    
    return nil;
}

+ (void)replaceActiveGift:(NSDictionary *)giftDict{
    
    for (int i = 0; i < [FZData sharedInstance].activeGiftBox.count; i ++) {
        NSDictionary *dict = [[FZData sharedInstance].activeGiftBox objectAtIndex:i];
        if ([dict[@"id"] isEqualToString:giftDict[@"id"]]) {
            [[FZData sharedInstance].activeGiftBox replaceObjectAtIndex:i withObject:giftDict];
            break;
        }
    }
}


+ (void)replaceSentGift:(NSDictionary *)giftDict{
    
    for (int i = 0; i < [FZData sharedInstance].sentGiftBox.count; i ++) {
        NSDictionary *dict = [[FZData sharedInstance].sentGiftBox objectAtIndex:i];
        if ([dict[@"id"] isEqualToString:giftDict[@"id"]]) {
            [[FZData sharedInstance].sentGiftBox replaceObjectAtIndex:i withObject:giftDict];
            break;
        }
    }
}

+ (BOOL)alreadyExistUsedGift:(NSDictionary *)giftDict{
    
    BOOL alreadyExist = false;
    
    for (NSDictionary *dict in [FZData sharedInstance].usedGiftBox) {
        if ([dict[@"id"] isEqualToString:giftDict[@"id"]]) {
            alreadyExist = true;
            break;
        }
    }
    
    return alreadyExist;
}

+ (NSArray *)getMiniBanners:(NSString *)bannerType{
    
    NSMutableArray *miniBanners = [[NSMutableArray alloc] init];
    if ([FZData sharedInstance].miniBannerArray && [FZData sharedInstance].miniBannerArray.count > 0) {
        for (NSDictionary *miniBanner in [FZData sharedInstance].miniBannerArray) {
            if (miniBanner[@"banner_type"] && [miniBanner[@"banner_type"] isEqualToString:bannerType]) {
                [miniBanners addObject:miniBanner];
            }
        }
    }
    
    return miniBanners;
}

+ (void)replaceReceivedRedPacket:(NSDictionary *)redPacket{
    
    if ([FZData sharedInstance].receivedRedPackets && [FZData sharedInstance].receivedRedPackets.count > 0) {
        
        for (int i = 0 ; i < [FZData sharedInstance].receivedRedPackets.count ; i ++) {
            
            NSDictionary *dict = [[FZData sharedInstance].receivedRedPackets objectAtIndex:i];
            if ([dict[@"id"] isEqualToString:redPacket[@"id"]]) {
                [[FZData sharedInstance].receivedRedPackets replaceObjectAtIndex:i withObject:redPacket];
                break;
            }
        }
    }
}

+ (NSDictionary *)getBrandType:(NSNumber*)brandTypeId{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", brandTypeId];
    NSArray *filteredArray = [[FZData sharedInstance].clubBrandTypes filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] == 0) {
        return nil;
    } else{
        return [filteredArray objectAtIndex:0];
    }
    
}

+ (NSDictionary *)getOfferType:(NSNumber *)offerId brandType:(NSDictionary *)brandType{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", offerId];
    NSArray *filteredArray = [brandType[@"offer_types"] filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] == 0) {
        return nil;
    } else{
        return [filteredArray objectAtIndex:0];
    }
    
}

+ (NSDictionary *)getClubStore:(NSString *)storeId stores:(NSArray *)stores{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", storeId];
    NSArray *filteredArray = [stores filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] == 0) {
        return nil;
    } else{
        return [filteredArray objectAtIndex:0];
    }
}

@end
