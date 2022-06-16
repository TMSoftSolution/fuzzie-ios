//
//  FZCoupon.h
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface FZCoupon : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *backgroundImage;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSArray *terms;
@property (nonatomic, strong) NSString *brandId;

@property (nonatomic, strong) NSArray *stores;
@property (nonatomic, strong) NSArray *coverPictures;

@property (nonatomic, strong) NSNumber *priceValue;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *currencySymbol;

@property (nonatomic, strong) NSNumber *cashbackPercentage;
@property (nonatomic, strong) NSNumber *cashbackValue;

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSNumber *ticketCount;
@property (nonatomic, strong) NSNumber *soldOut;

@property (nonatomic, strong) NSString *redemptionStartDate;
@property (nonatomic, strong) NSString *redemptionEndDate;

@property (nonatomic, strong) NSDictionary *powerUpPack;

// Add brand name and categoryId for sort & refine
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSNumber *subcategoryId;
@property (nonatomic, strong) NSNumber *pricePerTicket;

@end
