//
//  JackpotHeaderView.m
//  Fuzzie
//
//  Created by mac on 9/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotHeaderView.h"

@implementation JackpotHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
  
    NSString *string = @"Win S$150,000 cash prizes every Wed & Sat, 6.35pm. Jackpot tickets are given FREE with every purchase below.";
    NSString *subString = @"Win S$150,000 cash prizes every Wed & Sat, 6.35pm.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:12.0f]}];
    NSRange range = [string rangeOfString:subString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:12.0f] range:range];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    self.lbBody.attributedText = attributedString;
    
    [CommonUtilities setView:self.btnLiveDraw withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

+ (CGFloat)estimateHeight{
    
    CGFloat height = 0.0f;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *string = @"Win S$150,000 cash prizes every Saturday, 6.35pm. Jackpot tickets are given FREE with every purchase below.";
    NSString *subString = @"Win S$150,000 cash prizes every Saturday, 6.35pm.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:12.0f]}];
    NSRange range = [string rangeOfString:subString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BLACK size:12.0f] range:range];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(screenWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    if (![FZData sharedInstance].isLiveDraw) {
        height = screenWidth * 0.5875 * 29 / 47 + rect.size.height + 285;
    } else{
        height = screenWidth * 0.5875 * 29 / 47 + rect.size.height + 250;
    }
    
    return height;
}

- (IBAction)learnMoreButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(learnMoreButtonPressed)]) {
        [self.delegate learnMoreButtonPressed];
    }
}

- (IBAction)liveDrawButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveDrawButtonPressed)]) {
        [self.delegate liveDrawButtonPressed];
    }
}

- (void)startTimer{

    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            NSDate *drawTime = [dateFormatter dateFromString:[FZData sharedInstance].jackpotDrawTime];
            NSDate *now = [NSDate date];
            
            if ([drawTime secondsFrom:now] > 0) {
                int days = (int)[drawTime daysFrom:now];
                int hours = [drawTime hoursFrom:now];
                hours %= 24;
                int minutes = [drawTime minutesFrom:now];
                minutes %= 60;
                int seconds = [drawTime secondsFrom:now];
                seconds %= 60;
                
                self.lbDay.text = [NSString stringWithFormat:@"%02d", days];
                self.lbHour.text = [NSString stringWithFormat:@"%02d", hours];
                self.lbMin.text = [NSString stringWithFormat:@"%02d", minutes];
                self.lbSec.text = [NSString stringWithFormat:@"%02d", seconds];
                
                
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

- (void)updateLiveDrawState{
    [self startTimer];
    if ([FZData sharedInstance].isLiveDraw) {
        self.timeContainerHeightAnchor.constant = 0;
        self.btnLiveDrawHeightAnchor.constant = 50;
        [self endTimer];
    } else{
        self.timeContainerHeightAnchor.constant = 81;
        self.btnLiveDrawHeightAnchor.constant = 0;
        [self startTimer];
    }
}


@end
