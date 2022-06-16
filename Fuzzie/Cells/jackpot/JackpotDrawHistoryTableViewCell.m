//
//  JackpotDrawHistoryTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotDrawHistoryTableViewCell.h"

@implementation JackpotDrawHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#212121"];

}

- (void)setCell:(NSDictionary *)prize position:(int)position matched:(BOOL)matched{
    
    self.position = position;
    
    self.lbRank.text = [NSString stringWithFormat:@"%d", position + 1];
    
    if (position == 0) {
        [CommonUtilities setView:self.lbRank withBackground:[UIColor colorWithHexString:@"#FFC212"] withRadius:10.0f];
    } else if (position == 1){
        [CommonUtilities setView:self.lbRank withBackground:[UIColor colorWithHexString:@"#EFEFEF"] withRadius:10.0f];
    } else if (position == 2){
        [CommonUtilities setView:self.lbRank withBackground:[UIColor colorWithHexString:@"#D66100"] withRadius:10.0f];
    } else {
        [CommonUtilities setView:self.lbRank withBackground:[UIColor colorWithHexString:@"#747474"] withRadius:10.0f];
    }
    
    if (prize[@"name"] && [prize[@"name"] isKindOfClass:[NSString class]]) {
        self.lbRankCaption.text = prize[@"name"];
    } else {
        self.lbRankCaption.text = @"";
    }
    
    NSString *fourD = prize[@"four_d"];
    if (![fourD isKindOfClass:[NSNull class]] && ![fourD isEqualToString:@""]) {
        self.lb4D.text = fourD;
        self.lb4D.hidden = NO;
        self.lbNoDraw.hidden = YES;
        if (matched) {
            [CommonUtilities setJackpotPinView:self.lb4D withBackgroundColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderColor:[UIColor colorWithHexString:@"#D02F30"]];
            self.lbWon.hidden = NO;
        } else {
            [CommonUtilities setJackpotPinView:self.lb4D withBackgroundColor:[UIColor colorWithHexString:@"#323232"] withBorderColor:[UIColor colorWithHexString:@"#5B5B5B"]];
            self.lbWon.hidden = YES;
        }
    } else {
        self.lb4D.hidden = YES;
        self.lbNoDraw.hidden = NO;
        self.lbWon.hidden = YES;
    }
    
    NSNumber *amount = prize[@"amount"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.lbPrize.text = [NSString stringWithFormat:@"S$%@", [formatter stringFromNumber:amount]];
    
}

@end
