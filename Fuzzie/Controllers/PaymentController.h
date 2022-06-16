//
//  PaymentController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 26/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^ErrorBlock)(NSError *error);

@interface PaymentController : NSObject

@property (strong, nonatomic) NSArray *paymentMethods;
@property (strong, nonatomic) NSArray *bankArray;

+ (instancetype)sharedInstance;

+ (void)addPaymentMethod:(NSDictionary*)dict withCompletion:(DictionaryWithErrorBlock)completion;
+ (void)getPaymentMethodsWithCompletion:(ArrayWithErrorBlock)completion;
+ (void)removePaymentMethodWithPaymentToken:(NSString *)token andCompletion:(ErrorBlock)completion;

+ (void)checkoutShoppingBagWithPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion;
+ (void)purchaseGiftCard:(NSDictionary *)giftCardDict withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion;
+ (void)purchaseGiftCardForGifting:(NSDictionary *)giftCardDict withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andMessage:(NSString*)message andFriendName:(NSString*)friendName andCompletion:(DictionaryWithErrorBlock)completion;
+ (void)purchaseFuzzieTopUp:(CGFloat)topUpValue withPaymentToken:(NSString*)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion;
+ (void)subscribeClub:(CGFloat)price withPaymentToken:(NSString*)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andReferralCode:(NSString*)referralCode andCompletion:(DictionaryWithErrorBlock)completion;

+ (void)getBanksWithCompletion:(ArrayWithErrorBlock)completion;
+ (void)validatePromoCode:(NSString *)promoCode andPaymentToken:(NSString *)token withCompletion:(DictionaryWithErrorBlock)completion;

+ (void)purchaseCoupon:(NSString*)couponTemplateId andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion;

@end
