//
//  JackpotTicketsTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/24/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketsTableViewCell.h"
#import "JackpotTicketsCollectionViewCell.h"
#import "SDVersion.h"

@implementation JackpotTicketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"JackpotTicketsCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    [CommonUtilities setView:self.btnViewResult withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

+ (CGFloat)estimateHeight:(NSDictionary *)result{
    
    CGFloat height = 150.0f;
    
    NSArray *tickets = result[@"my_combinations"];

    int cellRowCount ;
    if ([SDVersion deviceSize] >= Screen4Dot7inch){
        cellRowCount = (int)ceilf(tickets.count / 5.0f);
    } else {
        cellRowCount = (int)ceilf(tickets.count/4.0f);
    }
    
    if (cellRowCount == 0) {
        
        return height + 10;
        
    } else{
        
        return height + cellRowCount * 48.0f;
    }
    
}

- (void)setCell:(NSDictionary *)result{
    if (result) {
        
        self.result = result;
        
        self.ticketsArray = result[@"my_combinations"];
        if (self.ticketsArray.count == 0) {
            self.collectionView.hidden = YES;
            self.lbNote.hidden = NO;
        } else{
            self.collectionView.hidden = NO;
            self.lbNote.hidden = YES;
        }
        
        NSArray *prizes = result[@"prizes"];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *prize in prizes) {
            [temp addObject:prize[@"four_d"]];
        }
        self.prizeTicketsArray = temp;
        [self.collectionView reloadData];
        
        NSUInteger ticketCount = 0;
        for (NSArray *tickets in self.ticketsArray) {
            ticketCount = ticketCount + tickets.count;
        }
        
        self.lbTicketsCount.text = [NSString stringWithFormat:@"JACKPOT TICKETS USED: %lu/%d", ticketCount, [FZData sharedInstance].ticketsLimitPerWeek];
        
        NSString *drawDateString = result[@"draw_time"];
        NSDate *drawDate = [[GlobalConstants standardFormatter] dateFromString:drawDateString];
        NSDate *now = [NSDate date];
        
        self.drawId = self.result[@"id"];
        
        if ([FZData sharedInstance].isLiveDraw && [self.drawId isEqual:[FZData sharedInstance].jackpotDrawId]) {
            
            self.lbLeftTime.hidden = YES;
            self.btnViewResult.hidden = NO;
            
        } else if ([drawDate secondsFrom:now] > 0) {
            
            self.lbLeftTime.hidden = NO;
            self.btnViewResult.hidden = YES;
            [self startTimer];
            
        } else{
            self.lbLeftTime.hidden = YES;
            self.btnViewResult.hidden = NO;
        }
        
        self.lbDrawTime.text = [[GlobalConstants jackpotDrawHistoryFormatter] stringFromDate:drawDate];
    }
}

- (void)startTimer{
    
    if (self.result[@"draw_time"] && [self.result[@"draw_time"] isKindOfClass:[NSString class]] && ![self.result[@"draw_time"] isEqualToString:@""]) {
        if (!self.timer) {
            self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
                
                NSDate *drawTime = [[GlobalConstants standardFormatter] dateFromString:self.result[@"draw_time"]];
                NSDate *now = [NSDate date];
                
                if ([drawTime secondsFrom:now] > 0) {
                    int days = (int)[drawTime daysFrom:now];
                    int hours = [drawTime hoursFrom:now];
                    hours %= 24;
                    int minutes = [drawTime minutesFrom:now];
                    minutes %= 60;
                    int seconds = [drawTime secondsFrom:now];
                    seconds %= 60;
                    NSString *leftTime = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", days, hours, minutes, seconds];
                    
                    self.lbLeftTime.text = leftTime;
                    
                } else {
                    
                    self.lbLeftTime.hidden = YES;
                    self.btnViewResult.hidden = NO;
                }
                
            } repeats:YES];
        }
    }
   
}

- (void)endTimer{
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (IBAction)viewButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveButtonPressed)]) {
        [self.delegate liveButtonPressed];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ticketsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JackpotTicketsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *tickets = [self.ticketsArray objectAtIndex:indexPath.row];
    NSString *ticket = [tickets firstObject];
    [cell setCell:ticket count:tickets.count matched:[self.prizeTicketsArray containsObject:ticket]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70.0f, 47.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 15);
}

- (void)dealloc{
    [self endTimer];
}

@end
