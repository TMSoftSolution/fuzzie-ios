//
//  GiftingAvailableView.m
//  Fuzzie
//
//  Created by mac on 7/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftingAvailableView.h"

@implementation GiftingAvailableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Surprise friends with a warm & fuzzy gift card from their favourite brands. Delivery is instant!"];
    
//    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13] range: NSMakeRange(62,11)];
//    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13] range: NSMakeRange(102,3)];
//    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13] range: NSMakeRange(116,7)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    
    [self.bodyLabel setAttributedText:string];
    
    [CommonUtilities setView:self.gotItButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    
}

- (IBAction)gotItButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotItButtonPressed)]) {
        [self.delegate gotItButtonPressed];
    }
}

- (IBAction)howItWorkButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(howItWorkButtonPressed)]) {
        [self.delegate howItWorkButtonPressed];
    }
}
@end
