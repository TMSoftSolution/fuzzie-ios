//
//  UserController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "UserController.h"

@implementation UserController

+ (instancetype)sharedInstance {
    static UserController *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[UserController alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentUser = (FZUser *)[[NSUserDefaults standardUserDefaults] rm_customObjectForKey:CURRENT_USER_KEY];
        self.facebookFriends = [[NSArray alloc] init];
    }
    return self;
}

+ (void)setUser:(FZUser *)user{
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
    [UserController sharedInstance].currentUser = user;
}

+ (void)decreaseActiveGiftCount:(int)offset{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    [user setActiveGiftCount:[NSNumber numberWithInt:([user.activeGiftCount intValue] - offset)]];
    [UserController setUser:user];
    
}

+ (void)increaseActiveGiftCount:(int)offset{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    [user setActiveGiftCount:[NSNumber numberWithInt:([user.activeGiftCount intValue] + offset)]];
    [UserController setUser:user];
}

+ (void)setUnopenedActiveGiftCountWithOffset:(int)offset{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    [user setUnOpenedActiveGiftCount:[NSNumber numberWithInt:([user.unOpenedActiveGiftCount intValue] + offset)]];
    [UserController setUser:user];
}

+ (void)resetUnopenedGiftCount{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    [user setUnOpenedActiveGiftCount:[NSNumber numberWithInt:0]];
    [UserController setUser:user];
}

+ (void)resetUnopenedTicketCount{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    [user setUnOpenedTicketCount:[NSNumber numberWithInt:0]];
    [UserController setUser:user];
}

+ (void)likeBrandWithId:(NSString *)brandId isLike:(BOOL)isLike{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    NSMutableArray *brandIds = [[NSMutableArray alloc] initWithArray:user.likedListIds];
    
    if (isLike) {
        
        [brandIds addObject:brandId];
        
    } else {
        
        [brandIds removeObject:brandId];
        
    }
    
    user.likedListIds = brandIds;
    [UserController setUser:user];
}

+ (void)wishListBrandWithId:(NSString *)brandId isWish:(BOOL)isWish{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    NSMutableArray *brandIds = [[NSMutableArray alloc] initWithArray:user.wishListIds];
    
    if (isWish) {
        
        [brandIds addObject:brandId];
        
    } else {
        
        [brandIds removeObject:brandId];
        
    }
    
    user.wishListIds = brandIds;
    [UserController setUser:user];
}

+ (void)bookmarkStoreWithId:(NSString *)storeId bookmark:(BOOL)bookmark{
    
    FZUser *user = [UserController sharedInstance].currentUser;
    NSMutableArray *storeIds = [[NSMutableArray alloc] initWithArray:user.bookmarkedStoreIds];
    
    if (bookmark) {
        
        [storeIds insertObject:storeId atIndex:0];
        
    } else {
        
        [storeIds removeObject:storeId];
        
    }
    
    user.bookmarkedStoreIds = storeIds;
    [UserController setUser:user];
}

+ (void)signupUserViaEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName birthday:(NSString *)birthday phoneNumber:(NSString *)phoneNumber profileImage:(UIImage *)image gender:(NSString *)gender referralCode:(NSString*)referralCode withSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)failureBlock; {
    
    if (!firstName || !lastName || !phoneNumber || !email || !password) return;
    
    NSMutableDictionary *params = [@{ @"first_name": firstName,
                              @"last_name": lastName,
                              @"email": email,
                              @"password": password,
                              @"password_confirmation": password,
                              @"phone":  phoneNumber } mutableCopy];
    
    if (gender) {
        [params setObject:gender forKey:@"gender"];
    }
    
    if (birthday) {
        [params setObject:birthday forKey:@"birthdate"];
    }
    
    if (referralCode) {
        [params setObject:referralCode forKey:@"referred_by_code"];
    }
    
    [[APIClient sharedInstance] POST:@"user/email_register" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            [formData appendPartWithFileData:imageData
                                        name:@"profile_picture"
                                    fileName:@"image.jpg"
                                    mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            [APIClient sharedInstance].accessToken = token;
            if (successBlock) successBlock(userDict);
        } else {
            if (failureBlock) failureBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        NSLog(@"Sign Up error: %@", error);
        if (failureBlock) {
            if (operation.response.statusCode == 406 || operation.response.statusCode == 422 || operation.response.statusCode == 402 || operation.response.statusCode == 403 || operation.response.statusCode == 405) {
                NSError *error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"message"];
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:operation.response.statusCode
                                                      userInfo:@{ NSLocalizedDescriptionKey: message}];
                failureBlock(loginError);
            } else {
                failureBlock(error);
            }
        }
        
    }];
    
}

