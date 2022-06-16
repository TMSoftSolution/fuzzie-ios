//
//  FZTimer.h
//  Fuzzie
//
//  Created by mac on 8/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZTimer : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSTimer *timer;

- (void)checkRedeeming;
- (void)startTimer;
- (void)endTimer;
- (NSMutableArray*)getGiftsWithRedeeming;

@end
