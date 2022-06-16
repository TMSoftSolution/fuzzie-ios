//
//  NetsUtils.m
//  Fuzzie
//
//  Created by joma on 6/4/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "NetsUtils.h"

@implementation NetsUtils


+ (instancetype)sharedInstance {
    static NetsUtils *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[NetsUtils alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (NSString *)netsError:(NSString *)responseCode{
    
    NSString *errorMessage = @"";
    NSString *errorCode = @"";
    
    NSArray *splites = [responseCode componentsSeparatedByString:@"-"];
    if (splites.count == 2) {
        errorCode = [splites objectAtIndex:1];
    }
    
    if ([errorCode isEqualToString:@""]) {
        errorMessage = [NSString stringWithFormat:@"Unknown Error - %@", responseCode];
    } else if ([errorCode isEqualToString:@"01000"]){
        errorMessage = @"Payment declined. Please contact card issuer.";
    } else if ([errorCode isEqualToString:@"01001"]){
        errorMessage = @"Payment declined. Please try again.";
    } else if ([errorCode isEqualToString:@"01003"]){
        errorMessage = @"Payment declined. Please contact card issuer.";
    } else if ([errorCode isEqualToString:@"01004"] || [errorCode isEqualToString:@"01005"] || [errorCode isEqualToString:@"01006"] || [errorCode isEqualToString:@"01007"]){
        errorMessage = @"Payment declined. Invalid amount.";
    } else if ([errorCode isEqualToString:@"01010"]){
        errorMessage = @"Payment declined. Exceeded activity/pin-retry Limit.";
    } else if ([errorCode isEqualToString:@"01011"]){
        errorMessage = @"Payment declined. Exceeded Account Limit.";
    } else if ([errorCode isEqualToString:@"01098"] || [errorCode isEqualToString:@"01099"] || [errorCode isEqualToString:@"01100"]){
        errorMessage = @"Payment declined. Please contact card issuer.";
    } else if ([errorCode isEqualToString:@"01101"]){
        errorMessage = @"Payment declined. Invalid Credit Card Number.";
    } else if ([errorCode isEqualToString:@"01102"]){
        errorMessage = @"Payment declined. Expired Card.";
    } else if ([errorCode isEqualToString:@"01103"]){
        errorMessage = @"Payment declined. Invalid CVV.";
    } else if ([errorCode isEqualToString:@"01105"]){
        errorMessage = @"Payment declined. Invalid Data.";
    } else if ([errorCode isEqualToString:@"01200"] || [errorCode isEqualToString:@"01201"] || [errorCode isEqualToString:@"01202"] || [errorCode isEqualToString:@"01203"] || [errorCode isEqualToString:@"01204"] || [errorCode isEqualToString:@"01301"] || [errorCode isEqualToString:@"01302"]){
        errorMessage = @"Payment declined. Invalid Credit Card Number.";
    } else if ([errorCode isEqualToString:@"02000"]){
        errorMessage = @"Payment declined. Please contact Merchant.";
    } else if ([errorCode isEqualToString:@"02001"]){
        errorMessage = @"Payment declined. Time Out.";
    } else if ([errorCode isEqualToString:@"02002"]){
        errorMessage = @"Payment declined. User Session Expired.";
    } else if ([errorCode isEqualToString:@"02003"] || [errorCode isEqualToString:@"02010"]){
        errorMessage = @"Payment declined. User cancelled Txn.";
    } else if ([errorCode isEqualToString:@"02200"] || [errorCode isEqualToString:@"02201"]){
        errorMessage = @"Payment declined. Please contact card issuer.";
    }  else if ([errorCode isEqualToString:@"02800"] || [errorCode isEqualToString:@"02801"] || [errorCode isEqualToString:@"02850"] || [errorCode isEqualToString:@"02852"]){
        errorMessage = @"Service unavailable. Please try again later.";
    } else if ([errorCode isEqualToString:@"03117"]){
        errorMessage = @"System Error. Invalid Amount.";
    } else if ([errorCode isEqualToString:@"03118"]){
        errorMessage = @"System Error. Invalid Amount. Below transaction threshold amount.";
    } else if ([errorCode isEqualToString:@"03119"]){
        errorMessage = @"System Error. Invalid Amount. Exceed transaction threshold amount.";
    } else if ([errorCode isEqualToString:@"50104"]){
        errorMessage = @"Payment declined. Transaction cancelled by user.";
    } else if ([errorCode isEqualToString:@"50151"] || [errorCode isEqualToString:@"50152"] || [errorCode isEqualToString:@"69002"]){
        errorMessage = @"Payment declined. Time out, please try again.";
    } else if ([errorCode isEqualToString:@"69072"] || [errorCode isEqualToString:@"69073"] || [errorCode isEqualToString:@"69074"]){
        errorMessage = @"Payment declined. Please try again.";
    } else if ([errorCode isEqualToString:@"69071"]){
        errorMessage = @"Payment declined. Please install NETSPay Application.";
    } else{
        errorMessage = [NSString stringWithFormat:@"System Error. Please contact merchant. - %@", responseCode];
    }
    
    return errorMessage;
}

- (NSDictionary*)netsPaymentMethod{
    
    NSDictionary *dict = @{@"token":@"",
                           @"card_type":@"ENETS",
                           @"created_at":@"",
                           @"last_4":@"",
                           @"first_6":@"",
                           @"image_url":@""
                           };
    
    return dict;
}

- (NSString *) getTxnRequestWithMID :(NSString *) mid paymentAmount:(NSNumber*)paymentAmount paymentRef:(NSString *)paymentRef{
    
    NSDate * currentDateTime                    = [[NSDate alloc] init];
    
    NSDateFormatter * merchantTxnDtmFormatter   = [[NSDateFormatter alloc] init];
    merchantTxnDtmFormatter.dateFormat = @"yyyyMMdd HH:mm:ss.SSS";
    merchantTxnDtmFormatter.timeZone = [NSTimeZone timeZoneWithName:@"SGT"];
    
    NSString * merchantTxnDtm = [merchantTxnDtmFormatter stringFromDate:currentDateTime];
    NSDictionary * jsonObject = @{
                                  @"ss": @"1",
                                  @"msg" : @{ @"netsMid" : mid,
                                              @"submissionMode" : @"B",
                                              @"txnAmount" : paymentAmount,
                                              @"merchantTxnRef" : paymentRef,
                                              @"merchantTxnDtm" : merchantTxnDtm,
                                              @"paymentType" : @"SALE",
                                              @"currencyCode" : @"SGD",
                                              @"merchantTimeZone" : @"+8",
                                              @"b2sTxnEndURL" : @"",
                                              @"s2sTxnEndURL" : NETSPAY_S2S,
                                              @"clientType" : @"S",
                                              @"netsMidIndicator" : @"U",
                                              @"ipAddress" : NETSPAY_INCOMING_REQUEST_IP,
                                              @"language" : @"en",
                                              @"mobileOS" : @"IOS",
                                              @"ss" : @"1"
                                              
                                              }
                                  };
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                        options:0
                                                          error:&error];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
