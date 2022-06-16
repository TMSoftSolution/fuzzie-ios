//
//  JackpotLiveDrawViewController.h
//  Fuzzie
//
//  Created by mac on 9/27/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTNumberScrollAnimatedView.h"

@interface JackpotLiveDrawViewController : FZBaseViewController

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSArray *prizes;
@property (nonatomic, strong) NSArray *prizesTickets;
@property (nonatomic, strong) NSArray *myTickets;

@property (nonatomic, strong) NSDictionary *liveDrawResult;
@property (nonatomic, strong) NSDictionary *latestWinning;
@property (nonatomic, strong) NSDictionary *currentWinning;
@property (nonatomic, strong) NSDictionary *nextPrize;
@property (nonatomic, strong) NSDictionary *prevPrize;
@property (assign, nonatomic) BOOL isNext;
@property (assign, nonatomic) BOOL isFirst;

@property (nonatomic, strong) NSString *youtubeId;

@property (strong, nonatomic) NSTimer *timer;

@end
