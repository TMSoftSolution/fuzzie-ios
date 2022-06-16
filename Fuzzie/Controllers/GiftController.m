//
//  GiftController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GiftController.h"

@implementation GiftController

+ (instancetype)sharedInstance {
    static GiftController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[GiftController alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingBag) name:SHOULD_REFRESH_SHOPPING_BAG object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_REFRESH_SHOPPING_BAG object:nil];
}

- (void)refreshShoppingBag {
    [GiftController getShoppingBagWithCompletion:nil];
}

+ (void)getShoppingBagWithCompletion:(DictionaryWithErrorBlock)completion {
    
    [[APIClient sharedInstance] GET:@"api/shopping_bag/items" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject && responseObject[@"shopping_bag"]) {
            
            [FZData sharedInstance].bagDict = responseObject[@"shopping_bag"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOPPING_BAG_REFRESHED object:nil];
            
            if (completion) {
                completion(responseObject[@"shopping_bag"], nil);
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
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

+ (void)addItemToShoppingBagWithID:(NSString *)itemID withCompletion:(ErrorBlock)completion {
    
    [[APIClient sharedInstance] POST:@"api/shopping_bag/add" parameters:@{ @"id": itemID } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [GiftController getShoppingBagWithCompletion:^(NSDictionary *dictionary, NSError *error) {
            
            if (completion) {
                completion(nil);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(error);
                
            } else if (operation.response.statusCode == 406) {
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:406
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(error);
            } else {
                completion(error);
            }

        }
        
    }];
    
}

+ (void)removeItemToShoppingBagWithID:(NSString *)itemID withCompletion:(ErrorBlock)completion {
    
    [[APIClient sharedInstance] DELETE:@"api/shopping_bag/remove" parameters:@{ @"id": itemID } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [GiftController getShoppingBagWithCompletion:^(NSDictionary *dictionary, NSError *error) {
        
            if (completion) {
                completion(nil);
            }
        }];
        
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

+ (void)removeItemToShoppingBagWithIDs:(NSArray *)itemIDs withCompletion:(ErrorBlock)completion{
    [[APIClient sharedInstance] DELETE:@"api/shopping_bag/remove" parameters:@{ @"ids": itemIDs } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [GiftController getShoppingBagWithCompletion:^(NSDictionary *dictionary, NSError *error) {
            
            if (completion) {
                completion(nil);
            }
        }];
        
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

+ (void)redeemGiftCard:(NSDictionary *)giftCard withMerchantPin:(NSString *)merchantPin withCompletion:(DictionaryWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"gifts/%@/redeem", giftCard[@"id"]];
    
    [[APIClient sharedInstance] POST:path parameters:@{ @"pin": merchantPin } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            completion(nil, error);
            
        } else  if (operation.response.statusCode == 422) {
            NSError *expiredError = [NSError errorWithDomain:@"Fuzzie"
                                                      code:422
                                                  userInfo:@{ NSLocalizedDescriptionKey: @"Sorry! The gift you're trying to redeem has already expired." }];
            completion(nil,expiredError);
        } else {
            if (operation.response.statusCode == 401 || operation.response.statusCode == 410) {
                
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

+ (void)markAsOpenedForGiftCard:(NSDictionary *)giftCard withCompletion:(DictionaryWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"/api/v2/gifts/%@/mark_as_opened", giftCard[@"id"]];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
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

+ (void)markAsRedeemedForGiftCard:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"api/v2/gifts/%@/mark_as_used", giftId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
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

+ (void)markAsOpenedReceivedGift:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/gifts/%@/mark_received_gift_as_opened", giftId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else {
                completion(nil, error);
            }
            
        }
        
    }];
}

+ (void)markAsUnredeemedOnlineGift:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/gifts/%@/mark_as_unredeemed", giftId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else {
                completion(nil, error);
            }
            
        }
        
    }];
}

+ (void)markAsDelivered:(NSString *)giftId withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/gifts/%@/mark_as_delivered", giftId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject ,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            } else {
                completion(nil, error);
            }
            
        }
        
    }];
}

+ (void)addGiftedGift:(NSString *)giftId withCompletion:(ErrorBlock)completion{
    NSString *path = [NSString stringWithFormat:@"api/gifts/%@/add_to_gift_box", giftId];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
                
            } else if(operation.response.statusCode == 401 || operation.response.statusCode == 403){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"message"];
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:operation.response.statusCode
                                                 userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(error);
            } else {
                completion(error);
            }
            
        }

    }];
}

