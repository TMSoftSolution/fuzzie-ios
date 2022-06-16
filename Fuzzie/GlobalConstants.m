//
//  GlobalConstants.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GlobalConstants.h"

@implementation GlobalConstants

+ (NSDateFormatter *)dateApiFormatter {
    static NSDateFormatter *dateApiFormat;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateApiFormat = [[NSDateFormatter alloc] init];
        [dateApiFormat setDateFormat:@"YYYY-MM-dd"];
    });
    return dateApiFormat;
}

+ (NSDateFormatter *)dateBirthdayShortStringFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateBirthdayLongStringFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM YYYY"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateBirthdayUpcomingFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateOrderHistoryFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM YYYY h:mma"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)standardFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)jackpotDrawHistoryFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE d MMM YYYY, h.mma"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)jackpotChooseFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE d MMMM YYYY"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)jackpotPaySuccessFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE (dd/MM), h.mma."];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)jackpotTicketsValidFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMMM YYYY"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)redeemStartEndFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM YYYY"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)clubOfferRedeemDateFormatter{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM"];
    });
    return dateFormatter;
}

+ (UIStoryboard *)mainStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)extraStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Extra" bundle:nil];
}

+ (UIStoryboard *)brandStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Brand" bundle:nil];
}

+ (UIStoryboard *)rateStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Rate" bundle:nil];
}

+ (UIStoryboard *)paymentStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Payment" bundle:nil];
}

+ (UIStoryboard *)brandFilterStoryboard{
    
    return [UIStoryboard storyboardWithName:@"BrandFilter" bundle:nil];
}

+ (UIStoryboard *)topUpStoryboard{
    
    return [UIStoryboard storyboardWithName:@"TopUp" bundle:nil];
}

+ (UIStoryboard *)jackpotStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Jackpot" bundle:nil];
}

+ (UIStoryboard *)redPacketsStoryboard{
    
    return [UIStoryboard storyboardWithName:@"RedPackets" bundle:nil];
}

+ (UIStoryboard *)clubStoryboard{
    
    return [UIStoryboard storyboardWithName:@"Club" bundle:nil];
}

@end
