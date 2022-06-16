//
//  CommonUtilities.h
//  Fuzzie
//
//  Created by mac on 6/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PaymentCardTypeVisa,
    PaymentCardTypeMaster,
    PaymentCardTypeAmex,
    PaymentCardTypeNone
} PaymentCardType;

@interface CommonUtilities : NSObject

+ (instancetype)sharedInstance;

+ (BOOL)validatePhone: (NSString *)candidate ;
+ (BOOL)validateEmail: (NSString *)candidate;
+ (void)setView:(UIView*)view withCornerRadius:(CGFloat)radius;
+ (void)setView:(UIView*)view withCornerRadius:(CGFloat)radius withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWidth;
+ (void)setView:(UIView*)view withBackground:(UIColor*)backgroundColor withRadius:(CGFloat)radius;
+ (void)setView:(UIView*)view withBackground:(UIColor*)backgroundColor withRadius:(CGFloat)radius withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)width;
+ (NSDate*)calcCouponDrawTime;
+ (void)setJackpotPinView:(UIView*)view;
+ (void)setJackpotPinView:(UIView*)view withBackgroundColor:(UIColor*)backgroundColor withBorderColor:(UIColor*)borderColor;
+ (NSData*)getDataForGifImage:(NSString*)gifName;
+ (NSAttributedString*)getFormattedValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize;
+ (NSAttributedString*)getFormattedCashbackValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize;
+ (NSAttributedString*)getFormattedTotalValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize symbol:(NSString*)symbol;
+ (NSAttributedString*)getFormattedPaymentSuccessValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize;
+ (NSAttributedString*)getFormattedValueWithPrice:(NSNumber*)price mainFontName:(NSString*)mainFontName mainFontSize:(CGFloat)mainFontSize secondFontName:(NSString*)secondFontName secondFontSize:(CGFloat)secondFontSize symboFontName:(NSString*)symbolFontName symbolFontSize:(CGFloat)symbolFontSize;
+ (NSAttributedString*)getFormattedCashbackPercentage:(NSNumber*)percentage fontSize:(CGFloat)fontSize decimalFontSize:(CGFloat)decimalFontSize;
+ (NSAttributedString*)getFormattedPowerUpPercentage:(NSNumber*)percentage fontSize:(CGFloat)fontSize decimalFontSize:(CGFloat)decimalFontSize;
+ (NSString*)getDecimalString:(NSNumber*)number;

+ (PaymentCardType)getPaymentCardType:(NSString*)cardNumber;
+ (UIImage*)getPaymentCardImage:(PaymentCardType)paymentCardType;

+ (NSString*)genRandomString:(int)length;

@end
