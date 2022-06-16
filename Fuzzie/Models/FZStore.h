//
//  FZStore.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 7/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FZStore : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *businessHours;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *acceptsGiftRedemption;

@property (nonatomic, strong) NSNumber *subCategoryId;

@end
