//
//  HomeJackpotTeasingTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 11/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "HomeJackpotTeasingTableViewCell.h"

@implementation HomeJackpotTeasingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnLearnMore withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

+ (CGFloat)estimateHeight{
    
    CGFloat height = 0.0;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat logoHeight = screenSize.size.width * 105 / 320;
    
    NSString *string = @"The game everyone's been waiting for.";
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:12] range: NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.1;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    CGFloat width = screenSize.size.width - 30;;
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    height = logoHeight + rect.size.height + 200.0f;
    
    return height;
    
}

- (IBAction)learnMoreButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jackpotLearnMoreButtonPressed)]) {
        [self.delegate jackpotLearnMoreButtonPressed];
    }
}


@end
