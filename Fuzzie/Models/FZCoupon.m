//
//  FZCoupon.m
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZCoupon.h"

@implementation FZCoupon

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"couponId":@"id",
             @"name":@"name",
             @"backgroundImage":@"image",
             @"about":@"description",
             @"terms":@"terms",
             @"brandId":@"brand_id",
             @"stores": @"stores",
             @"coverPictures":@"photos",
             @"priceValue":@"price.value",
             @"currencyCode":@"price.currency_code",
             @"currencySymbol":@"price.currency_symbol",
             @"cashbackPercentage":@"cash_back.percentage",
             @"cashbackValue":@"cash_back.value",
             @"options":@"options",
             @"ticketCount":@"number_of_jackpot_tickets",
             @"soldOut":@"sold_out",
             @"redemptionStartDate":@"redemption_start_date",
             @"redemptionEndDate":@"redemption_end_date",
             @"powerUpPack":@"power_up_pack"
             };
}

+ (NSValueTransformer *)storesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:FZStore.class];
}

@end
