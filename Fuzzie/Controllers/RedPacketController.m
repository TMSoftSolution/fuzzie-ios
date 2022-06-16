//
//  RedPacketController.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketController.h"

@implementation RedPacketController

+ (instancetype)sharedInstance {
    static RedPacketController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[RedPacketController alloc] init];
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

+ (void)makeRedPacketsBundle:(NSString *)message numberOfRedPackets:(int)number splitType:(NSString *)spliteType value:(CGFloat)value ticketCount:(NSNumber*)ticketCount promoCode:(NSString *)promoCode completion:(DictionaryWithErrorBlock)completion{
    
    NSMutableDictionary *params = [@{
                                     @"message": message,
                                     @"number_of_red_packets": @(number),
                                     @"split_type": spliteType,
                                     @"value":@(value)} mutableCopy];
    if (ticketCount) {
        [params setObject:ticketCount forKey:@"number_of_jackpot_tickets"];
    }
    
    if (promoCode) {
        [params setObject:promoCode forKey:@"promo_code"];
    }
    
    [[APIClient sharedInstance] POST:@"api/red_packet_bundles" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
                
            } else if (operation.response.statusCode == 415) {
                
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

+ (void)confirmReceivedRedPacket:(NSString*)redPacketId completion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/red_packet_bundles/%@/use", redPacketId];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
                
            } else if(operation.response.statusCode == 404 || operation.response.statusCode == 411 || operation.response.statusCode == 412){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                if (message) {
                    NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                         code:operation.response.statusCode
                                                     userInfo:@{ NSLocalizedDescriptionKey: message }];
                    completion(nil, error);
                } else {
                    completion(nil, error1);
                }
                
            } else {
                completion(nil, error);
            }
            
        }
    }];
}

+ (void)openReceivedRedPacket:(NSString *)redPacketId completion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/red_packets/%@/open", redPacketId];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
                
            } else if(operation.response.statusCode == 411){
                
                NSError* error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"error"];
                
                if (message) {
                    NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                         code:operation.response.statusCode
                                                     userInfo:@{ NSLocalizedDescriptionKey: message }];
                    completion(nil, error);
                } else {
                    completion(nil, error1);
                }
                
            } else {
                completion(nil, error);
            }
            
        }
    }];
}

+ (void)getSentRedPacketBundles:(ArrayWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"api/red_packet_bundles" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [FZData sharedInstance].sentRedPacketBundles = [[NSMutableArray alloc] initWithArray:responseObject];
        
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

+ (void)getReceivedRedPackets:(ArrayWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"api/red_packets" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        [FZData sharedInstance].receivedRedPackets = [[NSMutableArray alloc] initWithArray:responseObject];
        
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

+ (void)getLearnMore:(ArrayWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"api/red_packets/learn_more" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
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

+ (void)getAssignedRedPackets:(NSString *)bundleId completion:(ArrayWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/red_packet_bundles/%@/assigned_red_packets", bundleId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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

+ (void)sendRedPacketViaEmail:(NSString *)redPacketBundleId email:(NSString *)email copy:(BOOL)copy completion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/red_packet_bundles/%@/send_by_email", redPacketBundleId];
    
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

+ (void)getRedPacketBundle:(NSString *)bundleId completion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/red_packet_bundles/%@", bundleId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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

@end
