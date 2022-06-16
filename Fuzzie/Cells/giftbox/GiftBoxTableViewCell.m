//
//  GiftBoxTableViewCell.m
//  Fuzzie
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftBoxTableViewCell.h"

@implementation GiftBoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    [self setStyle];
}

- (void)setCell:(NSDictionary *)dict{
    
    self.giftDict = dict;
    
    if (dict[@"gifted"] && ![dict[@"gifted"] isKindOfClass:[NSNull class]] && [dict[@"gifted"] boolValue]) {
        
        self.senderInfoHeightAnchor.constant = 30;
        
        if (dict[@"sent"] && ![dict[@"sent"] isKindOfClass:[NSNull class]] && [dict[@"sent"] boolValue]){
            self.sendLabel.text = @"Send to: ";
            self.senderName.text = dict[@"receiver"][@"name"];
            self.sendStateLabel.hidden = NO;
            if (dict[@"delivered"] && ![dict[@"delivered"] isKindOfClass:[NSNull class]] && [dict[@"delivered"] boolValue]){
                self.sendStateLabel.text = @"  SENT  ";
                [CommonUtilities setView:self.sendStateLabel withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:3.0f];
            } else{
                self.sendStateLabel.text = @"  NOT SENT YET  ";
                [CommonUtilities setView:self.sendStateLabel withBackground:[UIColor colorWithHexString:@"#ADADAD"] withRadius:3.0f];
            }
        } else{
            self.sendLabel.text = @"Received from: ";
            self.senderName.text = dict[@"sender"][@"name"];
            self.sendStateLabel.hidden = YES;
        }
        
    } else{
        self.senderInfoHeightAnchor.constant = 0;
    }
    
    NSURL *imageURL = [NSURL URLWithString:self.giftDict[@"image"]];
    [self.giftImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    
    
    if (dict[@"gift_card"] && ![dict[@"gift_card"] isKindOfClass:[NSNull class]]) {
        
        self.giftName.text =  self.giftDict[@"gift_card"][@"display_name"];
        self.giftPrice.attributedText = [CommonUtilities getFormattedValueWithPrice:dict[@"gift_card"][@"discounted_price"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
    } else if (dict[@"service"] && ![dict[@"service"] isKindOfClass:[NSNull class]]) {
        
        self.giftName.text = self.giftDict[@"service"][@"display_name"];
        self.giftPrice.attributedText = [CommonUtilities getFormattedValueWithPrice:dict[@"service"][@"discounted_price"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
    }
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    }
    
    NSDate *date;
    
    self.imageNew.hidden = YES;
    self.imageGifting.hidden = YES;
    self.imageGift.hidden = YES;
    
    if (dict[@"used"] && [dict[@"used"] boolValue]) {
        if (dict[@"redeem_timer_started_at"] && [dict[@"redeem_timer_started_at"] isKindOfClass:[NSString class]]) {
            date = [dateFormatter dateFromString:dict[@"redeem_timer_started_at"]];
        } else{
            date = [dateFormatter dateFromString:dict[@"redeemed_time"]];
        }
        
        self.giftBoughtDay.text = [NSString stringWithFormat:@"Redeemed %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES ] lowercaseString]];
        self.giftBoughtDay.textColor = [UIColor colorWithHexString:@"ADADAD"];

    } else{
        NSDate *redeemStartDate = dict[@"redeem_timer_started_at"];
        if (redeemStartDate && ![redeemStartDate isEqual:[NSNull null]]) {
            
            self.giftBoughtDay.text = @"Redeeming...";
            self.giftBoughtDay.textColor = [UIColor colorWithHexString:@"FA3E3F"];
            
        } else {
            
            if(dict[@"opened"] && ![dict[@"opened"] isKindOfClass:[NSNull class]] && ![dict[@"opened"] boolValue]){
                if (dict[@"gifted"] && ![dict[@"gifted"] isKindOfClass:[NSNull class]] && [dict[@"gifted"] boolValue] && ![dict[@"expired"] boolValue]) {
                    self.imageGift.hidden = NO;
                    self.imageNew.hidden = YES;
                } else{
                    self.imageGift.hidden = YES;
                    self.imageNew.hidden = NO;
                }
                
            }
            
            date = [dateFormatter dateFromString:dict[@"sent_time"]];
            self.giftBoughtDay.textColor = [UIColor colorWithHexString:@"ADADAD"];

            if (dict[@"gifted"] && ![dict[@"gifted"] isKindOfClass:[NSNull class]] && [dict[@"gifted"] boolValue]) {
                
                self.imageGifting.hidden = NO;
                self.giftBoughtDay.text = [NSString stringWithFormat:@"Received %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES ] lowercaseString]];
                
            } else{
                
                self.giftBoughtDay.text = [NSString stringWithFormat:@"Bought %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES ] lowercaseString]];
                
            }
        }
        
    }
    
    if (dict[@"gifted"] && ![dict[@"gifted"] isKindOfClass:[NSNull class]] && [dict[@"gifted"] boolValue]) {
         if (dict[@"sent"] && ![dict[@"sent"] isKindOfClass:[NSNull class]] && [dict[@"sent"] boolValue]){
             date = [dateFormatter dateFromString:dict[@"sent_time"]];
             self.imageGifting.hidden = YES;
             self.giftBoughtDay.text = [NSString stringWithFormat:@"Bought %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES ] lowercaseString]];
             self.imageGift.hidden = YES;

         }
    }

}

- (void)setStyle{
    self.giftImage.layer.masksToBounds = YES;
    self.giftImage.layer.cornerRadius = 2.0f;
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(cellTapped:isSent:)]) {
        
        if (self.giftDict) {
            
            if(self.giftDict[@"opened"] && ![self.giftDict[@"opened"] isKindOfClass:[NSNull class]] && ![self.giftDict[@"opened"] boolValue]){
                self.imageNew.hidden = YES;
                self.imageGift.hidden = YES;
                
            }
            
            BOOL isSent = false;
            
            if (self.giftDict[@"gifted"] && ![self.giftDict[@"gifted"] isKindOfClass:[NSNull class]] && [self.giftDict[@"gifted"] boolValue]) {
                
                if (self.giftDict[@"sent"] && ![self.giftDict[@"sent"] isKindOfClass:[NSNull class]] && [self.giftDict[@"sent"] boolValue]){
                    isSent = true;
                }
            }
            
            [self.delegate cellTapped:self.giftDict isSent:isSent];
            
        }
      
    }
}

@end
