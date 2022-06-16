//
//  JackpotTicketCollectionViewCell.m
//  Fuzzie
//
//  Created by mac on 9/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotTicketCollectionViewCell.h"

@implementation JackpotTicketCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.lbX withBackground:[UIColor colorWithHexString:@"#323232"] withRadius:self.lbX.bounds.size.width/2 withBorderColor:[UIColor colorWithHexString:@"#5B5B5B"] withBorderWidth:1.0f];
}

- (void)setCell:(NSArray *)array{
    
    if (array) {
        
        if (array.count == 1) {
            self.lbX.hidden = YES;
            self.lbXHeightAnchor.constant = 0.0f;
            self.lbXWidthAnchor.constant = 0.0f;
            self.lbPinLeftAnchor.constant = 0.0f;
        } else{
            self.lbX.hidden = NO;
            self.lbXHeightAnchor.constant = 21.0f;
            self.lbXWidthAnchor.constant = 21.0f;
            self.lbPinLeftAnchor.constant = 12.0f;
            self.lbX.text = [NSString stringWithFormat:@"%luX", (unsigned long)array.count];
        }
        
        self.lbPin.text = [array firstObject];

    }
}

- (void)setCell:(NSString *)ticket count:(NSUInteger)count matched:(BOOL)matched{
    self.lbPin.text = ticket;
    
    if (matched) {
        [CommonUtilities setJackpotPinView:self.lbPin withBackgroundColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderColor:[UIColor colorWithHexString:@"#D02F30"]];
    } else {
        [CommonUtilities setJackpotPinView:self.lbPin withBackgroundColor:[UIColor colorWithHexString:@"#323232"] withBorderColor:[UIColor colorWithHexString:@"#5B5B5B"]];
    }
    
    if (count > 1) {
        self.lbX.hidden = NO;
        self.lbX.text = [NSString stringWithFormat:@"%ldX", count];
    } else{
        self.lbX.hidden = YES;
    }
}

@end
