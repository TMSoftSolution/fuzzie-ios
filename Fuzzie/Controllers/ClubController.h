//
//  ClubController.h
//  Fuzzie
//
//  Created by joma on 7/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubController : NSObject

+ (instancetype)sharedInstance;

+ (void)getClubHome:(DictionaryWithErrorBlock)completionBlock;
+ (void)storeBookmark:(NSString*)storeId completion:(ErrorBlock)completion;
+ (void)storeUnBookmark:(NSString*)storeId completion:(ErrorBlock)completion;
+ (void)getClubStoreDetail:(NSString*)storeId completion:(DictionaryWithErrorBlock)completion;
+ (void)getBrandTypeDetail:(NSNumber*)brandTypeId completion:(DictionaryWithErrorBlock)completion;
+ (void)getClubStores:(NSNumber*)brandTypeId completion:(ArrayWithErrorBlock) completion;
+ (void)getClubPlaces:(NSNumber*)brandTypeId completion:(ArrayWithErrorBlock) completion;
+ (void)getRedeemedClubOffers:(ArrayWithErrorBlock)completion;
+ (void)offerRedeem:(NSString*)offerId pin:(NSString*)pin completion:(DictionaryWithErrorBlock)completion;
+ (void)validatePromoCode:(NSString*)promoCode withCompletion:(DictionaryWithErrorBlock)completion;

@end
