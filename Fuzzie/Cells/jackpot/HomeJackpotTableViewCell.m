//
//  HomeJackpotTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "HomeJackpotTableViewCell.h"

@implementation HomeJackpotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnEnter withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.btnViewAll withCornerRadius:4.0f withBorderColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f] withBorderWidth:1.0f];
    
    NSString *string = @"Win S$150,000 cash prizes every Wed & Sat, 6.35pm. Enter now to get your free Jackpot tickets.";
    NSString *subString = @"Win S$150,000 cash prizes every Wed & Sat, 6.35pm. ";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_LATO_REGULAR size:13.0f]}];
    NSRange range = [string rangeOfString:subString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_NAME_LATO_BOLD size:13.0f] range:range];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.lineHeightMultiple = 1.3;
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    self.lbBody.attributedText = attributedString;
    
    [CommonUtilities setView:self.liveView withBackground:[UIColor clearColor] withRadius:21.0f withBorderColor:[UIColor colorWithHexString:@"#737373"] withBorderWidth:0.5f];
    [CommonUtilities setView:self.livePoint withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

+ (CGFloat)estimageHeight{
    CGFloat height = 0.0;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat logoWidth = screenSize.size.width - 30.0f;
    
    if (![FZData sharedInstance].isLiveDraw) {
        height = logoWidth * 148 / 290 + 275.0f;
    } else {
        height = logoWidth * 148 / 290 + 225.0f;
    }
    
    return height;
}
- (IBAction)liveButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveDrawButtonPressed)]) {
        [self.delegate liveDrawButtonPressed];
    }
}

- (IBAction)enterButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jackpotEnterButtonPressed)]) {
        [self.delegate jackpotEnterButtonPressed];
    }
}

- (IBAction)viewAllButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jackpotViewAllButtonPressed)]) {
        [self.delegate jackpotViewAllButtonPressed];
    }
}

- (void)startTimer{
    
    if (!self.timer) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
            
            NSDate *drawTime = [[GlobalConstants standardFormatter] dateFromString:[FZData sharedInstance].jackpotDrawTime];
            NSDate *now = [NSDate date];
            
            if ([drawTime secondsFrom:now] > 0) {
                int days = (int)[drawTime daysFrom:now];
                int hours = [drawTime hoursFrom:now];
                hours %= 24;
                int minutes = [drawTime minutesFrom:now];
                minutes %= 60;
                int seconds = [drawTime secondsFrom:now];
                seconds %= 60;
                NSString *leftTime = [NSString stringWithFormat:@"%02d : %02d : %02d : %02d", days, hours, minutes, seconds];

                self.lbDrawTime.text = leftTime;

            } else {
                NSString *leftTime = [NSString stringWithFormat:@"00 : 00 : 00 : 00"];
                self.lbDrawTime.text = leftTime;
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
    if ([FZData sharedInstance].isLiveDraw) {
        self.lbBody.hidden = YES;
        self.liveView.hidden = NO;
        [self endTimer];
    } else {
        self.lbBody.hidden = NO;
        self.liveView.hidden = YES;
        if ([FZData sharedInstance].enableJackpot) {
            [self startTimer];
        }
    }
}

@end
