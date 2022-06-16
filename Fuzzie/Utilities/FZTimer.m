//
//  FZTimer.m
//  Fuzzie
//
//  Created by mac on 8/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZTimer.h"

@implementation FZTimer

+ (instancetype)sharedInstance {
    static FZTimer *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[FZTimer alloc] init];
    });
    
    return __sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)checkRedeeming{
    if ([self getGiftsWithRedeeming].count > 0) {
        [self startTimer];
    } else{
        [self endTimer];
    }
}

- (void)startTimer{
    
    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
            for (NSDictionary *dict in [self getGiftsWithRedeeming]) {
                
                NSDate *redeemStartDate = [[GlobalConstants standardFormatter] dateFromString:dict[@"redeem_timer_started_at"]];
                
                if (redeemStartDate && ![redeemStartDate isEqual:[NSNull null]]) {
                    
                    NSDate *now = [NSDate date];
                    int seconds = [now secondsFrom:redeemStartDate];
//                    DDLogVerbose(@"%@: %@, %d",THIS_FILE,THIS_METHOD,seconds);
//                    DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,dict[@"id"]);

                    if (seconds >= REDEEM_COUNT_TIME && ![FZData sharedInstance].activeOnlineRedeemGiftPage) {
                        [GiftController markAsRedeemedForGiftCard:dict[@"id"] withCompletion:^(NSDictionary *dictionary, NSError *error) {
                           
                            // Remove This Gift from ActiveGifts
                            [FZData removeActiveGift:dict];
                            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                            
                            // Add callback Gift to the UsedGifts
                            if (dictionary && dictionary[@"gift"]) {

                                if (![FZData alreadyExistUsedGift:dictionary[@"gift"]]) {
                                    [[FZData sharedInstance].usedGiftBox insertObject:dictionary[@"gift"] atIndex:0];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
                                }
                            }
                    
                        }];
                    }
                    
                }
            }
            
        } repeats:YES];
    }
    
}

- (void)endTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSMutableArray*)getGiftsWithRedeeming{
    NSMutableArray *gifts = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [FZData sharedInstance].activeGiftBox) {
        if (dict[@"redeem_timer_started_at"] && ![dict[@"redeem_timer_started_at"] isKindOfClass:[NSNull class]]) {
            if (dict[@"redeemed_time"] && [dict[@"redeemed_time"] isKindOfClass:[NSNull class]]){
                [gifts addObject:dict];
//                DDLogVerbose(@"%@: %@, %@",THIS_FILE,THIS_METHOD,dict[@"id"]);
            }
        }
    }
    
    return gifts;
}

@end