+ (void)activateAccountWithOTP:(NSString *)OTP withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock {
    
    if (!OTP) return;
    
    NSString *path = [NSString stringWithFormat:@"api/phone/%@/verify", OTP];
    [[APIClient sharedInstance] POST:path parameters:@{@"mobile":@(true)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        if (userDict) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = userDict[@"fuzzie_token"];
            [[NSUserDefaults standardUserDefaults] setObject:userDict[@"fuzzie_token"] forKey:ACCESS_TOKEN_KEY];
            
            if (successBlock) successBlock(user);
        } else {
            if (failureBlock) failureBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (failureBlock) {
            if (operation.response.statusCode == 404){
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:404
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"Invalid Code." }];
                failureBlock(error);
            } else {
                failureBlock(error);

            }
        }
    }];
    
}

+ (void)resentOTPWithSuccess:(DictionaryBlock)successBlock failure:(ErrorBlock)failureBlock {
    
    [[APIClient sharedInstance] POST:@"api/phone/resend_otp" parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)checkReferralCodeValidation:(NSString *)code completion:(DictionaryWithErrorBlock)completion{
    
    NSDictionary *params = @{ @"code": code};
    
    [[APIClient sharedInstance] POST:@"api/users/validate_referral_code" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (completion){
            completion(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            
            if (operation.response.statusCode == 402 || operation.response.statusCode == 403 || operation.response.statusCode == 405) {
                NSError *error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"message"];
                NSError *err = [NSError errorWithDomain:@"Fuzzie"
                                                          code:operation.response.statusCode
                                                      userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil, err);
                
            } else {
                
                completion(nil, error);
            }
        }
        
    }];
}

+ (void)checkPhoneRegistered:(NSString *)phone withCompletion:(ErrorBlock)completion{
    
    NSDictionary *params = @{ @"phone": phone};
    
    [[APIClient sharedInstance] POST:@"user/phone_login_send_otp" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (completion) completion(nil);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(error);
                
            } else if (operation.response.statusCode == 404){
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:404
                                                 userInfo:nil];
                completion(error);
                
            } else {
                completion(error);
            }
        }
        
    }];
    
}

+ (void)loginUserViaPhone:(NSString *)phone otp:(NSString *)otp withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock {
    
    if (!phone || !otp) return;
    
    NSDictionary *params = @{ @"phone": phone,
                              @"otp": otp };
    
    [[APIClient sharedInstance] POST:@"user/phone_login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        if (userDict) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = userDict[@"fuzzie_token"];
            [[NSUserDefaults standardUserDefaults] setObject:userDict[@"fuzzie_token"] forKey:ACCESS_TOKEN_KEY];
            
            if (successBlock) successBlock(user);
        } else {
            if (failureBlock) failureBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (failureBlock) {
            
            if (operation.response.statusCode == 401) {
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:401
                                                      userInfo:@{ NSLocalizedDescriptionKey: @"Invalid Code." }];
                failureBlock(loginError);
            } else if (operation.response.statusCode == 417) {
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:417
                                                      userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                failureBlock(loginError);
            } else if (operation.response.statusCode == 406) {
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:406
                                                      userInfo:@{ NSLocalizedDescriptionKey: @"This account is linked to Facebook. Please login by Facebook." }];
                failureBlock(loginError);
            } else {
                failureBlock(error);
            }
            
        }
    }];
    
}

