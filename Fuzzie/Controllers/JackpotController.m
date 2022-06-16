//
//  JackpotController.m
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotController.h"

typedef void (^DictionaryBlock)(NSDictionary *dictionary);
typedef void (^DictionaryWithErrorBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^ArrayWithErrorBlock)(NSArray *array, NSError *error);
typedef void (^ErrorBlock)(NSError *error);

@implementation JackpotController

+ (instancetype)sharedInstance {
    static JackpotController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JackpotController alloc] init];
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


+ (void)getCouponTemplateWithBrandId:(NSString *)brandId andCompletion:(DictionaryWithErrorBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"/api/brands/%@/jackpot_coupon_templates", brandId];
    
    [[APIClient sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
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

+ (void)getCouponTemplate:(DictionaryWithErrorBlock)completionBlock{
    [[APIClient sharedInstance] GET:@"api/jackpot/coupon_templates/all" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
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

+ (void)getIssuedTicketsCount:(DictionaryWithErrorBlock)completion{
    [[APIClient sharedInstance] GET:@"api/jackpot/tickets/global_count" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil,error);
        }
    }];
}

+ (void)getCouponLearnMore:(ArrayWithErrorBlock)completionBlock{
    [[APIClient sharedInstance] GET:@"api/jackpot/learn_more" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
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

+ (void)getJackpotResult:(DictionaryWithErrorBlock)completionBlock{
    [[APIClient sharedInstance] GET:@"api/jackpot/results" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
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

+ (void)getLiveDrawStreamingUrl:(DictionaryBlock)completionBlock{
    
    [[APIClient sharedInstance] GET:@"api/jackpot/streaming_url" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);

        if (responseObject) {
            completionBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completionBlock) {
            completionBlock(nil);
        }

    }];
}

+ (void)getJackpotLiveDrawResult:(DictionaryWithErrorBlock)completionBlock{
    
    NSString *endpoint = API_JACKPOT_END_POINT;
    
    NSNumber *drawId = [[NSUserDefaults standardUserDefaults] objectForKey:JACKPOT_DRAW_ID];
    if (drawId) {
        endpoint = [NSString stringWithFormat:@"%@/%d", API_JACKPOT_END_POINT, [drawId intValue]];
    }
    
    [[APIClient sharedInstanceForJackpotLive] GET:endpoint parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completionBlock(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(nil, error);
                
            } else {
                completionBlock(nil, error);
            }
            
        }
    }];
}

+ (void)setJackpotTickets:(NSArray *)tickets withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSDictionary *params = @{@"four_d_numbers": tickets};
    
    [[APIClient sharedInstance] POST:@"api/jackpot/tickets/set" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (completion){
            
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else if (operation.response.statusCode == 413 || operation.response.statusCode == 416 || operation.response.statusCode == 419 || operation.response.statusCode == 421){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:operation.response.statusCode
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil,error);
                
            } else if (operation.response.statusCode == 412) {
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"four_d"];
                
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

+ (void)getPowerUpPreviewBrandIds:(DictionaryWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"api/power_up_preview_brands" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completion) {
            completion(nil, error);
        }
        
    }];
}

@end
