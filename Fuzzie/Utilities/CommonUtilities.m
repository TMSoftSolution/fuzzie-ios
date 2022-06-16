//
//  CommonUtilities.m
//  Fuzzie
//
//  Created by mac on 6/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "CommonUtilities.h"

@implementation CommonUtilities

+ (instancetype)sharedInstance {
    static CommonUtilities *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[CommonUtilities alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

+ (BOOL)validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validatePhone: (NSString *)candidate {
    NSString *phoneRegex = @"[0-9]{8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return ([phoneTest evaluateWithObject:candidate]) && ([candidate hasPrefix:@"3"] || [candidate hasPrefix:@"8"] || [candidate hasPrefix:@"9"] || [candidate hasPrefix:@"2"]);
}

+ (void)setView:(UIView*)view withCornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (void)setView:(UIView*)view withCornerRadius:(CGFloat)radius withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWidth{
    view.layer.cornerRadius = radius;
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.layer.masksToBounds = YES;
}

+(void)setView:(UIView *)view withBackground:(UIColor *)backgroundColor withRadius:(CGFloat)radius{
    [view setBackgroundColor:backgroundColor];
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (void)setView:(UIView *)view withBackground:(UIColor *)backgroundColor withRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)width{
    [view setBackgroundColor:backgroundColor];
    view.layer.cornerRadius = radius;
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = width;
    view.layer.masksToBounds = YES;
}

+ (NSDate*)calcCouponDrawTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"SGT"]];
    
    NSDateComponents *currentDateCopmonent = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    NSDateComponents *newDateComponent = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    newDateComponent.hour = 19;
    newDateComponent.minute = 0;
    newDateComponent.second = 0;
    newDateComponent.weekday = 6;
    
    if (newDateComponent.weekday < currentDateCopmonent.weekday) {
        newDateComponent.weekOfYear = currentDateCopmonent.weekOfYear + 1;
        newDateComponent.day = newDateComponent.day + 7;
        if (newDateComponent.weekOfYear > 52) {
            newDateComponent.weekOfYear = 1;
        }
    } else if (newDateComponent.weekday == currentDateCopmonent.weekday){
        if (newDateComponent.hour <= currentDateCopmonent.hour) {
            newDateComponent.weekOfYear = currentDateCopmonent.weekOfYear + 1;
            newDateComponent.day = newDateComponent.day + 7;
            if (newDateComponent.weekOfYear > 52) {
                newDateComponent.weekOfYear = 1;
            }
        }
    } else{
        newDateComponent.weekOfYear = currentDateCopmonent.weekOfYear;
    }
    
    if (newDateComponent.weekOfYear < currentDateCopmonent.weekOfYear) {
        newDateComponent.year = currentDateCopmonent.year + 1;
    } else{
        newDateComponent.year = currentDateCopmonent.year;
    }
    
    NSDate *drawDate = [calendar dateFromComponents:newDateComponent];
//    DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,drawDate);
    
//    int interval = [drawDate timeIntervalSinceDate:[NSDate date]];
//    DDLogVerbose(@"%@: %@, %d",THIS_FILE,THIS_METHOD,interval);

    
    return drawDate;
    
}

+ (void)setJackpotPinView:(UIView *)view{
    view.backgroundColor = [UIColor colorWithHexString:@"#323232"];
    view.layer.cornerRadius = 4.0f;
    view.layer.borderColor = [UIColor colorWithHexString:@"#5B5B5B"].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f].CGColor;
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    view.layer.shadowRadius = 9.0f;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;

}

+ (void)setJackpotPinView:(UIView*)view withBackgroundColor:(UIColor*)backgroundColor withBorderColor:(UIColor*)borderColor {
    view.backgroundColor = backgroundColor;
    view.layer.cornerRadius = 4.0f;
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f].CGColor;
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    view.layer.shadowRadius = 9.0f;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.layer.masksToBounds = true;
}

