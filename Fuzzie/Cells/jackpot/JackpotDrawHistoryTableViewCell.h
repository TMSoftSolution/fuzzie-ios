//
//  JackpotDrawHistoryTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackpotPinLabel.h"

@interface JackpotDrawHistoryTableViewCell : UITableViewCell

@property (assign, nonatomic) int position;
@property (weak, nonatomic) IBOutlet UILabel *lbRank;
@property (weak, nonatomic) IBOutlet UILabel *lbPrize;
@property (weak, nonatomic) IBOutlet UILabel *lbRankCaption;
@property (weak, nonatomic) IBOutlet UILabel *lbNoDraw;
@property (weak, nonatomic) IBOutlet JackpotPinLabel *lb4D;
@property (weak, nonatomic) IBOutlet UILabel *lbWon;

- (void)setCell:(NSDictionary*)prize position:(int)position matched:(BOOL)matched;

@end
