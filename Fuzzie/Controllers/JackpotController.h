//
//  JackpotController.h
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JackpotController : NSObject

+ (void)getCouponTemplate:(DictionaryWithErrorBlock)completionBlock;
+ (void)getIssuedTicketsCount:(DictionaryWithErrorBlock) completion;
+ (void)getCouponLearnMore:(ArrayWithErrorBlock)completionBlock;
+ (void)getCouponTemplateWithBrandId:(NSString*)brandId andCompletion:(DictionaryWithErrorBlock)completionBlock;
+ (void)getJackpotResult:(DictionaryWithErrorBlock)completionBlock;
+ (void)getLiveDrawStreamingUrl:(DictionaryBlock)completionBlock;
+ (void)getJackpotLiveDrawResult:(DictionaryWithErrorBlock)completionBlock;
+ (void)setJackpotTickets:(NSArray*)tickets withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)getPowerUpPreviewBrandIds:(DictionaryWithErrorBlock)completion;

@end