+ (NSData *)getDataForGifImage:(NSString *)gifName{
    NSString* path = [[NSBundle mainBundle] pathForResource: gifName ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    return gifData;
}

+ (NSAttributedString*)getFormattedValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize{
    
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:smallFontSize]};
    NSDictionary *lightAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_LIGHT size:fontSize]};
    
    NSString *value;
    if ([price floatValue] - [price intValue] != 0) {
        value = [NSString stringWithFormat:@"S$%.2f", [price floatValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
    } else{
        value = [NSString stringWithFormat:@"S$%d", [price intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    [attributedString setAttributes:lightAttributes range:[value rangeOfString:@"S$"]];

    return attributedString;
}

+ (NSAttributedString*)getFormattedCashbackValue:(NSNumber*)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize{
    
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:smallFontSize]};
    
    NSString *value;
    if ([price floatValue] - [price intValue] != 0) {
        value = [NSString stringWithFormat:@"S$%.2f", [price floatValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
    } else{
        value = [NSString stringWithFormat:@"S$%d", [price intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    
    return attributedString;
}

+ (NSAttributedString *)getFormattedTotalValue:(NSNumber *)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize symbol:(NSString *)symbol{
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:smallFontSize]};
    
    NSString *value;
    if ([price floatValue] - [price intValue] != 0) {
        value = [NSString stringWithFormat:@"%@S$%.2f", symbol, [price floatValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
    } else{
        value = [NSString stringWithFormat:@"%@S$%d", symbol, [price intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    
    return attributedString;
}

+ (NSAttributedString *)getFormattedPaymentSuccessValue:(NSNumber *)price fontSize:(CGFloat)fontSize smallFontSize:(CGFloat)smallFontSize{

    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:smallFontSize]};
    NSDictionary *lightAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_LIGHT size:fontSize]};
    
    NSString *value;
    if ([price floatValue] - [price intValue] != 0) {
        value = [NSString stringWithFormat:@"+S$%.2f", [price floatValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
    } else{
        value = [NSString stringWithFormat:@"+S$%d", [price intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    [attributedString setAttributes:lightAttributes range:[value rangeOfString:@"+S$"]];
    
    return attributedString;
}

+ (NSAttributedString *)getFormattedValueWithPrice:(NSNumber *)price mainFontName:(NSString *)mainFontName mainFontSize:(CGFloat)mainFontSize secondFontName:(NSString *)secondFontName secondFontSize:(CGFloat)secondFontSize symboFontName:(NSString *)symbolFontName symbolFontSize:(CGFloat)symbolFontSize{
    
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:mainFontName size:mainFontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:secondFontName size:secondFontSize]};
    NSDictionary *symbolAttributes = @{NSFontAttributeName:[UIFont fontWithName:symbolFontName size:symbolFontSize]};
    
    NSString *value;
    if ([price floatValue] - [price intValue] != 0) {
        value = [NSString stringWithFormat:@"S$%.2f", [price floatValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
    } else{
        value = [NSString stringWithFormat:@"S$%d", [price intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    
    [attributedString setAttributes:symbolAttributes range:[value rangeOfString:@"S$"]];
    
    return attributedString;
    
}

+ (NSAttributedString *)getFormattedCashbackPercentage:percentage fontSize:(CGFloat)fontSize decimalFontSize:(CGFloat)decimalFontSize{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSNumber *number = [formatter numberFromString:[formatter stringFromNumber:percentage]];
    
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:decimalFontSize]};

    NSString *value;
    
    if ([number floatValue] - [number intValue] != 0) {
        
        value = [NSString stringWithFormat:@"%@%%", [number stringValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
        
    } else{
        
        value = [NSString stringWithFormat:@"%d%%", [number intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    
    [attributedString setAttributes:normalAttributes range:[value rangeOfString:@"%"]];
    
    return attributedString;
}

+ (NSAttributedString *)getFormattedPowerUpPercentage:(NSNumber *)percentage fontSize:(CGFloat)fontSize decimalFontSize:(CGFloat)decimalFontSize{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSNumber *number = [formatter numberFromString:[formatter stringFromNumber:percentage]];
    
    NSMutableAttributedString *attributedString;
    
    NSDictionary *normalAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:fontSize]};
    NSDictionary *smallAttributes = @{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:decimalFontSize]};
    
    NSString *value;
    
    if ([number floatValue] - [number intValue] != 0) {
        
        value = [NSString stringWithFormat:@"+%@%%", [number stringValue]];
        NSRange range = [value rangeOfString:@"."];
        range.length = value.length - range.location;
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
        [attributedString setAttributes:smallAttributes range:range];
        
    } else{
        
        value = [NSString stringWithFormat:@"+%d%%", [number intValue]];
        attributedString = [[NSMutableAttributedString alloc] initWithString:value attributes:normalAttributes];
    }
    
    [attributedString setAttributes:normalAttributes range:[value rangeOfString:@"%"]];
    
    return attributedString;
}

+ (NSString *)getDecimalString:(NSNumber *)number{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSNumber *roundedNumber = [formatter numberFromString:[formatter stringFromNumber:number]];

    return [roundedNumber floatValue] - [roundedNumber intValue] != 0 ? roundedNumber.stringValue: [NSString stringWithFormat:@"%.0f", roundedNumber.floatValue];
}

+ (PaymentCardType)getPaymentCardType:(NSString *)cardNumber{
    
    NSString *visaRegex = @"^4[0-9]{6,}$";
    NSPredicate *visaPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", visaRegex];
    
    NSString *masterRegex = @"^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$";
    NSPredicate *masterPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", masterRegex];
    
    NSString *amexRegex = @"^3[47][0-9]{5,}$";
    NSPredicate *amexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", amexRegex];
    
    if ([visaPredicate evaluateWithObject:cardNumber]) {
        
        return PaymentCardTypeVisa;
        
    } else if ([masterPredicate evaluateWithObject:cardNumber]){
        
        return PaymentCardTypeMaster;
        
    } else if ([amexPredicate evaluateWithObject:cardNumber]){
        
        return PaymentCardTypeAmex;
    }
    
    return PaymentCardTypeNone;
}

+ (UIImage *)getPaymentCardImage:(PaymentCardType)paymentCardType{
    
    switch (paymentCardType) {
        case PaymentCardTypeVisa:
            return [UIImage imageNamed:@"card_visa"];
            break;
        case PaymentCardTypeMaster:
            return [UIImage imageNamed:@"card_master"];
            break;
        case PaymentCardTypeAmex:
            return [UIImage imageNamed:@"card_amex"];
            break;
        case PaymentCardTypeNone:
            return [UIImage imageNamed:@"card_default"];
            break;
        default:
            return [UIImage imageNamed:@"card_default"];
            break;
    }
}

+(NSString *)genRandomString:(int)length{
    
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
