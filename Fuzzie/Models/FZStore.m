//
//  FZStore.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 7/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZStore.h"

@implementation FZStore

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"name": @"store.name",
              @"address": @"store.address",
              @"brandId": @"store.brand_id",
              @"storeId": @"store.id",
              @"businessHours": @"store.business_hours",
              @"phone": @"store.phone",
              
              @"latitude": @"store.latitude",
              @"longitude": @"store.longitude",
              @"acceptsGiftRedemption": @"store.accepts_gift_redemption" };
}

@end