+ (void)loginUserWithFacebookToken:(NSString *)facebookToken withSuccess:(UserBlock)successBlock failure:(ErrorBlock)failureBlock {
    
    [[[APIClient sharedInstance] requestSerializer] setValue:[FBSDKAccessToken currentAccessToken].tokenString forHTTPHeaderField:@"X-Facebook-Token"];
    
    [[APIClient sharedInstance] POST:@"user" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (successBlock) successBlock(user);
        } else if (responseObject[@"email"]) {
            FZUser *incompleteUser = [FZUser new];
            incompleteUser.email = responseObject[@"email"];
            incompleteUser.firstName = responseObject[@"first_name"];
            incompleteUser.lastName = responseObject[@"last_name"];
            if (responseObject[@"gender"]) {
                incompleteUser.gender = [responseObject[@"gender"] substringToIndex:1];
            }
            if (responseObject[@"birthday"]) {
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                
                NSDate *birthDate = [dateFormatter dateFromString:responseObject[@"birthday"]];
                
                NSDateFormatter *birthDateFormatter = [NSDateFormatter new];
                [birthDateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                incompleteUser.birthday = [birthDateFormatter stringFromDate:birthDate];
                
            }
            if (successBlock) successBlock(incompleteUser);
        } else {
            if (failureBlock) failureBlock(nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)signUpNewFacebookUser:(NSDictionary *)userDetails andProfileImage:(UIImage *)image withCompletion:(UserWithErrorBlock)completion {
    
    [[APIClient sharedInstance] POST:@"user/facebook_register" parameters:userDetails constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            [formData appendPartWithFileData:imageData
                                        name:@"profile_picture"
                                    fileName:@"image.jpg"
                                    mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
     
        if (completion) {
            
            if (operation.response.statusCode == 422 || operation.response.statusCode == 406 || operation.response.statusCode == 402 || operation.response.statusCode == 403 || operation.response.statusCode == 405) {
                NSError *error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"message"];
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:operation.response.statusCode
                                                      userInfo:@{ NSLocalizedDescriptionKey: message }];
                completion(nil, loginError);
            } else {
                completion(nil, error);
            }
        }
    }];
    
}

+ (void)getUserProfileWithCompletion:(UserWithErrorBlock)completion {
    
    [[APIClient sharedInstance] GET:@"user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];

            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_REFRESH_USER object:nil];
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
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

+ (void)updateUserProfile:(NSDictionary *)userDetails withCompletion:(UserWithErrorBlock)completion {
    
    [[APIClient sharedInstance] PUT:@"user" parameters:userDetails success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];

            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_REFRESH_USER object:nil];
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
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

+ (void)updateProfileImageWithImage:(UIImage *)image withCompletion:(UserWithErrorBlock)completion {
    
    [[APIClient sharedInstance] POST:@"user/profile_picture" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            [formData appendPartWithFileData:imageData
                                        name:@"profile_picture"
                                    fileName:@"image.jpg"
                                    mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
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

+ (void)updatePasswordWithCurrentPassword:(NSString*)currentPassword andNewPassword:(NSString *)password withCompletion:(ErrorBlock)completion {
    
    NSDictionary *params = @{
                             @"current_password": currentPassword,
                             @"new_password": password
                             };
    
    [[APIClient sharedInstance] PUT:@"api/accounts/update_password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) completion(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(error);
                
            } else if (operation.response.statusCode == 401 || operation.response.statusCode == 406) {
                NSError *error1;
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

+ (void)requestUpdatePhoneNumber:(NSString *)phoneNumber withCompletion:(ErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"/api/phone/%@/update", phoneNumber];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (completion) completion(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 417) {
                
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:417
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                completion(error);
                
            } else if (operation.response.statusCode == 404){
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                     code:404
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"Invalid Code." }];
                completion(error);
            } else {
                completion(error);
            }


        }
    }];
    
}

+ (void)verifyNewPhoneNumberWithOTP:(NSString *)OTP withCompletion:(UserWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"/api/phone/%@/verify_new_number", OTP];
    
    [[APIClient sharedInstance] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 404) {
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                          code:404
                                                      userInfo:@{ NSLocalizedDescriptionKey: @"Invalid Code." }];
                completion(nil, error);
            } else {
                completion(nil, error);

            }
        }
    }];
}

