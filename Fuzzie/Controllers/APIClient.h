//
//  APIClient.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface APIClient : AFHTTPRequestOperationManager

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *facebookToken;
@property (strong, nonatomic) CLLocation *location;

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceForJackpotLive;

@end
