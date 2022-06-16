//
//  GiftController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^ErrorBlock)(NSError *error);

@interface GiftController : NSObject

+ (instancetype)sharedInstance;

// Shopping Bag
+ (void)getShoppingBagWithCompletion:(DictionaryWithErrorBlock)completion;
+ (void)addItemToShoppingBagWithID:(NSString *)itemID withCompletion:(ErrorBlock)completion;
+ (void)removeItemToShoppingBagWithID:(NSString *)itemID withCompletion:(ErrorBlock)completion;
+ (void)removeItemToShoppingBagWithIDs:(NSArray *)itemIDs withCompletion:(ErrorBlock)completion;

// Gift Box
+ (void)redeemGiftCard:(NSDictionary *)giftCard withMerchantPin:(NSString *)merchantPin withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)markAsOpenedForGiftCard:(NSDictionary *)giftCard withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)markAsRedeemedForGiftCard:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)markAsOpenedReceivedGift:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)markAsUnredeemedOnlineGift:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)markAsDelivered:(NSString*)giftId withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)addGiftedGift:(NSString *)giftId withCompletion:(ErrorBlock)completion;

// New Gift Box API
+ (void)getActiveGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion;
+ (void)getUsedGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion;
+ (void)getSentGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion;
+ (void)updageGiftInfoWithGiftId:(NSString*)giftId andName:(NSString *)name andMessage:(NSString *)message withCompletion:(DictionaryWithErrorBlock)completion;

// Physical Cards
+ (void)activateGiftCardWithCode:(NSString *)code force:(BOOL)force withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)errorBlock;
+ (void)redeemPowerUpGiftCard:(NSString*)giftId withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)errorBlock;
+ (void)sendGiftViaEmailWithGiftId:(NSString*)giftId andReceiverEmail:(NSString*)email andCopy:(BOOL)copy withCompletion:(DictionaryWithErrorBlock) completion;

+ (void)resetUnopenedGiftsCount:(DictionaryWithErrorBlock)completion;
+ (void)resetUnopenedTicketsCount:(DictionaryWithErrorBlock)completion;
@end
