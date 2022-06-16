//
//  JackpotDrawHistoryViewController.h
//  Fuzzie
//
//  Created by mac on 9/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotDrawHistoryViewController : FZBaseViewController

@property (nonatomic, strong) NSMutableArray *jackpotResults;
@property (nonatomic, strong) NSDictionary *selectedResult;
@property (nonatomic, strong) NSArray *selectedResultPrizes;
@property (nonatomic, strong) NSString *selectedDrawTime;
@property (nonatomic, strong) NSArray *ticketsArray;
@property (strong, nonatomic) NSArray *prizeTicketsArray;
@property (assign, nonatomic) int selectedPosition;
@property (assign, nonatomic) BOOL showLastResult;

@end
