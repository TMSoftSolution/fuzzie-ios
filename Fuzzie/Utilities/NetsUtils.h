//
//  NetsUtils.h
//  Fuzzie
//
//  Created by joma on 6/4/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetsUtils : NSObject

+ (instancetype)sharedInstance;

- (NSString*) netsError:(NSString*)responseCode;
- (NSDictionary*) netsPaymentMethod;
- (NSString *) getTxnRequestWithMID :(NSString *) mid paymentAmount:(NSNumber*)paymentAmount paymentRef:(NSString *)paymentRef;

@end