+ (void)resetPasswordWithEmail:(NSString *)email withCompletion:(ErrorBlock)completion {
    
    if (!email) return;
    
    NSDictionary *params = @{ @"email_or_phone": email };
    
    [[APIClient sharedInstance] POST:@"password/forgot" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (completion) completion(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 404) {
                NSError *loginError = [NSError errorWithDomain:@"Fuzzie"
                                                          code:404
                                                      userInfo:@{ NSLocalizedDescriptionKey: @"There’s no Fuzzie account linked to this email address." }];
                completion(loginError);
            } else {
                if (operation.response.statusCode == 417) {
                    
                    NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                         code:417
                                                     userInfo:@{ NSLocalizedDescriptionKey: @"You are unauthorised." }];
                    completion(error);
                    
                } else {
                    completion(error);
                }

            }
        }
    }];
    
}

+ (void)updateEmail:(NSString *)email withCompletion:(UserWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"/api/accounts/update_email"];
    
    [[APIClient sharedInstance] PUT:path parameters:@{@"email":email} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (operation.response.statusCode == 422 || operation.response.statusCode == 406) {
               
                NSError *error1;
                NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                         options:kNilOptions
                                                                           error:&error1];
                NSString *message = [response objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                          code:operation.response.statusCode
                                                      userInfo:@{ NSLocalizedDescriptionKey: message}];
                completion(nil, error);
            } else {
                completion(nil, error);
                
            }
        }
    }];
}

+ (void)updateFirstName:(NSString *)firstName withCompletion:(UserWithErrorBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/api/accounts/update_first_name"];
    
    [[APIClient sharedInstance] PUT:path parameters:@{@"first_name":firstName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (completion) {
                if (operation.response.statusCode == 406) {
                    
                    NSError *error1;
                    NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                             options:kNilOptions
                                                                               error:&error1];
                    NSString *message = [response objectForKey:@"message"];
                    NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                         code:operation.response.statusCode
                                                     userInfo:@{ NSLocalizedDescriptionKey: message}];
                    completion(nil, error);
                } else {
                    completion(nil, error);
                    
                }
            }
        }
    }];
}

+ (void)updateLastName:(NSString*)lastName withCompletion:(UserWithErrorBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/api/accounts/update_last_name"];
    
    [[APIClient sharedInstance] PUT:path parameters:@{@"last_name":lastName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (completion) {
                if (operation.response.statusCode == 406) {
                    
                    NSError *error1;
                    NSDictionary* response = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                             options:kNilOptions
                                                                               error:&error1];
                    NSString *message = [response objectForKey:@"message"];
                    NSError *error = [NSError errorWithDomain:@"Fuzzie"
                                                         code:operation.response.statusCode
                                                     userInfo:@{ NSLocalizedDescriptionKey: message}];
                    completion(nil, error);
                } else {
                    completion(nil, error);
                    
                }
            }
        }
    }];
}

+ (void)updateGender:(NSString *)gender withCompletion:(UserWithErrorBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/api/accounts/update_gender"];
    
    [[APIClient sharedInstance] PUT:path parameters:@{@"gender":gender} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];
            
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (completion) {
                completion(nil, error);
            }
        }
    }];

}

