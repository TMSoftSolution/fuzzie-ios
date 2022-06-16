//
//  GiftBoxPowerUpCardTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/10/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "GiftBoxPowerUpCardTableViewCell.h"

@implementation GiftBoxPowerUpCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)setCell:(NSDictionary *)giftDict{
    
    if (giftDict) {
        
        self.giftDict = giftDict;
        
        if ([self.giftDict[@"time_to_expire"] intValue] == 1) {
            self.lbName.text = @"Power Up Card - 1 hour";
        } else {
            self.lbName.text = [NSString stringWithFormat:@"Power Up Card - %d hours", [self.giftDict[@"time_to_expire"] intValue]];
        }
        
        if([self.giftDict[@"opened"] boolValue] || [self.giftDict[@"expired"] boolValue]){
            
            self.ivNew.hidden = YES;
            
        } else {
            
            self.ivNew.hidden = NO;
        }
        
    }
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(powerUpCardCellTapped:)]) {
        
        if (self.giftDict) {
            
            if(![self.giftDict[@"opened"] boolValue]){
                self.ivNew.hidden = YES;
                
            }
   
            [self.delegate powerUpCardCellTapped:self.giftDict];
            
        }
        
    }
}
@end
