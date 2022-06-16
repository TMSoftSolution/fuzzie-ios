//
//  ClubController.m
//  Fuzzie
//
//  Created by joma on 7/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubController.h"

@implementation ClubController

+ (instancetype)sharedInstance {
    static ClubController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ClubController alloc] init];
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

+ (void)getClubHome:(DictionaryWithErrorBlock)completionBlock{
    
    NSString *url = @"/api/fuzzie_club/home";
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CLUB_HOME_LOADED object:nil];
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CLUB_HOME_LOAD_FAILED object:nil];
        
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(nil,error);
                
            } else {
                completionBlock(nil,error);
            }
        }
        
    }];
}

+ (void)storeBookmark:(NSString *)storeId completion:(ErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/stores/%@/bookmark", storeId];
    [[APIClient sharedInstance] PUT:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(error);
        }
        
    }];
}

+ (void)storeUnBookmark:(NSString *)storeId completion:(ErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/stores/%@/unbookmark", storeId];
    [[APIClient sharedInstance] PUT:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(error);
        }
        
    }];
}

+ (void)getClubStoreDetail:(NSString *)storeId completion:(DictionaryWithErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/stores/%@", storeId];
    
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

+ (void)getBrandTypeDetail:(NSNumber *)brandTypeId completion:(DictionaryWithErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/brand_types/%@/details", brandTypeId];
    
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

+ (void)getClubStores:(NSNumber *)brandTypeId completion:(ArrayWithErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/brand_types/%@/stores", brandTypeId];
    
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

+ (void)getClubPlaces:(NSNumber *)brandTypeId completion:(ArrayWithErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/brand_types/%@/places", brandTypeId];
    
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil, error);
        }
    }];
    
}

+ (void)getRedeemedClubOffers:(ArrayWithErrorBlock)completion{
    
    NSString *url = @"api/fuzzie_club/offer_coupons";
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

+ (void)offerRedeem:(NSString *)offerId pin:(NSString *)pin completion:(DictionaryWithErrorBlock)completion{
    
    NSString *url = [NSString stringWithFormat:@"api/fuzzie_club/offers/%@/redeem", offerId];
    NSDictionary *params = @{@"pin":pin};
    
    [[APIClient sharedInstance] POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        NSError* error1;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                 options:kNilOptions
                                                                   error:&error1];
        NSString *message = [response objectForKey:@"error"];
        
        if (message) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:operation.response.statusCode
                                             userInfo:@{ NSLocalizedDescriptionKey: message }];
            completion(nil,error);
            
        } else {
            
            completion(nil,error);
        }
        
        
    }];
}

+ (void)validatePromoCode:(NSString *)promoCode withCompletion:(DictionaryWithErrorBlock)completion{
    
    if (!promoCode) return;

    NSString *path = [NSString stringWithFormat:@"api/fuzzie_club/promo_codes/%@/validate", promoCode];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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

@end