+ (void)updateBirthdate:(NSString *)birthdate withCompletion:(UserWithErrorBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/api/accounts/update_birthday"];
    
    [[APIClient sharedInstance] PUT:path parameters:@{@"birthdate":birthdate} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];

            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

+ (void)deleteProfileImage:(UserWithErrorBlock)completion{
    [[APIClient sharedInstance] DELETE:@"api/accounts/delete_profile_picture" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        NSDictionary *userDict = responseObject[@"user"];
        NSString *token = userDict[@"fuzzie_token"];
        if (userDict && token) {
            
            NSError *error = nil;
            FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:userDict error:&error];

            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:CURRENT_USER_KEY];
            [UserController sharedInstance].currentUser = user;
            [APIClient sharedInstance].accessToken = token;
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:ACCESS_TOKEN_KEY];
            
            if (completion) completion(user, nil);
            
        } else {
            if (completion) completion(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@",THIS_FILE,THIS_METHOD,error);
        
        if (completion) {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

+ (void)getTransactionsWithCompletion:(DictionaryWithErrorBlock)completion {
    
    [[APIClient sharedInstance] GET:@"orders" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
//        if (responseObject[@"brands"]) {
//            if (completionBlock) {
//                completionBlock(responseObject[@"brands"], nil);
//            }
//        } else {
//            completionBlock(nil, nil);
//        }
        
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


+ (void)getUserLikeBrandWithUserId:(NSString *)userId And:(ArrayWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"api/v2/liked_brands/%@", userId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            
            NSMutableArray *brandArray = [NSMutableArray new];
            
            NSArray *brandIds = responseObject;
            for (NSString *brandId in brandIds) {
                for (FZBrand *brand in [FZData sharedInstance].brandArray) {
                    if ([brand.brandId isEqualToString:brandId]) {
                        [brandArray addObject:brand];
                        break;
                    }
                }
            }
            
            if (completion) {
                completion(brandArray, nil);
            }
        } else {
            completion(nil, nil);
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

+ (void)getUserWishlistBrandWithUserId:(NSString *)userId And:(ArrayWithErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"api/v2/wish_listed_brands/%@", userId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            
            NSMutableArray *brandArray = [NSMutableArray new];
            
            NSArray *brandIds = responseObject;
            for (NSString *brandId in brandIds) {
                for (FZBrand *brand in [FZData sharedInstance].brandArray) {
                    if ([brand.brandId isEqualToString:brandId]) {
                        [brandArray addObject:brand];
                        break;
                    }
                }
            }
            
            if (completion) {
                completion(brandArray, nil);
            }
        } else {
            completion(nil, nil);
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

+ (void)updatePrivacyShareLikeWishlistState:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock {
    
    NSMutableDictionary *params = [@{ @"settings": @{
                                              @"shares_likes_and_wish_list":@(state)
                                              }} mutableCopy];
    
    [[APIClient sharedInstance] POST:@"/api/user_settings" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,@"ok");
        
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

+ (void)setDisplayGiftingPage:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock{
    NSMutableDictionary *params = [@{ @"settings": @{
                                              @"display_gifting_page":@(state)
                                              }} mutableCopy];
    
    [[APIClient sharedInstance] POST:@"/api/user_settings" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,@"ok");
        completionBlock(nil);
        
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

+ (void)setCoachMarkerDisplay:(BOOL)state withErrorBlock:(ErrorBlock)completionBlock{
    NSMutableDictionary *params = [@{ @"settings": @{
                                              @"show_fuzzie_club_instructions":@(state)
                                              }} mutableCopy];
    
    [[APIClient sharedInstance] POST:@"/api/user_settings" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,@"ok");
        completionBlock(nil);
        
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

+ (void)getFriendReferral:(DictionaryWithErrorBlock)completion{
    [[APIClient sharedInstance] GET:@"/api/referrals" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = responseObject;
            if (completion) {
                completion(dict, nil);
            }
        } else{
            completion(nil, nil);
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

+ (void)getFriendReferralUsers:(ArrayWithErrorBlock)completion{
    [[APIClient sharedInstance] GET:@"/api/referrals/users" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
            completion(userArray, nil);
        } else {
            
            completion(nil, nil);
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

+ (void)getMyFuzzieFriends:(ArrayWithErrorBlock)completion{
    [[APIClient sharedInstance] GET:@"/api/friends/fuzzie" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
            completion(userArray, nil);
        } else {
            completion(nil, nil);
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

+ (void)getFacebookLinkedFuzzieUsers:(ArrayWithErrorBlock)completion{
    [[APIClient sharedInstance] POST:@"/api/accounts/link" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
            completion(userArray, nil);
        } else {
            completion(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
        if (completion) {
            completion(nil,error);
            
        }
    }];
}

+ (void)getFacebookFriends:(ArrayWithErrorBlock)completion{
    [[APIClient sharedInstance] GET:@"/api/friends/facebook" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *friendsArray = [NSMutableArray new];
            NSArray *sortedArray = [[NSArray alloc] init];
            
            for (NSDictionary *userDict in responseObject) {
                NSError *error = nil;
                FZFacebookFriend *friend = [MTLJSONAdapter modelOfClass:FZFacebookFriend.class fromJSONDictionary:userDict error:&error];
                
                if (error) {
                    DDLogError(@"FZUser Error: %@", [error localizedDescription]);
                } else if (friend) {
                    [friendsArray addObject:friend];
                }
            }
            
            
            NSSortDescriptor* sortOrderByName = [NSSortDescriptor sortDescriptorWithKey: @"self.name" ascending: YES];
            sortedArray = [friendsArray sortedArrayUsingDescriptors:
                           @[sortOrderByName]];
            completion(sortedArray, nil);
            
            [UserController sharedInstance].facebookFriends = sortedArray;
            completion(responseObject, nil);
            
        } else {
            completion(nil, nil);
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

+ (void)getFacebookFriendsConnected:(ArrayWithErrorBlock)completion{
    [[APIClient sharedInstance] POST:@"/api/accounts/connect" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *friendsArray = [NSMutableArray new];
            NSArray *sortedArray = [[NSArray alloc] init];
            
            for (NSDictionary *userDict in responseObject) {
                NSError *error = nil;
                FZFacebookFriend *friend = [MTLJSONAdapter modelOfClass:FZFacebookFriend.class fromJSONDictionary:userDict error:&error];
                
                if (error) {
                    DDLogError(@"FZUser Error: %@", [error localizedDescription]);
                } else if (friend) {
                    [friendsArray addObject:friend];
                }
            }
            
            
            NSSortDescriptor* sortOrderByName = [NSSortDescriptor sortDescriptorWithKey: @"self.name" ascending: YES];
            sortedArray = [friendsArray sortedArrayUsingDescriptors:
                                  @[sortOrderByName]];
            completion(sortedArray, nil);
            
            [UserController sharedInstance].facebookFriends = sortedArray;
            completion(responseObject, nil);
        } else {
            completion(nil, nil);
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

+ (void)getUserInfoWithId:(NSString *)userId withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"api/accounts/%@/info", userId];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (responseObject) {
            completion(responseObject, nil);
        } else {
            completion(nil, nil);
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

+ (void)saveToken:(NSString *)token withCompletion:(ErrorBlock)completion{
    [[APIClient sharedInstance] POST:@"api/device_tokens" parameters:@{@"device_token":token} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        if (responseObject) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error);
    }];
}

+ (void)getOrdersWithPage:(int)page andLimit:(int)limit withCompletion:(ArrayWithErrorBlock) completion{
    
    NSString *path = [NSString stringWithFormat:@"api/v3/orders?page=%d&limit=%d", page, limit];

    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            completion(responseObject, nil);
        } else {
            completion(nil, nil);
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

+ (void)callRatePush:(ErrorBlock)completion{
    
    [[APIClient sharedInstance] POST:@"/api/users/share_code" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error);
    }];
}

+ (void)sendRateNotificationAfterDay:(ErrorBlock)completion{
    [[APIClient sharedInstance] POST:@"/api/rate_app/may_be_later" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
    }];
}

+ (void)dontSendRateNotification{
    [[APIClient sharedInstance] POST:@"/api/rate_app/i_will_rate" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        DDLogError(@"%@: %@, Error: %@, %@",THIS_FILE,THIS_METHOD,error,operation.responseObject);
        
    }];
}

+ (void)setJackpotLiveDrawNotification:(BOOL)state withErrorBlock:(ErrorBlock)completion{
        
    NSMutableDictionary *params = [@{ @"settings": @{
                                              @"jackpot_draw_notification":@(state)
                                              }} mutableCopy];
    
    [[APIClient sharedInstance] POST:@"/api/user_settings" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,@"ok");
        completion(nil);
        
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

+ (void)getClubReferral:(DictionaryWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"/api/fuzzie_club/referrals" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = responseObject;
            if (completion) {
                completion(dict, nil);
            }
        } else{
            completion(nil, nil);
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

+ (void)getClubReferralUsers:(ArrayWithErrorBlock)completion{
    
    [[APIClient sharedInstance] GET:@"/api/fuzzie_club/referrals/users" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
            completion(userArray, nil);
        } else {
            
            completion(nil, nil);
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

+ (void)locationVerify:(NSString *)storeId withCompletion:(DictionaryWithErrorBlock)completion{
    
    NSString *path = [NSString stringWithFormat:@"/api/stores/check_nearest?store_id=%@", storeId];
    
    [[APIClient sharedInstance] setLocation:[FZData sharedInstance].currentLocation];
    
    [[APIClient sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,responseObject);
        
        if (completion) {
            completion(responseObject, nil);
        } else{
            completion(nil, nil);
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
