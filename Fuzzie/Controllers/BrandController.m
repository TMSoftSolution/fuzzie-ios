//
//  BrandController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandController.h"

@implementation BrandController

+ (instancetype)sharedInstance {
    static BrandController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[BrandController alloc] init];
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

+ (void)getHomeWithRefresh:(BOOL)refresh withSuccess:(DictionaryWithErrorBlock)completionBlock {
    
    NSDictionary *params = nil;
    
    if (refresh) {
        params = @{ @"refresh": @YES };
    }
    
    NSString *url = @"/api/v9/home";
    [[APIClient sharedInstance] GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:HOME_DATA_REFRESHED object:nil];
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

+ (void)addBrandToWishList:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/wish_list/%@", brandId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(error);
                
            } else {
                completionBlock(error);
            }

        }
        
    }];
}


+ (void)removeBrandFromWishList:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/wish_list/%@", brandId];
    
    [[APIClient sharedInstance] DELETE:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(error);
                
            } else {
                completionBlock(error);
            }

        }
        
    }];
}

+ (void)addLikeToBrand:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/liked_list/%@", brandId];
    
    [[APIClient sharedInstance] PUT:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(error);
                
            } else {
                completionBlock(error);
            }

        }
        
    }];
}

+ (void)removeLikeToBrand:(NSString *)brandId withCompletion:(ErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/liked_list/%@", brandId];
    
    [[APIClient sharedInstance] DELETE:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completionBlock) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completionBlock(error);
                
            } else {
                completionBlock(error);
            }

        }
        
    }];
}

+ (void)getTripAdvisorInfo:(NSString *)brandId withSuccess:(DictionaryWithErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"/api/brands/%@/tripadvisor", brandId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
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

+ (void)getLikes:(NSString *)brandId withSuccess:(ArrayWithErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/brands/%@/likers", brandId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *userArray = [NSMutableArray new];
            for (NSDictionary *userDict in responseObject) {
                NSError *error = nil;
                FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
                int i = rand()%7+1;
                user.bearAvatar = [NSString stringWithFormat:@"avatar-bear-%i", i];
                
                if (error) {
                    DDLogError(@"FZUser Error: %@", [error localizedDescription]);
                } else if (user) {
                    [userArray addObject:user];
                }
            }
            completionBlock(userArray, nil);
        } else {
            completionBlock(nil, nil);
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

+ (void)getOthersAlsoBoughtId:(NSString *)brandId withSuccess:(ArrayWithErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"api/brands/%@/others_also_bought", brandId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            completionBlock(responseObject, nil);
        } else {
            completionBlock(nil, nil);
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


+ (void)getBrand:(NSString *)brandId withSuccess:(BrandWithErrorBlock)completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"brands/%@", brandId];

    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error = nil;
            FZBrand *brand = [MTLJSONAdapter modelOfClass:FZBrand.class fromJSONDictionary:responseObject error:&error];
            completionBlock(brand, error);
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

+ (void)getRedeemInstructionsForBrandId:(NSString *)brandId withCompletion:(ArrayWithErrorBlock)completionBlock {
    
    if (!brandId) return;
    
    NSString *path = [NSString stringWithFormat:@"api/redeem_details/%@", brandId];
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            if (responseObject) {
                completionBlock(responseObject, nil);
            } else {
                completionBlock(nil, nil);
            }
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

+ (void)getRedeemInstructionForPowerUp:(ArrayWithErrorBlock)completionBlock{
    
    NSString *path = [NSString stringWithFormat:@"api/redeem_details/power_up_code"];
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completionBlock) {
            if (responseObject) {
                completionBlock(responseObject, nil);
            } else {
                completionBlock(nil, nil);
            }
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

+ (void)saveBrandView:(NSString *)brandId{
    NSString *path = [NSString stringWithFormat:@"api/brands/%@/view", brandId];
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);

        
    }];
}

@end
