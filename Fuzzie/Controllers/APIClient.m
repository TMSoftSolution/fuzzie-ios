//
//  APIClient.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation APIClient

+ (instancetype)sharedInstance {
    static APIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[APIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:API_BASE_URL]];
    });
    
    return __sharedInstance;
}

+ (instancetype)sharedInstanceForJackpotLive{
    static APIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[APIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:API_JACKPOT_LIVE_DRAW_HOST_URL]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    break;
            }
        }];
        
        [self.reachabilityManager startMonitoring];
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-Platform"];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"X-App-Version"];

        self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
        
        [self.requestSerializer setTimeoutInterval:120];
    }
    
    return self;
}

- (void)setAccessToken:(NSString *)accessToken {
    
    _accessToken = accessToken;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if (accessToken) {
        [self.requestSerializer setValue:self.accessToken forHTTPHeaderField:@"X-Fuzzie-Token"];
        sessionConfiguration.HTTPAdditionalHeaders = @{ @"X-Fuzzie-Token": self.accessToken };
    } else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"X-Fuzzie-Token"];
    }
}

- (void)setFacebookToken:(NSString *)facebookToken{
    [self.requestSerializer setValue:facebookToken forHTTPHeaderField:@"X-Facebook-Token"];
}

- (void)setLocation:(CLLocation*)location{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if (location) {
        [self.requestSerializer setValue:[[NSNumber numberWithDouble:location.coordinate.latitude] stringValue] forHTTPHeaderField:@"X-Latitude"];
        sessionConfiguration.HTTPAdditionalHeaders = @{ @"X-Latitude": [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue] };
        [self.requestSerializer setValue:[[NSNumber numberWithDouble:location.coordinate.longitude] stringValue] forHTTPHeaderField:@"X-Longitude"];
        sessionConfiguration.HTTPAdditionalHeaders = @{ @"X-Longitude": [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue] };
    } else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"X-Latitude"];
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"X-Longitude"];
    }
}

@end
