//
//  BrandController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZBrand.h"

typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^BrandWithErrorBlock)(FZBrand *brand, NSError *error);
typedef void (^ErrorBlock)(NSError *error);

@interface BrandController : NSObject

+ (instancetype)sharedInstance;

+ (void)getHomeWithRefresh:(BOOL)refresh withSuccess:(DictionaryWithErrorBlock)completionBlock;

+ (void)addBrandToWishList:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock;
+ (void)removeBrandFromWishList:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock;
+ (void)getTripAdvisorInfo:(NSString *)brandId withSuccess:(DictionaryWithErrorBlock)completionBlock;
+ (void)removeLikeToBrand:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock;
+ (void)addLikeToBrand:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock;
+ (void)getLikes:(NSString *)brandId withSuccess:(ArrayWithErrorBlock)completionBlock;
+ (void)getOthersAlsoBoughtId:(NSString *)brandId withSuccess:(ArrayWithErrorBlock)completionBlock;
+ (void)getBrand:(NSString *)brandId withSuccess:(BrandWithErrorBlock)completionBlock;
+ (void)getRedeemInstructionsForBrandId:(NSString *)brandId withCompletion:(ArrayWithErrorBlock)completionBlock;
+ (void)getRedeemInstructionForPowerUp:(ArrayWithErrorBlock)completionBlock;
+ (void)saveBrandView:(NSString*)brandId;


@end
