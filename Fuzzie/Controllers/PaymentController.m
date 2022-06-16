//
//  PaymentController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 26/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "PaymentController.h"

@implementation PaymentController

+ (instancetype)sharedInstance {
    static PaymentController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PaymentController alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)addPaymentMethod:(NSDictionary *)dict withCompletion:(DictionaryWithErrorBlock)completion{
    
    [[APIClient sharedInstance] POST:@"api/rdp/add_card" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion){
            
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else if (operation.response.statusCode == 406){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:operation.response.statusCode
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil,error);
                
            } else {
                completion(nil,error);
            }
        }
        
    }];
}

+ (void)getPaymentMethodsWithCompletion:(ArrayWithErrorBlock)completion {
    [[APIClient sharedInstance] GET:@"api/rdp/list_cards" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [PaymentController sharedInstance].paymentMethods = responseObject;
        
        if (completion) {
            completion(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil,error);
                
            } else {
                completion(nil,error);
            }
        }
        
    }];
}

+ (void)removePaymentMethodWithPaymentToken:(NSString *)token andCompletion:(ErrorBlock)completion {
    
    NSDictionary *param = @{@"token" : token};
   
    [[APIClient sharedInstance] DELETE:@"api/rdp/delete_card" parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(error);
                
            } else {
                completion(error);
            }
        }
        
    }];
}

+ (void)checkoutShoppingBagWithPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion {
    
    NSMutableDictionary *params = [@{
                             @"message": @"No Message",
                             @"wallet": @(creditsAmount),
                             @"payment_mode":paymentMode} mutableCopy];
    
    NSMutableDictionary *payment = [[NSMutableDictionary alloc] init];
    
    if (paymentToken) {
        [payment setObject:paymentToken forKey:@"token"];
        [params setObject:payment forKey:@"rdp"];
    }
    
    if (cardInfo) {
        [params setObject:cardInfo forKey:@"rdp"];
    }
    
    if (netsInfo) {
        [params setObject:netsInfo forKey:@"netspay"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"api/shopping_bag/checkout" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 409 || operation.response.statusCode == 410 || operation.response.statusCode == 420) {
            
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
            
            if (errorDict && errorDict[@"error"]) {
                NSError *customError = [NSError errorWithDomain:@"Fuzzie"
                                                           code:operation.response.statusCode
                                                       userInfo:@{ NSLocalizedDescriptionKey: errorDict[@"error"] }];
                completion(nil, customError);
            } else {
                completion(nil, error);
            }
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil,error);
            
        } else {
            completion(nil,error);
        }
        
    }];
    
}

+ (void)purchaseGiftCard:(NSDictionary *)giftCardDict withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andCompletion:(DictionaryWithErrorBlock)completion {
    
    NSMutableDictionary *params = [@{
                                     @"message": @"No Message",
                                     @"gift_card_type": giftCardDict[@"type"],
                                     @"wallet": @(creditsAmount),
                                     @"payment_mode":paymentMode} mutableCopy];
    
    NSMutableDictionary *payment = [[NSMutableDictionary alloc] init];
    
    if (paymentToken) {
        [payment setObject:paymentToken forKey:@"token"];
        [params setObject:payment forKey:@"rdp"];
    }
    
    if (cardInfo) {
        [params setObject:cardInfo forKey:@"rdp"];
    }
    
    if (netsInfo) {
        [params setObject:netsInfo forKey:@"netspay"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"gifts" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 409 || operation.response.statusCode == 410 || operation.response.statusCode == 420) {
            
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
            
            if (errorDict && errorDict[@"error"]) {
                NSError *customError = [NSError errorWithDomain:@"Fuzzie"
                                                           code:operation.response.statusCode
                                                       userInfo:@{ NSLocalizedDescriptionKey: errorDict[@"error"] }];
                completion(nil, customError);
            } else {
                completion(nil, error);
            }
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil,error);
            
        } else {
            completion(nil,error);
        }
        
    }];
    
}

+ (void)purchaseGiftCardForGifting:(NSDictionary *)giftCardDict withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo andCredits:(CGFloat)creditsAmount andPaymentMode:(NSString*)paymentMode andPromoCode:(NSString*)promoCode andMessage:(NSString*)message andFriendName:(NSString*)friendName andCompletion:(DictionaryWithErrorBlock)completion{
    NSMutableDictionary *params = [@{
                                     @"message": message,
                                     @"gift_card_type": giftCardDict[@"type"],
                                     @"wallet": @(creditsAmount),
                                     @"payment_mode":paymentMode,
                                     @"gifted": @true,
                                     @"friend_name": friendName} mutableCopy];
    
    NSMutableDictionary *payment = [[NSMutableDictionary alloc] init];
    
    if (paymentToken) {
        [payment setObject:paymentToken forKey:@"token"];
        [params setObject:payment forKey:@"rdp"];
    }
    
    if (cardInfo) {
        [params setObject:cardInfo forKey:@"rdp"];
    }
    
    if (netsInfo) {
        [params setObject:netsInfo forKey:@"netspay"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"gifts" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 409 || operation.response.statusCode == 410 || operation.response.statusCode == 420) {
            
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
            
            if (errorDict && errorDict[@"error"]) {
                NSError *customError = [NSError errorWithDomain:@"Fuzzie"
                                                           code:operation.response.statusCode
                                                       userInfo:@{ NSLocalizedDescriptionKey: errorDict[@"error"] }];
                completion(nil, customError);
            } else {
                completion(nil, error);
            }
            
        }  else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil,error);
            
        } else {
            completion(nil,error);
        }
        
    }];
}

