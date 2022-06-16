//
//  MainActionBrandTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "MainActionBrandTableViewCell.h"

@implementation MainActionBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [CommonUtilities setView:self.buyItButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    [CommonUtilities setView:self.giftButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (IBAction)buyItTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buyItTapped)]) {
        [self.delegate buyItTapped];
    }
}

- (IBAction)giftItTappped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(giftItTapped)]) {
        [self.delegate giftItTapped];
    }
}

- (void)enabledButtonsWithAnimation:(BOOL)animation {
    
    if (animation) {
  
        [UIView animateWithDuration:0.2 animations:^{
            
             [CommonUtilities setView:self.buyItButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
            
             [CommonUtilities setView:self.giftButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
            
        } completion:nil];
    } else {
        
         [CommonUtilities setView:self.buyItButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
        
        [CommonUtilities setView:self.giftButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    }

}

- (void)disabledButtonsWithAnimation:(BOOL)animation {
    
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
      
            [CommonUtilities setView:self.buyItButton withBackground:[UIColor colorWithHexString:@"#DEDEDE"] withRadius:4.0f];
            
            [CommonUtilities setView:self.giftButton withBackground:[UIColor colorWithHexString:@"#DEDEDE"] withRadius:4.0f];
            
        } completion:nil];
    } else {
        
        [CommonUtilities setView:self.buyItButton withBackground:[UIColor colorWithHexString:@"#DEDEDE"] withRadius:4.0f];
        
        [CommonUtilities setView:self.giftButton withBackground:[UIColor colorWithHexString:@"#DEDEDE"] withRadius:4.0f];
    }

}

@end
