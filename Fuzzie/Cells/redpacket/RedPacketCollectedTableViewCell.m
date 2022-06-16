//
//  RedPacketCollectedTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketCollectedTableViewCell.h"

@implementation RedPacketCollectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(CGFloat)credit ticket:(int)ticket{
    
    NSNumber *total = [NSNumber numberWithFloat:credit];
    self.lbCredit.attributedText = [CommonUtilities getFormattedValueWithPrice:total mainFontName:FONT_NAME_LATO_BLACK mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:13.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:16.0f];
    
    self.lbTicket.text = [NSString stringWithFormat:@"X%d", ticket];
}

@end