+ (void)purchaseFuzzieTopUp:(CGFloat)topUpValue withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary*)cardInfo andNetsInfo:(NSDictionary*)netsInfo  andPaymentMode:(NSString *)paymentMode andPromoCode:(NSString *)promoCode andCompletion:(DictionaryWithErrorBlock)completion{
    
    NSMutableDictionary *params = [@{@"top_up_value":@(topUpValue),
                                     @"payment_mode":paymentMode} mutableCopy];
    
    NSMutableDictionary *payment = [[NSMutableDictionary alloc] init];

    if (paymentToken) {
        [payment setObject:paymentToken forKey:@"token"];
        [params setObject:payment forKey:@"rdp"];
    }
    
    if (cardInfo) {
        [params setObject:cardInfo forKey:@"rdp"];
    }
    
    if (netsInfo) {
        [params setObject:netsInfo forKey:@"netspay"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"api/credits/top_up" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 409 || operation.response.statusCode == 410) {
            
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
            
            if (errorDict && errorDict[@"error"]) {
                NSError *customError = [NSError errorWithDomain:@"Fuzzie"
                                                           code:operation.response.statusCode
                                                       userInfo:@{ NSLocalizedDescriptionKey: errorDict[@"error"] }];
                completion(nil, customError);
            } else {
                completion(nil, error);
            }
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil,error);
            
        } else {
            completion(nil,error);
        }
    }];
}

+ (void)subscribeClub:(CGFloat)price withPaymentToken:(NSString *)paymentToken andCardInfo:(NSDictionary *)cardInfo andNetsInfo:(NSDictionary *)netsInfo andPaymentMode:(NSString *)paymentMode andPromoCode:(NSString *)promoCode andReferralCode:(NSString *)referralCode andCompletion:(DictionaryWithErrorBlock)completion{
    
    NSMutableDictionary *params = [@{@"wallet":@(price),
                                     @"payment_mode":paymentMode} mutableCopy];
    
    NSMutableDictionary *payment = [[NSMutableDictionary alloc] init];
    
    if (paymentToken) {
        [payment setObject:paymentToken forKey:@"token"];
        [params setObject:payment forKey:@"rdp"];
    }
    
    if (cardInfo) {
        [params setObject:cardInfo forKey:@"rdp"];
    }
    
    if (netsInfo) {
        [params setObject:netsInfo forKey:@"netspay"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    if (referralCode) {
        [params setObject:referralCode forKey:@"referral_code"];
    }
    
    [[APIClient sharedInstance] POST:@"api/fuzzie_club/membership/renew" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 409 || operation.response.statusCode == 410) {
            
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
            
            if (errorDict && errorDict[@"error"]) {
                NSError *customError = [NSError errorWithDomain:@"Fuzzie"
                                                           code:operation.response.statusCode
                                                       userInfo:@{ NSLocalizedDescriptionKey: errorDict[@"error"] }];
                completion(nil, customError);
            } else {
                completion(nil, error);
            }
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil,error);
            
        } else {
            completion(nil,error);
        }
    }];
}

+ (void)getBanksWithCompletion:(ArrayWithErrorBlock)completion {
    
    [[APIClient sharedInstance] GET:@"api/banks" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [PaymentController sharedInstance].bankArray = responseObject;
        
        if (completion) {
            completion(responseObject,nil);
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
   
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
     
        if (completion) {
            completion(nil,error);
        }
        
    }];
    
}

+ (void)validatePromoCode:(NSString *)promoCode andPaymentToken:(NSString *)token withCompletion:(DictionaryWithErrorBlock)completion {
 
    if (!promoCode) return;
 
    NSDictionary *params = nil;
    
    if (token) {
        params = @{ @"payment_method_token": token };
    }
    
    NSString *path = [NSString stringWithFormat:@"api/promo_codes/%@/validate", promoCode];
  
    [[APIClient sharedInstance] GET:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
    
        if (completion) {
            completion(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion){
         
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else if (operation.response.statusCode == 409 || operation.response.statusCode == 410 || operation.response.statusCode == 411 || operation.response.statusCode == 412 || operation.response.statusCode == 416) {
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:operation.response.statusCode
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil,error);
                
            } else {
                completion(nil,error);
            }

        }
    }];
    
}

+ (void)purchaseCoupon:(NSString *)couponTemplateId andPromoCode:(NSString *)promoCode andCompletion:(DictionaryWithErrorBlock)completion{
    
    NSMutableDictionary *params = [@{    @"coupon_template_id": couponTemplateId} mutableCopy];
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"api/v2/jackpot/coupons" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion){
            
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else if (operation.response.statusCode == 406 || operation.response.statusCode == 415 || operation.response.statusCode == 420){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:operation.response.statusCode
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil,error);
                
            } else {
                completion(nil,error);
            }
        }
    }];
}

@end