+ (void)activateGiftCardWithCode:(NSString *)code force:(BOOL) force withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)errorBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/codes/%@/redeem", code];
    
    NSDictionary *params;
    if (force) {
    
        params = @{@"force":@(TRUE)};
    }
    
    [[APIClient sharedInstance] POST:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"operation.responseObject: %@", operation.responseObject);
        NSLog(@"Activate Error: %@", error);
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!errorBlock) return;
        
        if (operation.response.statusCode == 404 || operation.response.statusCode == 410
            || operation.response.statusCode == 409 || operation.response.statusCode == 415
            || operation.response.statusCode == 418) {
            
            NSError* error1;
            NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                     options:kNilOptions
                                                                       error:&error1];
            NSString *message = [response objectForKey:@"message"];
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                        code:operation.response.statusCode
                                                    userInfo:@{ NSLocalizedDescriptionKey: message }];
            errorBlock(error);
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            errorBlock(error);
            
        } else {
            errorBlock(error);
        }
     
    }];
    
}

+ (void)redeemPowerUpGiftCard:(NSString *)giftId withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)errorBlock{
    
    NSString *path = [NSString stringWithFormat:@"api/power_up_code_gifts/%@/redeem", giftId];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"operation.responseObject: %@", operation.responseObject);
        NSLog(@"Activate Error: %@", error);
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!errorBlock) return;
        
        if (operation.response.statusCode == 404 || operation.response.statusCode == 410
            || operation.response.statusCode == 409) {
            
            NSError* error1;
            NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                     options:kNilOptions
                                                                       error:&error1];
            NSString *message = [response objectForKey:@"message"];
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:operation.response.statusCode
                                             userInfo:@{ NSLocalizedDescriptionKey: message }];
            errorBlock(error);
            
        } else if (operation.response.statusCode == 417) {
            
            NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                 code:417
                                             userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
            errorBlock(error);
            
        } else {
            errorBlock(error);
        }
        
    }];
    
}

+(void)getActiveGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/my_gifts/active?start=%d&offset=%d", start, offest];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (refresh) {
            
            [FZData sharedInstance].activeGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
            
        } else {
            
            if ([FZData sharedInstance].activeGiftBox) {
                
                [[FZData sharedInstance].activeGiftBox addObjectsFromArray:[[NSMutableArray alloc] initWithArray:responseObject]];
                
            } else{
                
                [FZData sharedInstance].activeGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
                
            }
        }

        if (completion) {
            completion(responseObject, nil);
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

+(void)getUsedGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/my_gifts/used?start=%d&offset=%d", start, offest];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (refresh) {
            
            [FZData sharedInstance].usedGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
            
        } else {
            
            if ([FZData sharedInstance].usedGiftBox) {
                
                [[FZData sharedInstance].usedGiftBox addObjectsFromArray:[[NSMutableArray alloc] initWithArray:responseObject]];
                
            } else{
                
                [FZData sharedInstance].usedGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
                
            }
        }
          
        if (completion) {
            completion(responseObject, nil);
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

+(void)getSentGiftBox:(int)start withOffset:(int)offest withRefresh:(BOOL)refresh with:(ArrayWithErrorBlock) completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v2/my_gifts/sent?start=%d&offset=%d", start, offest];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (refresh) {
            
            [FZData sharedInstance].sentGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
            
        } else {
            
            if ([FZData sharedInstance].sentGiftBox) {
                
                [[FZData sharedInstance].sentGiftBox addObjectsFromArray:[[NSMutableArray alloc] initWithArray:responseObject]];
                
            } else{
                
                [FZData sharedInstance].sentGiftBox = [[NSMutableArray alloc] initWithArray:responseObject];
                
            }
        }
        
        if (completion) {
            completion(responseObject, nil);
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

+ (void)updageGiftInfoWithGiftId:(NSString*)giftId andName:(NSString *)name andMessage:(NSString *)message withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/gifts/%@", giftId];
    
    NSDictionary *params = @{
                             @"friend_name": name,
                             @"message": message
                             };
    
    [[APIClient sharedInstance] PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) completion(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(nil, error);
                
            }  else {
                completion(nil, error);
            }
            
        }
        
    }];
}

+ (void)sendGiftViaEmailWithGiftId:(NSString *)giftId andReceiverEmail:(NSString *)email andCopy:(BOOL)copy withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/gifts/%@/notify", giftId];
    
    [[APIClient sharedInstance] POST:path parameters:@{ @"email": email , @"copy_to_self":@(copy)} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (!completion) return;
        
        completion(nil, error);
    }];

}

+ (void)resetUnopenedGiftsCount:(DictionaryWithErrorBlock)completion{
    
    [[APIClient sharedInstance] POST:@"api/new_items/reset_gifts" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
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

+ (void)resetUnopenedTicketsCount:(DictionaryWithErrorBlock)completion{
    
    [[APIClient sharedInstance] POST:@"api/new_items/reset_tickets" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
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
@end
