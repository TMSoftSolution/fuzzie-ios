//
//  TopUpTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TopUpTableViewCell.h"

@implementation TopUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.containerView withCornerRadius:2.0f withBorderColor:[UIColor colorWithHexString:@"#E2E2E2"] withBorderWidth:1.0f];
    [CommonUtilities setView:self.btnBuy withBackground:[UIColor colorWithHexString:@"#FA3E3F"] withRadius:4.0f];
}

- (void)setCell:(NSNumber*)price position:(NSInteger)position{
    if (price) {
        self.price = price;
        
        UIImage *image;
        if (position == 0) {
            image = [UIImage imageNamed:@"icon-top-up-one"];
            self.seperatorLeftAnchor.constant = 15.0f;
        } else if (position == 1){
            image = [UIImage imageNamed:@"icon-top-up-two"];
            self.seperatorLeftAnchor.constant = 15.0f;
        } else{
            image = [UIImage imageNamed:@"icon-top-up-three"];
            self.seperatorLeftAnchor.constant = 0.0f;
        }
        
        [self.ivFuzzie setImage:image];
        
        self.lbPrice.text = [NSString stringWithFormat:@"S$%d", [price intValue]];
    }
}

- (IBAction)buyButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buyButtonPressed:)]) {
        [self.delegate buyButtonPressed:self.price];
    }
}

@end
